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
    ansible \
    python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

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

# Update package list again to include Microsoft repository
RUN apt-get update

# Install PowerShell
RUN apt-get install -y powershell

# Install Node.js LTS using NodeSource repository
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs

# Install Taskfile
RUN sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b ~/.local/bin

# Set the default working directory for when the container starts.
WORKDIR /home/user

# Set the default shell to bash.
CMD ["/bin/bash"]