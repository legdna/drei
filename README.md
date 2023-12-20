# drei - DaVinci Resolve Easy Installer (Alpha)

**Caution: This project is currently in the alpha stage. Use with care and expect potential issues.**

**drei** is a bash script designed to simplify the installation process of DaVinci Resolve on Linux distributions. The script utilizes containerization to ensure a consistent environment across different systems.

## Features

- **Interactive Setup**: The script interactively guides users through the installation process.
- **Distribution Support**: Supports Debian, Fedora, Arch Linux, and their equivalents.
- **Containerized Environment**: Uses `distrobox` to create a containerized environment for installing DaVinci Resolve.
- **Dependency Management**: Automatically installs necessary dependencies based on the user's Linux distribution.

## Compatibility

- **AMD Only** (Nvidia is working progress)

## Usage

```bash
git clone https://github.com/legdna/drei
cd drei
chmod +x ./drei.sh
./drei.sh
```

Follow the on-screen instructions to complete the installation.

**Note: This project is in the alpha stage, and issues may arise during installation or usage. Use with caution, and consider backing up important data before running the script. Contributions and bug reports are highly appreciated.**
