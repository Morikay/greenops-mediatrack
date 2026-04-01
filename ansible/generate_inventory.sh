#!/usr/bin/env bash
set -eu

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TERRAFORM_DIR="${PROJECT_ROOT}/terraform"
INVENTORY_FILE="${PROJECT_ROOT}/ansible/inventory.ini"

EC2_DNS="$(terraform -chdir="${TERRAFORM_DIR}" output -raw ec2_public_dns)"
KEY_FILE="$(terraform -chdir="${TERRAFORM_DIR}" output -raw ec2_private_key_file)"
ABS_KEY_FILE="$(cd "${TERRAFORM_DIR}" && realpath "${KEY_FILE}")"

cat > "${INVENTORY_FILE}" <<EOF
# Inventaire genere automatiquement depuis les outputs Terraform.
[web]
meditrack-web ansible_host=${EC2_DNS} ansible_user=ubuntu ansible_ssh_private_key_file=${ABS_KEY_FILE}
EOF

printf 'Inventaire mis a jour dans %s\n' "${INVENTORY_FILE}"
