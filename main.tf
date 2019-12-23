# This block is used to connect to AWS API
# It is recommanded to keep secrets in environments variables
# instead as in clear in the block in case the file is stored
# in some public source control system like Git.
# Varables syntax :
# $ export ARM_SUBSCRIPTION_ID="<subscription ID>"
# $ export ARM_LOCATION="<geographic location>"
# $ export ARM_TENANT_ID="<tenant ID>"
# $ export ARM_CLIENT_ID="<client ID>"
# $ export ARM_CLIENT_SECRET="<clent secret>"

# or, even better, declare empty variables which will prompt the user at runtime
# unless he specifies the values as command line arguments using this
# syntax : $ terraform apply -var 'client_id=<value>' -var 'client_secret=...'
# or she put the variables in a file and use this syntax : terraform apply -var-file <filename>.tfvars
# Ensure respectively to clear your shell history or that the file is not uploaded in versioning tool like git

# Configure Azure Provider
provider "azurerm" {
  version         = "~> 1.35.0"

  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id

  client_id       = var.client_id
  client_secret   = var.client_secret
}

module "TwoTiersRG" {
  source = "./modules/TwoTiersRG"

  RG-Location      = var.RG-Location
  RG-IPv4-CIDR     = var.RG-IPv4-CIDR

  ObjNames-Prefix  = var.ObjNames-Prefix
  Tags-Prefix      = var.Tags-Prefix
}

module "SecurityGroups" {
  source = "./modules/SecurityGroups"

  RG-Name           = module.TwoTiersRG.RG-Name
  RG-Location       = var.RG-Location

  ObjNames-Prefix   = var.ObjNames-Prefix
  Tags-Prefix       = var.Tags-Prefix

  FrontSN-IPv4-CIDR = module.TwoTiersRG.FrontSN-IPv4-CIDR
  BackSN-IPv4-CIDR  = module.TwoTiersRG.BackSN-IPv4-CIDR
}

module "VMInstances" {
  source = "./modules/VMInstances"

  RG-Id               = module.TwoTiersRG.RG-Id
  RG-Name             = module.TwoTiersRG.RG-Name
  RG-Location         = var.RG-Location

  ObjNames-Prefix     = var.ObjNames-Prefix
  Tags-Prefix         = var.Tags-Prefix

  ARM-Image-Publisher = var.ARM-Image-Publisher
  ARM-Image-Offer     = var.ARM-Image-Offer
  ARM-Image-Sku       = var.ARM-Image-Sku
  ARM-Image-Build     = var.ARM-Image-Build

  NSG1-Id             = module.SecurityGroups.NSG1-Id
  FrontSN-IPv4-Id     = module.TwoTiersRG.FrontSN-IPv4-Id
  BackSN-IPv4-Id      = module.TwoTiersRG.BackSN-IPv4-Id
  Pub-hostname1       = var.Pub-hostname1
  FE-hostname1        = var.FE-hostname1
  Pub-hostname2       = var.Pub-hostname2
  BE-hostname1        = var.BE-hostname1

  SSH-agent-ID        = var.SSH-agent-ID
  SSH-username        = var.SSH-username
  SSH-pub-key-file    = var.SSH-pub-key-file
}

module "VMInstancesConfig" {
  source = "./modules/VMInstancesConfig"

  Ansible-MariaDB-Enabled = var.Ansible-MariaDB-Enabled
  Ansible-NC-Enabled      = var.Ansible-NC-Enabled

  SSH-agent-ID            = var.SSH-agent-ID
  SSH-username            = var.SSH-username

  Ansible-PlayDir         = var.Ansible-PlayDir
  Ansible-NCVaultPwd      = var.Ansible-NCVaultPwd
  Ansible-RedisVaultPwd   = var.Ansible-RedisVaultPwd

  Nextcloud-FQDN          = module.VMInstances.PubIP1-FQDN
  Nextcloud-Version       = var.Nextcloud-Version
  Nextcloud-DataDir       = var.Nextcloud-DataDir

  Letsencrypt-email       = var.Letsencrypt-email

  PrivIP1-IPv4            = module.VMInstances.PrivIP1-IPv4
  FE-hostname1            = module.VMInstances.FE-hostname1
  PubIP1-FQDN             = module.VMInstances.PubIP1-FQDN
  BE-hostname1            = module.VMInstances.BE-hostname1
  PubIP2-FQDN             = module.VMInstances.PubIP2-FQDN
}
