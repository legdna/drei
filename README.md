# drei - DaVinci Resolve Easy Installer (Beta)

[![fr](https://img.shields.io/badge/langue-français-blue.svg)](https://github.com/legdna/drei/blob/main/README.fr.md)

> [!CAUTION]
> This project is currently in the beta stage. Use with care and expect potential issues.**

**drei** is a bash script designed to simplify the installation process of DaVinci Resolve on Linux distributions. The script utilizes containerization to ensure a consistent environment across different systems.

![Preview](https://github.com/legdna/drei/blob/main/preview-en.png)

## Features

- **Interactive Setup**: The script interactively guides users through the installation process.
- **Distribution Support**: Supports Debian, Fedora, Arch Linux, OpenSUSE and their equivalents.
- **Containerized Environment**: Uses `distrobox` to create a containerized environment for installing DaVinci Resolve.
- **Dependency Management**: Automatically installs necessary dependencies based on the user's Linux distribution.

## Compatibility

- **AMD GPUs**
- **NVIDIA GPUs**
- **biGPUs (OPTIMUS, iGPU + dGPU, ...)**

- **Intel-only GPUs are not supported by DaVinci Resolve**

## Usage

```bash
git clone https://github.com/legdna/drei
cd drei
chmod +x ./drei.sh
./drei.sh
```

Follow the on-screen instructions to complete the installation.

> [!NOTE]
> This project is in the beta stage, and issues may arise during installation or usage. Use with caution, and consider backing up important data before running the script. Contributions and bug reports are highly appreciated.**
