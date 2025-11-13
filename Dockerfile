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
  nmap \
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

# Create a symbolic link for batcat to be used as bat
RUN ln -s /usr/bin/batcat /usr/bin/bat

# Install postgres 16 client
RUN wget -qO - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
  && echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
  && apt-get update \
  && apt-get install -y postgresql-client-16 \
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

# Install opencode
RUN curl -fsSL https://opencode.ai/install | bash

# Install Copitot CLI
RUN npm install -g @github/copilot

# Install Gemini CLI
RUN npm install -g @google/gemini-cli

# Install Github CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
  dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg

RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | \
  tee /etc/apt/sources.list.d/github-cli.list > /dev/null

RUN apt-get update && \
  apt-get install -y gh && \
  rm -rf /var/lib/apt/lists/*

# Install lazygit
RUN LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[0-9.]+') && \
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" && \
  tar xf lazygit.tar.gz -C /usr/local/bin lazygit && \
  rm lazygit.tar.gz

# Install Neovim from APPImage
RUN apt-get update && apt-get install -y --no-install-recommends \
  curl \
  software-properties-common \
  # Instala el resto de tus dependencias aquí, si no están ya en otro paso
  libtree-sitter-dev \
  fzf \
  ripgrep \
  fd-find \
  xclip \
  imagemagick \
  ghostscript \
  texlive-latex-extra \
  libsqlite3-dev \
  luarocks \
  lua5.1 \
  && rm -rf /var/lib/apt/lists/*

# 2. Descargar el AppImage con el nombre de archivo completo.
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage

# 3. Crear el directorio público y mover el AppImage a su ubicación final.
RUN mkdir -p /opt/nvim \
  && mv nvim-linux-x86_64.appimage /usr/local/bin/nvim

# 4. Asignar permisos de ejecución a todos los usuarios.
RUN chmod a+x /usr/local/bin/nvim

# set regional settings for Neovim
RUN locale-gen en_US.UTF-8

# Export locale environment variables
RUN export LANG=en_US.UTF-8 && \
  export LANGUAGE=en_US:en && \
  export LC_ALL=en_US.UTF-8

# Install node and python providers for Neovim
RUN pip3 install --no-cache-dir pynvim \
  && npm install -g neovim \
  && npm install -g @mermaid-js/mermaid-cli

# Intall libtree-sitter
RUN npm install -g tree-sitter-cli


# Optional: Install Ansible (uncomment if needed)
# RUN pip3 install --no-cache-dir ansible "ansible[azure]"

# Set the default working directory
WORKDIR /workspace

# Set the default shell to zsh
CMD ["/bin/zsh"]
