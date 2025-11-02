# Use official Ubuntu Toolbox image
FROM quay.io/toolbx/ubuntu-toolbox:22.04

# Updates the package index and installs necessary tools
RUN apt-get update && apt-get install -y \
  wget \
  gnupg \
  unzip \
  git \
  software-properties-common \
  curl \
  jq \
  bat \
  zsh \
  zoxide \
  python3.10 \
  python3.10-dev \
  python3-pip \
  lsb-release \
  ca-certificates \
  apt-transport-https \
  && mkdir -p /etc/apt/keyrings \
  && curl -fsSL https://repo.charm.sh/apt/gpg.key | gpg --dearmor -o /etc/apt/keyrings/charm.gpg \
  && echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | tee /etc/apt/sources.list.d/charm.list \
  && apt-get update \
  && apt-get install -y glow \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install Terraform binary version 1.8.5
RUN wget https://releases.hashicorp.com/terraform/1.8.5/terraform_1.8.5_linux_amd64.zip \
  && unzip terraform_1.8.5_linux_amd64.zip \
  && mv terraform /usr/local/bin/ \
  && chmod +x /usr/local/bin/terraform \
  && rm terraform_1.8.5_linux_amd64.zip

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Add Azure DevOps extension
RUN az extension add --name azure-devops

# Download and register Microsoft GPG key and repository for Ubuntu 22.04
RUN wget -q "https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb" \
  && dpkg -i packages-microsoft-prod.deb \
  && rm packages-microsoft-prod.deb

# Install Azure Functions Core Tools and PowerShell
RUN apt-get update \
  && apt-get install -y azure-functions-core-tools-4 powershell \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install Node.js LTS using NodeSource repository
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
  && apt-get install -y nodejs \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install Taskfile (fixed path for system-wide installation)
RUN sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin

# Install Starship
RUN curl -sS https://starship.rs/install.sh | sh -s -- --yes

# Install Gemini CLI
RUN npm install -g @google/gemini-cli

# Install Neovim from unstable PPA (required for LazyVim)
RUN apt-get update && apt-get install -y software-properties-common \
  && add-apt-repository ppa:neovim-ppa/unstable -y \
  && apt-get update \
  && apt-get install -y \
  neovim \
  ripgrep \
  fd-find \
  xclip \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Optional: Install Ansible (uncomment if needed)
# RUN pip3 install --no-cache-dir ansible "ansible[azure]"

# Set the default working directory
WORKDIR /workspace

# Set the default shell to zsh
CMD ["/bin/zsh"]