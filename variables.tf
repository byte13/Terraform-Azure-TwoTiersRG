variable "ObjNames-Prefix" {
  description = "Prefix appended to cloud objects names"
}

variable "Tags-Prefix" {
  description = "Prefix appended to cloud objects tags"
}

variable "subscription_id" {
  description = "Azure subscription ID"
}

variable "tenant_id" {
  description = "Azure tenant ID"
}

variable "client_id" {
  description = "Azure client ID"
}

variable "client_secret" {
  description = "Azure secret ID"
}

variable "RG-Location" {
  description = "Geographical ocation of the Ressource Group (RG)"
}

variable "RG-IPv4-CIDR" {
  description = "IPv4 CIDR block used in the Ressource Group (RG)"
}

variable "SSH-pub-key-file" {
  description = "SSH public key filename"
}

variable "SSH-agent-ID" {
  description = "SSH agent ID"
}

variable "SSH-username" {
  description = "SSH username on target systems"
}

variable "Pub-hostname1" {
  description = "Hostname of frontend public IP address"
}

variable "Pub-hostname2" {
  description = "Hostname of backend public IP address"
}

variable "FE-hostname1" {
  description = "Hostname of frontend private IP address"
}

variable "BE-hostname1" {
  description = "Hostname of backend private IP address"
}

variable "ARM-Image-Publisher" {
  description = "Publisher of the system (OS) image to be installed in VM's"
}

variable "ARM-Image-Offer" {
  description = "Offer of the system (OS) image to be installed in VM's"
}

variable "ARM-Image-Sku" {
  description = "Version of the system (OS) image to be installed in VM's"
}

variable "ARM-Image-Build" {
  description = "Version of the system (OS) image to be installed in VM's"
}

variable "Ansible-MariaDB-Enabled" {
  description = "Variable to define if MariaDB should be installed on backend server (true or false)"
}

variable "Ansible-NC-Enabled" {
  description = "Variable to define if Nextcloud should be installed on frontend server (true or false)"
}

variable "Ansible-PlayDir" {
  description = "Parent directory of Ansible playbook/roles"
}

variable "Ansible-RedisVaultPwd" {
  description = "Filename containing plaintext passphrase for Redis Ansible vault"
}

variable "Ansible-NCVaultPwd" {
  description = "Filename containing plaintext passphrase for Nextcloud Ansible vault"
}

variable "Nextcloud-Version" {
  description = "Nextcloud version to be installed"
}

variable "Nextcloud-DataDir" {
  description = "Directory where Nextcloud stores uploaded data files"
}

#variable "Nextcloud-FQDN" {
#  description = "FQDN of Nextcloud site"
#}

variable "Letsencrypt-email" {
  description = "Mail address specified in Let's Encrypt certificates"
}

