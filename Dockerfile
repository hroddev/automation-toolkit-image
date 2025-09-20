# Use official Python image with 3.10 and Debian Bullseye
FROM python:3.10-bullseye

# Image maintainer
LABEL maintainer="Hector Rodriguez <hector@helixcloud.dev>"

# Updates the package index and installs necessary tools.
RUN apt-get update && apt-get install -y \
  wget \
  gnupg \
  unzip \
  git \
  software-properties-common \
  curl \
  lsb-release \
  ca-certificates \
  apt-transport-https \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install Ansible using pip (Python 3.10)
RUN pip install ansible

# Install Terraform binary version 1.8.5.
RUN wget https://releases.hashicorp.com/terraform/1.8.5/terraform_1.8.5_linux_amd64.zip \
  && unzip terraform_1.8.5_linux_amd64.zip \
  && mv terraform /usr/local/bin/ \
  && rm terraform_1.8.5_linux_amd64.zip

# Install Ansible modules to work with Azure.
RUN pip install "ansible[azure]"

# Add Azure CLI installation
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash
RUN az extension add --name azure-devops

# Download and register Microsoft GPG key and repository
RUN wget -q "https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb" \
  && dpkg -i packages-microsoft-prod.deb \
  && rm packages-microsoft-prod.deb

# Install the Azure Functions Core Tools
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg \
  && mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg \
  && sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-bullseye-prod bullseye main" > /etc/apt/sources.list.d/dotnetdev.list' \
  && apt-get update && apt-get install -y azure-functions-core-tools-4

# Install PowerShell
RUN apt-get install -y powershell

# Install Node.js LTS using NodeSource repository
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
  && apt-get install -y nodejs

# Install Taskfile
RUN sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b ~/.local/bin

# Set the default working directory for when the container starts.
WORKDIR /home/user

# Install Starship
RUN curl -sS https://starship.rs/install.sh | sh -s -- --yes
# Set the default shell to bash.
CMD ["/bin/bash"]
