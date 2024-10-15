#!/bin/bash

# Variables
TERRAFORM_VERSION="1.9.7"  # Set the latest Terraform version here
DOWNLOAD_URL="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"

# Functions

install_dependencies() {
    echo "Installing required dependencies..."
    sudo apt-get update -y
    sudo apt-get install -y curl unzip gnupg software-properties-common
}

fix_broken_packages() {
    echo "Fixing broken packages..."
    sudo apt --fix-broken install -y
}

add_hashicorp_gpg_key() {
    echo "Adding HashiCorp GPG key..."
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt-get update
}

download_terraform() {
    echo "Downloading Terraform v$TERRAFORM_VERSION..."
    curl -O $DOWNLOAD_URL
    if [ $? -ne 0 ]; then
        echo "Error downloading Terraform. Please check your network connection or the URL."
        exit 1
    fi
}

install_terraform() {
    echo "Installing Terraform..."
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
    sudo mv terraform /usr/local/bin/
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip
}

verify_installation() {
    echo "Verifying Terraform installation..."
    terraform -v
    if [ $? -eq 0 ]; then
        echo "Terraform v$TERRAFORM_VERSION installed successfully."
    else
        echo "Terraform installation failed!"
        exit 1
    fi
}

# Main execution

echo "Starting Terraform installation script..."

install_dependencies
fix_broken_packages
add_hashicorp_gpg_key
download_terraform
install_terraform
verify_installation

echo "Terraform installation completed successfully!"
