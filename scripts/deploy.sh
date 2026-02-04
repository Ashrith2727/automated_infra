#!/bin/bash
set -e

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

echo "🚀 Starting automated_infra deployment"

terraform -chdir=terraform apply -auto-approve

VM_IP=$(terraform -chdir=terraform output -raw vm_ip)

cat > inventory/production.ini <<EOF
[servers]
automated-infra ansible_host=${VM_IP} ansible_user=devops
EOF

ansible-playbook \
  -i inventory/production.ini \
  ansible/playbooks/site.yml

echo "✅ Deployment completed successfully"
