# Start from a basic Ubuntu image
FROM ubuntu:20.04

# Avoid prompts from apt
ARG DEBIAN_FRONTEND=noninteractive

# Install curl, unzip, and other necessary packages, which are needed to download and extract Terraform
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    git \
    wget \
    bash \
    software-properties-common \
    lsb-release \
    bash-completion \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables for versions
ARG TERRAFORM_VERSION=1.7.4
ARG TERRAGRUNT_VERSION=0.28.1

# Install Terraform
RUN curl -Lo terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    unzip terraform.zip -d /usr/local/bin && \
    rm terraform.zip && \
    curl -Lo terragrunt "https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64" && \
    chmod +x terragrunt && \
    mv terragrunt /usr/local/bin && \
    curl -L "$(curl -s https://api.github.com/repos/tenable/terrascan/releases/latest | grep -o -E "https://.+?_Linux_x86_64.tar.gz")" > terrascan.tar.gz && \
    tar -xf terrascan.tar.gz terrascan && rm terrascan.tar.gz && \
    install terrascan /usr/local/bin && rm terrascan && \
    wget https://releases.hashicorp.com/packer/1.7.2/packer_1.7.2_linux_amd64.zip && \
    unzip packer_1.7.2_linux_amd64.zip && mv packer /usr/local/bin/ && \
    packer -autocomplete-install

CMD ["tail", "-f", "/dev/null"]
