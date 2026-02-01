#!/bin/bash
set -e

echo "🚀 Starting Automated Infra deployment..."

cd terraform
terraform init
terraform apply -auto-approve

cd ../ansible
ansible-playbook -i ../inventory/production.ini playbooks/site.yml

echo "✅ Automated Infra deployment completed"
