# Automation Toolbox Image

This project provides a Dockerfile to build a powerful automation toolbox container based on **Debian 11 (Bullseye)** with Python 3.10. The image includes essential tools for DevOps, automation, and cloud workflows, such as:

- Ansible (with Azure modules)
- Terraform (v1.8.5)
- Azure CLI (with Azure DevOps extension)
- PowerShell
- Node.js LTS (with npm)
- Git, wget, unzip, curl, and more
- Taskfile
- Azure Functions Core Tools

## Features
- Ready-to-use for infrastructure automation and cloud management
- Supports Azure workflows out of the box
- Easily extensible for your own needs

## Usage on Windows and Linux

- **Linux:**
  - Follow the build and usage instructions above. You need Docker and Distrobox installed. Run the provided script or manual commands in your terminal.

- **Windows:**
  - Use [WSL2](https://docs.microsoft.com/en-us/windows/wsl/) (Windows Subsystem for Linux) with a supported Linux distribution (e.g., Ubuntu or Debian).
  - Install Docker Desktop for Windows and enable WSL2 integration.
  - Install Distrobox inside your WSL2 environment.
  - Run the build and usage commands from your WSL2 terminal as described above.

## How to Build and Use

A helper script [`build-and-deploy.sh`](build-and-deploy.sh) is provided to automate the build and container creation process using Docker and Distrobox.

### 1. Build the Image and Create the Container

```bash
./build-and-deploy.sh
```

This script will:
- Build the Docker image with Docker
- Remove any previous Distrobox container named `automation-toolbox`
- Create a new Distrobox container from the freshly built image

### 2. Enter the Container

After the script finishes, enter your toolbox with:

```bash
distrobox enter automation-toolbox
```

## Manual Steps (Alternative)
If you prefer to run the commands manually:

```bash
docker build -t automation-toolbox-image:latest .
distrobox rm --force automation-toolbox
# (ignore errors if the container does not exist)
distrobox create --name automation-toolbox --image automation-toolbox-image:latest
distrobox enter automation-toolbox
```

## How to Attach the Container with VS Code

You can use the [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension to open a shell or workspace inside your running container.

1. Start the container as described above.
2. In VS Code, press `F1` and select `Remote-Containers: Attach to Running Container...`.
3. Choose `automation-toolbox` from the list.

This allows you to use the full power of VS Code inside your automation toolbox environment.

## Requirements
- Docker
- Distrobox

## How to Install Distrobox

You can install Distrobox using your system's package manager or via the official script. For most Linux distributions:

```bash
curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sudo bash
```

For more details and alternative installation methods, see the official documentation: https://distrobox.it/

## Customization
You can modify the [`Dockerfile`](Dockerfile) to add more tools or change versions as needed for your workflow.

---

Maintainer: Hector# Automation Toolbox Image

This project provides a Dockerfile to build a powerful automation toolbox container based on Ubuntu 22.04 LTS. The image includes essential tools for DevOps, automation, and cloud workflows, such as:

- Ansible (with Azure modules)
- Terraform (v1.8.5)
- Azure CLI (with Azure DevOps extension)
- PowerShell
- Node.js LTS (with npm)
- Git, wget, unzip, curl, and more

## Features
- Ready-to-use for infrastructure automation and cloud management
- Supports Azure workflows out of the box
- Easily extensible for your own needs

## Usage on Windows and Linux

- **Linux:**
  - Follow the build and usage instructions above. You need Docker and Distrobox installed. Run the provided script or manual commands in your terminal.

- **Windows:**
  - Use [WSL2](https://docs.microsoft.com/en-us/windows/wsl/) (Windows Subsystem for Linux) with a supported Linux distribution (e.g., Ubuntu or Debian).
  - Install Docker Desktop for Windows and enable WSL2 integration.
  - Install Distrobox inside your WSL2 environment.
  - Run the build and usage commands from your WSL2 terminal as described above.

## How to Build and Use

A helper script `build-and-deploy.sh` is provided to automate the build and container creation process using Podman and Distrobox.

### 1. Build the Image and Create the Container

```bash
./build-and-deploy.sh
```

This script will:
- Build the Docker image with Podman
- Remove any previous Distrobox container named `automation-toolbox`
- Create a new Distrobox container from the freshly built image

### 2. Enter the Container

After the script finishes, enter your toolbox with:

```bash
distrobox enter automation-toolbox
```

## Manual Steps (Alternative)
If you prefer to run the commands manually:

```bash
podman build -t automation-toolbox-image:latest .
distrobox rm --force automation-toolbox
# (ignore errors if the container does not exist)
distrobox create --name automation-toolbox --image automation-toolbox-image:latest
distrobox enter automation-toolbox
```

## How to Attach the Container with VS Code

You can use the [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension to open a shell or workspace inside your running container.

1. Start the container as described above.
2. In VS Code, press `F1` and select `Remote-Containers: Attach to Running Container...`.
3. Choose `automation-toolbox` from the list.

This allows you to use the full power of VS Code inside your automation toolbox environment.

## Using Docker Instead of Podman

If you prefer Docker over Podman, you can use the same commands by replacing `podman` with `docker`:

```bash
docker build -t automation-toolbox-image:latest .
distrobox rm --force automation-toolbox
distrobox create --name automation-toolbox --image automation-toolbox-image:latest
distrobox enter automation-toolbox
```

All other steps remain the same.

## Requirements
- Podman
- Distrobox

## How to Install Distrobox

You can install Distrobox using your system's package manager or via the official script. For most Linux distributions:

```bash
curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sudo bash
```

For more details and alternative installation methods, see the official documentation: https://distrobox.it/

## Customization
You can modify the Dockerfile to add more tools or change versions as needed for your workflow.

---

Maintainer: Hector Rodriguez <hector@helixcloud.dev>
