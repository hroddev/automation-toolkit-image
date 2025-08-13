# Use the latest LTS (Long-Term Support) version of Ubuntu as the base image.
FROM ubuntu:22.04


# Image maintainer 
LABEL maintainer="Hector Rodriguez <hector@helixcloud.dev>"

# Prevents the system from asking for confirmation during package installation.
ENV DEBIAN_FRONTEND=noninteractive

# Updates the package index and installs necessary tools.
# wget and unzip are for Terraform installation.
# git is useful for cloning project repositories.
# ansible is the configuration management tool.
# python3-pip is needed to install Ansible modules from PyPI.
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    unzip \
    git \
    software-properties-common \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Python 3.12 from deadsnakes PPA
RUN add-apt-repository ppa:deadsnakes/ppa -y \
    && apt-get update \
    && apt-get install -y \
    python3.12 \
    python3.12-venv \
    python3.12-dev \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install pip for Python 3.12
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
    && python3.12 get-pip.py \
    && rm get-pip.py

# Set Python 3.12 as the default python3
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1 \
    && update-alternatives --install /usr/bin/pip3 pip3 /usr/local/bin/pip3.12 1

# Install Ansible using pip3 (now pointing to Python 3.12)
RUN pip3 install ansible

# Install Terraform binary version 1.8.5.
# You can change the version as needed.
RUN wget https://releases.hashicorp.com/terraform/1.8.5/terraform_1.8.5_linux_amd64.zip \
    && unzip terraform_1.8.5_linux_amd64.zip \
    && mv terraform /usr/local/bin/ \
    && rm terraform_1.8.5_linux_amd64.zip

# Install Ansible modules to work with Azure.
# This is very important if your workflow is on Azure.
RUN pip3 install "ansible[azure]"

# Add Azure CLI installation
# Reference: https://learn.microsoft.com/es-es/cli/azure/install-azure-cli-linux?pivots=apt
RUN apt-get update && apt-get install -y \
    curl \
    lsb-release \
    gnupg \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

RUN az extension add --name azure-devops 

# Install prerequisites for Microsoft repository
RUN apt-get update && apt-get install -y \
    wget \
    apt-transport-https \
    software-properties-common \
    ca-certificates

# Download and register Microsoft GPG key and repository
RUN wget -q "https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb" \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb

# Install the Azure Functions Core Tools
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg \
    && mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg \
    && sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-$(lsb_release -cs 2>/dev/null)-prod $(lsb_release -cs 2>/dev/null) main" > /etc/apt/sources.list.d/dotnetdev.list' \
    && apt-get update && apt-get install -y azure-functions-core-tools-4

# Update package list again to include Microsoft repository
RUN apt-get update

# Install PowerShell
RUN apt-get install -y powershell

# Install Node.js LTS using NodeSource repository
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs

# Set the default working directory for when the container starts.
WORKDIR /home/user

# Set the default shell to bash.
CMD ["/bin/bash"]