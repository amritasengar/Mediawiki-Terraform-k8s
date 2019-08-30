# Mediawiki-Terraform -Kubernetes
This repository uses terraform to provision infrastructure on AWS and sets up the Kubernetes cluster with 1 master and 2 nodes.



## Pre-Requisites

The following are the prerequisites for executing the code.
1. Use ssh-keygen to create a pair of rsa, private and public keys and store them in the default location i.e ~/.ssh/*
```
ssh-keygen -t rsa -b 2048
```
2. Configure aws credentials (access-key and secret access-key), admin credentials, using the below command. 
```bash
aws configure
```

## Execution

```
git clone https://github.com/amritasengar/Terraform-k8s-Assignment.git
cd ./Terraform-k8s-Assignment
terraform init
terraform apply --auto-approve
```
You can also run the automation script present inside the repository.

```
sh automation-script.sh
```
