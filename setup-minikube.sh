#!/bin/bash

# This script will:
# 1. Check and install dependencies
# 2. Install Docker if not present
# 3. Install kubectl if not present
# 4. Install Minikube if not present
# 5. Configure and start Minikube with Docker driver

set -e 

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Install system dependencies
install_dependencies() {
  
  # Update package lists
  apt-get update || { echo "ERROR: Failed to update package lists"; exit 1; }
  
  # Install required packages
  PACKAGES="apt-transport-https ca-certificates curl software-properties-common gnupg lsb-release"
  apt-get install -y $PACKAGES
}

# Install Docker if not already installed
install_docker() {
  if command_exists docker; then
    echo "INFO: Docker is already installed: $(docker --version)"
  else
    echo "INFO: Installing Docker..."
    
    # Add Docker's official GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    
    # Set up the stable repository
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Install Docker Engine
    apt-get update
    apt-get install -y docker-ce docker-ce-cli containerd.io
    
    # Add current user to docker group to avoid using sudo
    usermod -aG docker $USER
    
    echo "INFO: Docker installed successfully"
    echo "WARNING: You may need to log out and log back in for group changes to take effect."
  fi
  
  # Ensure Docker service is running
  if ! systemctl is-active --quiet docker; then
    echo "INFO: Starting Docker service..."
    systemctl start docker
  fi
}

# Install kubectl if not already installed
install_kubectl() {
  if command_exists kubectl; then
    echo "INFO: kubectl is already installed"
  else
    echo "INFO: Installing kubectl..."
    
    # Download the latest release
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    
    # Install kubectl
    chmod +x kubectl
    mv kubectl /usr/local/bin/
  fi
}

# Install Minikube if not already installed
install_minikube() {
  if command_exists minikube; then
    echo "INFO: Minikube is already installed"
  else
    echo "INFO: Installing Minikube..."
    
    # Download the latest release
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    
    # Install minikube
    chmod +x minikube-linux-amd64
    mv minikube-linux-amd64 /usr/local/bin/minikube
  fi
}

# Configure and start Minikube
start_minikube() {
  echo "INFO: Starting Minikube with Docker driver..."
  
  # Check if Minikube is already running
  if minikube status &>/dev/null; then
    echo "INFO: Minikube is already running."
  else
    # Start Minikube with Docker driver
    minikube start --driver=docker
  fi
  
  # Configure kubectl to use Minikube
  kubectl config use-context minikube
}

# Main execution
main() {
  # Check if script is run as root
  if [ "$(id -u)" -ne 0 ]; then
    echo "ERROR: This script must be run as root (sudo). Exiting."
    exit 1
  fi
  
  echo "INFO: Starting Minikube setup in WSL..."
  
  # Run all setup functions
  install_dependencies
  install_docker
  install_kubectl
  install_minikube
  
  # Start Minikube as the non-root user
  SUDO_USER_HOME=$(eval echo ~${SUDO_USER})
  echo "INFO: Switching to user ${SUDO_USER} to start Minikube..."
  su - ${SUDO_USER} -c "export HOME=${SUDO_USER_HOME} && $(declare -f start_minikube) && start_minikube"
  
  echo "INFO: Minikube setup complete! You can now deploy your application."
  echo "INFO: Run 'minikube dashboard' to access the Kubernetes dashboard."
}

# Execute main function
main 