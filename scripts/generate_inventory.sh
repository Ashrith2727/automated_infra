#!/bin/bash
set -e

VM_IP=$(terraform -chdir=terraform output -raw vm_ip)

cat > inventory/production.ini <<EOF
[servers]
automated-infra ansible_host=${VM_IP} ansible_user=devops
EOF

echo "Inventory generated with IP: ${VM_IP}"
