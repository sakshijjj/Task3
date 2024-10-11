#!/bin/bash

EC2_PUBLIC_IP=$(terraform output -raw WebClues_ec2_public_ip)


if [ -z "$EC2_PUBLIC_IP" ]; then
  echo "Could not retrieve EC2 public IP from Terraform output."
  exit 1
fi

cat <<EOF > inventory.yaml
all:
  hosts:
    web:
      ansible_host: $EC2_PUBLIC_IP
      ansible_user: ubuntu
      ansible_ssh_private_key_file: /root/Mumbai.pem
EOF

echo "inventory.yaml has been created."

ansible-playbook -i inventory.yaml playbook.yaml