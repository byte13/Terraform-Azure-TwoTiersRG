############################################################
# Variables to be set for root module definitions
# 

# Access and secret keys of the Azure account to be used by Terraform
# If empty or commented out, you will be prompted to specify them. 
#     For security reasons, it is the preferred method.
# Please, read https://www.linode.com/docs/applications/configuration-management/secrets-management-with-terraform/
#         for more information on secrets management, which is crucial.

subscription_id       = ""
tenant_id             = ""
client_id             = ""
client_secret         = ""

#
# End of variable to be set for root module definitions
############################################################


############################################################
# Variables used in all modules creating Azure objects 
# 

# Prefix for all Azure objects
ObjNames-Prefix = "B13"

# Prefix for all Azure tags
Tags-Prefix = "B13"

#
# End of variables used in all modules creating Azure objects
############################################################

############################################################
# Variables to be set for TwoTiersRG module definitions
# 

# Geographic location of the Ressource Group (RG)
RG-Location  = "West Europe"

# Resource Group (RG) main subnet using IPv4 CIDR notation (16 bit subnetmask).
# Two sub-subnets (24 subnetmask) will be automatically created out of this one
RG-IPv4-CIDR = "10.1.0.0/16"

#
# End of variable to be set for TwoTiersRG module definitions
############################################################

############################################################
# Variables to be set for SecurityGroups module definitions
# 

#
# End of variable to be set for SecurityGroups module definitions
############################################################

############################################################
# Variables to be set for VMInstances module definitions
# 

# Next 4 variables define the image to be installed in VM's
# To get a list of images available in Azure, please, run "az vm image ..."
# See https://docs.microsoft.com/en-us/cli/azure/vm/image?view=azure-cli-latest#az-vm-image-list
ARM-Image-Publisher = "Canonical"
ARM-Image-Offer     = "UbuntuServer"
ARM-Image-Sku       = "18.04-LTS"
ARM-Image-Build     = "latest"

# Agent ID (name of the SSH key) to be used by Ansible to connect to remote VM instances 
# Variable used by VMInstancesConfig module, too
SSH-agent-ID          = "ubuntu_rsa"
# Remote Linux account to be created on remote hosts then used by Terraform or Ansible to connect to remote Azure instances 
# Variable used by VMInstancesConfig module, too
SSH-username          = "ubuntu"
# Local file containg SSH public key to be autorized on remote virtual machines
# On Ubuntu images by Canonical, the key will be authorized on default account named "ubuntu"
SSH-pub-key-file   = "/some/path/.ssh/ubuntu_rsa.pub"
# SSH authorization file to be used on remote Linux virtual machines to allow our local SSH
#SSH-authZ-file     = "/home/${var.SSH-username}/.ssh/authorized_keys"

# Hostname of frontend server public (NAT) IP address 
Pub-hostname1      = "nchost1"
# Hostname of backend  server public (NAT) IP address
Pub-hostname2      = "dbhost1"
# Hostname of remote frontend server
FE-hostname1       = "ncvm1"
# Hostname of remote backend server
BE-hostname1       = "dbvm1"

#
# End of variable to be set for VMInstances module definitions
############################################################

############################################################
# Variables to be set for VMInstancesConfig module definitions
# 

# Agent ID (name of the SSH key) to be used by Ansible to connect to remote EC2 instances 
# Variable already set in previous section because it is required ny VMInstances module, too
#SSH-agent-ID          = "b13lab_rsa"
# Remote Linux account to be used by Ansible to connect to remote EC2 instances 
# On Ubuntu images by Canonical, the SSH key has been authorized on default account named "ubuntu"
# Variable already set in previous section because it is required ny VMInstances module, too
#SSH-username          = "ubuntu"

# Variable to run this module or not (true or false without quotes)
Ansible-NC-MariaDB-Enabled = true

# Directory where Ansible playbooks have been copied (cloned from GitHub)  
Ansible-PlayDir       = "/ANSIBLE/playbooks"
# Ansible playbooks contain Ansible vaults to store sensitive information, like passwords
# The next two variables can contain either :
#     - a filename containing the password of the respective vault
#     - the string "prompt" to be prompted for the password 
# To fully automatize the deployment of Nextcloud, the passphrase of the vaults can temporarily 
# be stored in a plaintext file or the passwords can be set here. But make sure to protect the files
# and don't upload these secrets in any source control system like Github.
Ansible-RedisVaultPwd = "/ANSIBLE/playbooks/redisVault_pwd.txt"
Ansible-NCVaultPwd    = "/ANSIBLE/playbooks/ncVault_pwd.txt"

# DNS name (FQDN) to be used to access the feshly installed Nextcloud instance.
# This variable is used to produce the Let's Encrypt certificate
# Note that the FQDN must resolve publicly for Let's Encrypt activation to succeed.
# Either set an explicit FQDN
#Nextcloud-FQDN        = "az-nc1.byte13.org"
# or, in main.tf, use the FQDN returned by Terrafrom Azure provisionner (module.VMInstances.PubIP1-FQDN)

# Version of Nextcloud to be installed
Nextcloud-Version     = "17.0.0"
# Directory which will store the Nextcloud data files
Nextcloud-DataDir     = "/var/NCDATA"

# Mail address to be used for notifications from Let's Encrypt 
Letsencrypt-email     = "user1@yourdomain.org"

#
# End of variable to be set for VMInstancesConfig module definitions
############################################################
