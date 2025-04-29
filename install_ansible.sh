#!/bin/bash

# Exit immediately if a command fails
set -e

echo "🔄 Updating package list..."
sudo apt-get update -y
sudo apt-get upgrade -y

echo "📦 Installing required dependencies..."
sudo apt-get install -y software-properties-common

echo "➕ Adding Ansible PPA and installing Ansible..."
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt-get install -y ansible

echo "🐍 Ensuring Python is installed (required by Ansible)..."
sudo apt-get install -y python3 python3-pip

echo "✅ Verifying Ansible installation..."
ansible --version

echo "🎉 Ansible installation completed successfully."
