#!/usr/bin/bash

PACKER_FLAG=false
ACTION_FLAG=false
DESTROY_FLAG=false

set -e

LOG_FILE="error_logs.txt"
touch "$LOG_FILE"
user=$(whoami)


log_error(){
    echo  "$(date '+%Y-%m-%d %H:%M:%S') - USER: $user ERROR: $1\n" >> "../$LOG_FILE"
}

while getopts "pad" flag; do
    case "${flag}" in 
        p) PACKER_FLAG=true ;;
        a) ACTION_FLAG=true ;;
        d) DESTROY_FLAG=true;;
        *) echo "A flag is unrecognized. Usage: $0 [-p] [-a]" ; exit 1;;
    esac
done  

if [ "$ACTION_FLAG" = true ] && [ "$DESTROY_FLAG" = true ]; then
    echo "The flags [-a] and [-d] cannot be used together!"
    exit 1
fi

if [ "$PACKER_FLAG" = true ]; then
    cd packer_configs
    if ! packer init . ; then
        log_error "Packer init failed"
        exit 1
    elif ! packer validate . ; then
        log_error "Packer validate failed"
        exit 1
    elif ! packer build . ; then
        log_error "Packer build failed!"
        exit 1
    fi
    cd ..
fi

if [ "$ACTION_FLAG" = true ]; then
    cd terraform_configs
    if ! terraform init  ; then
        log_error "Terraform init failed"
        exit 1
    elif ! terraform plan -out=tfplan -input=false; then
        log_error "Terraform plan failed"
        exit 1
    elif ! terraform apply -auto-approve; then
        log_error "Terraform apply failed"
        exit 1
    else
        INSTANCE_IP=$(terraform output -raw public_ip)
    fi
fi

if [ "$DESTROY_FLAG" = true ]; then
    cd terraform_configs
    terraform destroy -auto-approve
fi