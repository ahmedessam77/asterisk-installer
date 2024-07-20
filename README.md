# Asterisk Installer

This script automates the process of installing Asterisk PBX on an Ubuntu system. It checks for dependencies, downloads the specified version of Asterisk, and sets it up with necessary configurations. This guide will help you understand and use the script effectively.

## Usage

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/ahmedessam77/asterisk-installer
   cd asterisk-installer
   ```

2. **Run the Script**:
   ```bash
   sudo ./install.sh
   ```

## Prerequisites

Before running this script, ensure that:

- You are running Ubuntu (the script checks for this and will exit if the OS is not Ubuntu).
- You have root privileges to run the script (use `sudo` if necessary).
- You have a stable internet connection.

## Script Overview

The script performs the following steps:

1. **System Update and Upgrade**: Updates and upgrades the system's package lists.
2. **Installs Dependencies**: Installs necessary dependencies for building Asterisk.
3. **Downloads Asterisk**: Downloads the specified version of Asterisk.
4. **Extracts Asterisk**: Extracts the downloaded Asterisk tarball.
5. **Installs Additional Dependencies**: Installs additional dependencies required by Asterisk.
6. **Configures and Builds Asterisk**: Configures, builds, and installs Asterisk.
7. **Installs Sample Configuration Files**: Installs sample configuration files.
8. **Finalizes Installation**: Finalizes the installation and sets up Asterisk as a service.

## Variables

- **INSTALL_DIR**: Directory where Asterisk will be installed.
- **ASTERISK_VERSION**: Version of Asterisk to install.
- **DEPENDENCIES**: List of required packages.
- **ASTERISK_URL**: URL to download Asterisk from.
- **TEST_URL**: URL to check internet connection.

## Conclusion

This script simplifies the process of installing Asterisk on an Ubuntu system. By following the instructions provided, you can easily set up Asterisk and have it running in no time.

For any issues or contributions, please feel free to open an issue or submit a pull request on the repository.