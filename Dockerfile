FROM ubuntu:22.04

# Install basic tools
RUN apt-get update && apt-get install -y \
    curl wget unzip git python3 python3-pip docker.io \
    && apt-get clean

# Install Terraform
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list \
    && apt-get update && apt-get install -y terraform

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install Argo CD CLI
RUN curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64 \
    && chmod +x /usr/local/bin/argocd

# Install Trivy
RUN curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh

# Install Python dependencies
RUN pip install --upgrade pip && pip install pytest fastapi uvicorn

# Optional: Prometheus Node Exporter
RUN curl -LO https://github.com/prometheus/node_exporter/releases/latest/download/node_exporter-1.6.1.linux-amd64.tar.gz \
    && tar xvf node_exporter-*.tar.gz && mv node_exporter-*/node_exporter /usr/local/bin/

CMD ["/bin/bash"]
