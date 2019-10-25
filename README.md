# Terraform-Azure-TwoTiersRG
This directory contains modules for Terraform to build a Resource Group (RG) in Microsoft Azure, made of 2 tiers subnets hosting respectively a backend and a frontend Ubuntu server. 

Both virtual machines (VM) will be configured using Ansible playbooks to get a fully secured Nextcloud service.
You can prevent the installation of MariaDB and Nextcloud using *VM-NC-MariaDB-Enabled = false* in **terraform.tfvars**, in which case the process will end up with a fresh resource group made of 2 subnets (frontend and backend) with a VM each, running Ubuntu 18.04
-LTS image by Canonical.

All steps described have been tested on Ubuntu 18.04-LTS running :
- Terraform 0.12.9
- Ansible 2.8.5
- Python 2.7.15+

## Prerequisits to deploy the infrastructure and install a secured Nextcloud instance

a. Create an account in Azure and get respective API keys to be used with Terraform \
b. [Install Terraform](https://askubuntu.com/questions/983351/how-to-install-terraform-in-ubuntu#983352) and ensure it is in your $PATH \
c. [Install Ansible](https://linuxhandbook.com/install-ansible-linux/) and ensure it is in your $PATH \
d. Clone [byte13/Terraform-Azure-TwoTiersRG](https://github.com/byte13/Terraform-Azure-TwoTiersRG) locally \
e. Clone [byte13/Ansible-MariaDB-Redis-Nextcloud-LetsEncrypt](https://github.com/byte13/Ansible-MariaDB-Redis-Nextcloud-LetsEncrypt) locally \
f. Create SSH keys to be used later on to execute Ansible playbooks and protect the private key with a strong passphrase. \
g. Use ssh-agent and ssh-add to unlock aforementioned SSH key so that you will not be prompted prompting for the passphrase each time an SSH connection is established. \
h. Read all comments and set the variables for your environment in **terraform.tfvars**. This file is located in the root module directory \
i. Read all comments and follow instructions in README file of the Ansible playbook \
j. Run 

```
$ terraform init
$ terraform plan
$ terraform apply
```


## Directory tree

```
.
├── .gitignore
├── main.tf
├── modules
│   ├── SecurityGroups
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── TwoTiersRG
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── VMInstances
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── VMInstancesConfig
│       ├── main.tf
│       └── variables.tf
├── outputs.tf
├── README.md
├── templates
│   ├── Backend-servers_inventory.tpl
│   └── Frontend-servers_inventory.tpl
├── terraform.tfvars
├── variables.tf
└── versions.tf
```

## Here are the main steps performed by these Terraform modules :

**Root module**

Triggs the modules described below then displays usefull information about the created Azure objects. 


**Module TwoTiersRG builds subnets, NAT and routing**

 1. Create the Resource Group (RG) using ${var.VPC-IPv4-CIDR} range specified in **terraform.tfvars**
 2. Create frontend subnet using a subnet of ${var.VPC-IPv4-CIDR} 
 3. Create backend subnet using a subnet of ${var.VPC-IPv4-CIDR}

**Module SecurityGroups prepares security goups to filter network trafics to/from VM instances**

 4. Get local IP address (of the machine executing Terrafom) or subnet to be allowed in security groups rules.
 5. Create Security Group and apply it to the RG 
     - Frontend port 80/TCP (HTTPS) reachable from all Internet.
     - Frontend port 443/TCP (HTTPS) reachable from all Internet.
     - Frontend port 22/TCP (SSH) reachable from the host currently running Terraform, only 
     - Frontend to backend port 3306/TCP (Nextcloud to MySQL) 
     - Backend port 22/TCP (SSH) reachable from the host currently running Terraform, only 

**Module VMInstances creates the instances from Ubuntu images**

 7. Obtain a public IPv4 address for both, frontend and backend servers.
 8. Create a network interface card (NIC) with a private IPv4 address for both, frontend and backend servers. Map each NIC to the respective aforementioned public IPv4 address
 9. Create storage account for VM to log boot messages
10. Create backend server and authorize our SSH public key
11. Perform some SysAdmin tasks on the backend VM
12. Create frontend server and authorize our SSH public key
13. Perform some SysAdmin tasks on the frontend VM

**Module VMInstancesConfig runs the Ansible playbooks**

14. Install and configure Apache, PHP, MariaDB, Redis, Nextcloud and Let'Encrypt
15. Delete Ansible inventories
16. Possibly, disable direct access to backend subnet
    - To be re-enabled each time configuration changes must be applied on backend instances

