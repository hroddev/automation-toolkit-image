# Automation Toolbox Image

This project provides a Dockerfile to build a powerful automation toolbox container based on **Ubuntu 22.04 LTS**. The image includes essential tools for DevOps, automation, and cloud workflows.

Toolbx is a tool for creating and managing interactive, containerized development environments on Linux. It allows users to run a full-featured Fedora (or other distribution) container that integrates seamlessly with the host system, making it easy to install development tools and dependencies without affecting the host.

Fedora BlueSilver is a variant of Fedora Silverblue, an immutable desktop operating system. Toolbx is especially useful on Fedora BlueSilver/Silverblue because it provides a mutable environment for development tasks.

Example usage on Fedora BlueSilver:

```sh
toolbox create --image fedora-toolbox:39
toolbox enter
```

## Features

- Ready-to-use for infrastructure automation and cloud management
- Supports Azure workflows out of the box
- Easily extensible for your own needs

## Tools Included

- Ansible (with Azure modules)
- Terraform (v1.8.5)
- Azure CLI (with Azure DevOps extension)
- PowerShell
- Node.js LTS (with npm)
- Git, wget, unzip, curl, and more
- Taskfile
- Azure Functions Core Tools
- Starship
- Gemini CLI
- Neovim (with LazyVim prerequisites)

## How to Build and Use

A helper script `build-and-deploy.sh` is provided to automate the build and container creation process using Docker and Distrobox.

### 1. Build the Image and Create the Container

```bash
./build-and-deploy.sh
```

This script will:

- Build the Docker image with Podman
- Create a new Toolbox container from the freshly built image

### 2. Enter the Container

After the script finishes, enter your toolbox with:

```bash
toolbox enter millennium-falcon
```

## Manual Steps (Alternative)

If you prefer to run the commands manually:

```bash
toolbox  build -t millennium-falcon:latest .
toolbox rm --force millennium-falcon
# (ignore errors if the container does not exist)
toolbox create --image millennium-falcon:latest millennium-falcon
toolbox enter millennium-falcon
```

````

## Using Podman Instead of Docker

If you prefer Podman over Docker, you can use the same commands by replacing `docker` with `podman`:

```bash
podman build -t millennium-falcon:latest .
toolbox rm --force millennium-falcon
toolbox create --image localhost/millennium-falcon:latest millennium-falcon
toolbox enter millennium-falcon
````

All other steps remain the same.

## Requirements

- Podman or Docker
- Toolbox

---

Maintainer: Hector Rodriguez <hector@helixcloud.dev>
