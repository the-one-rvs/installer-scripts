#!/bin/bash

# Define the version of kind you want to install
KIND_VERSION="v0.18.0"

# Function to check for errors and exit if any command fails
check_error() {
  if [ $? -ne 0 ]; then
    echo "Error occurred during: $1"
    exit 1
  fi
}

# Update package list and ignore errors from specific repositories
echo "Updating package list..."
sudo apt update 2>&1 | grep -v "https://ppa.launchpadcontent.net/3v1n0/libfprint-vfs0090/ubuntu jammy" || true

# Download kind binary
echo "Downloading kind version $KIND_VERSION..."
curl -Lo ./kind https://kind.sigs.k8s.io/dl/$KIND_VERSION/kind-linux-amd64
check_error "downloading kind"

# Make the binary executable
echo "Making kind executable..."
chmod +x ./kind
check_error "making kind executable"

# Move the binary to a directory in PATH
echo "Moving kind to /usr/local/bin..."
sudo mv ./kind /usr/local/bin/kind
check_error "moving kind to /usr/local/bin"

# Verify installation
echo "Verifying kind installation..."
kind --version
check_error "verifying kind installation"

# Create a kind cluster
echo "Creating a kind cluster..."
kind create cluster
check_error "creating kind cluster"

echo "kind installation and cluster creation complete!"
