# Automated Infra

Automated Infra is a local infrastructure automation platform that provisions
Linux virtual machines using Terraform and configures them using Ansible.

## Architecture
Terraform provisions a libvirt-based VM.
Ansible configures the operating system and services.

## Features
- Infrastructure as Code with Terraform
- Configuration management with Ansible
- SSH key-based access
- Docker installation
- Node Exporter for monitoring
- Reboot-safe automation

## Usage
```bash
./scripts/deploy.sh
#hello
