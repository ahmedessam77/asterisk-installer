#!/bin/bash
set -e
set -o pipefail

# Colors for output messages
YELLOW='\033[0;33m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variables for script configuration
INSTALL_DIR="/usr/local/src"
ASTERISK_VERSION="20"
DEPENDENCIES=(build-essential libncurses5-dev libssl-dev libxml2-dev libsqlite3-dev uuid-dev wget tar)
ASTERISK_URL="https://downloads.asterisk.org/pub/telephony/asterisk"
TEST_URL="https://www.google.com"

# Function to clean up temporary files
cleanup() {
    rm -rf "$INSTALL_DIR/asterisk-*" > /dev/null 2>&1
    rm -f "$INSTALL_DIR/asterisk-${ASTERISK_VERSION}-current.tar.gz" > /dev/null 2>&1
}

# Function to display progress messages
show_progress() {
    local message=$1
    echo -e "${YELLOW}${message}${NC}\r"
}

# Function to re-enable user input
restore_input() {
    stty echo
}

# Function to check and install dependencies
install_dependencies() {
    show_progress "Checking main dependencies..."
    for pkg in "${DEPENDENCIES[@]}"; do
        show_progress "Installing $pkg..."
        apt-get install -y "$pkg" > /dev/null 2>&1
    done
}

# Ensure cleanup on exit
trap cleanup EXIT

# Disable user input
stty -echo

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}This script must be run as root. Please use sudo.${NC}"
    restore_input
    exit 1
fi

# Check if the system is Ubuntu
if [[ "$(lsb_release -is)" != "Ubuntu" ]]; then
    echo -e "${RED}This script is designed to run on Ubuntu only.${NC}"
    restore_input
    exit 1
fi

# Check internet connection
if ! wget -q --spider "$TEST_URL"; then
    echo -e "${RED}No internet connection. Please check your network settings.${NC}"
    restore_input
    exit 1
fi

# Check if Asterisk is already installed
if command -v asterisk > /dev/null 2>&1; then
    echo -e "${GREEN}Asterisk is already installed.${NC}"
    restore_input
    exit 1
fi

# Clear the terminal screen at the start
clear

# Script header
echo -e "${BLUE}* Asterisk Installer *${NC}"

# Update the system package lists
show_progress "Updating the system package lists..."
apt-get update -y > /dev/null 2>&1

# Upgrade the installed packages
show_progress "Upgrading the installed packages..."
apt-get upgrade -y > /dev/null 2>&1

# Install necessary dependencies
install_dependencies

# Download Asterisk
show_progress "Downloading Asterisk version ${ASTERISK_VERSION}..."
cd "$INSTALL_DIR"
wget "$ASTERISK_URL/asterisk-${ASTERISK_VERSION}-current.tar.gz" > /dev/null 2>&1

# Extract Asterisk
show_progress "Extracting Asterisk..."
tar -zxvf "asterisk-${ASTERISK_VERSION}-current.tar.gz" > /dev/null 2>&1

# Navigate to the extracted Asterisk directory
cd asterisk-*/

# Install additional dependencies for Asterisk
show_progress "Installing additional dependencies required by Asterisk..."
contrib/scripts/install_prereq install > /dev/null 2>&1

# Configure Asterisk for building
show_progress "Configuring Asterisk for building..."
./configure > /dev/null 2>&1

# Build and install Asterisk
show_progress "Building and installing Asterisk..."
make -j"$(nproc)" > /dev/null 2>&1
make install > /dev/null 2>&1

# Install sample configuration files
show_progress "Installing sample configuration files..."
make samples > /dev/null 2>&1

# Finalize installation
show_progress "Finalizing installation..."
make config > /dev/null 2>&1
ldconfig > /dev/null 2>&1

# Enable and restart Asterisk service
show_progress "Enabling and restarting Asterisk service..."
systemctl enable asterisk > /dev/null 2>&1
systemctl restart asterisk > /dev/null 2>&1

# Confirm successful installation
echo -e "${GREEN}Asterisk PBX has been successfully installed!${NC}\n"

# Re-enable user input at the end of the script
restore_input
