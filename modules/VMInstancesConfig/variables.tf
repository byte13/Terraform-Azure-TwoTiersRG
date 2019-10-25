variable "VM-NC-MariaDB-Enabled" {
  description = "Variable to define if Nextcloud and MariaDB should be installed (true or false)"
}

variable "PubIP1-FQDN" {
  description = "Frontend server public FQDN"
}

variable "FE-hostname1" {
  description = "Frontend server private hostname"
}

variable "PrivIP1-IPv4" {
  description = "Frontend server private IPv4 address"
}

variable "PubIP2-FQDN" {
  description = "Backend server public FQDN"
}

variable "BE-hostname1" {
  description = "Backend server private hostname"
}

variable "SSH-agent-ID" {
    description = "SSH agent ID"
}

variable "SSH-username" {
    description = "EC2 instance Linux account"
}

variable "Ansible-PlayDir" {
    description = "Directory of Ansible palybooks and roles"
}

variable "Nextcloud-DataDir" {
    description = "Directory where Nextcloud stores uploaded data files"
}

variable "Nextcloud-FQDN" {
    description = "FQDN of Nextcloud site"
}

variable "Nextcloud-Version" {
    description = "Nextcloud version to be installed"
}

variable "Ansible-NCVaultPwd" {
    description = "Password to unlock Ansible vault password of Nextcloud role"
}

variable "Ansible-RedisVaultPwd" {
    description = "Password to unlock Ansible vault password of Redis role"
}

variable "Letsencrypt-email" {
    description = "Mail address specified in Let's Encrypt certificates"
}
