variable "RG-Name" {
  description = "Name of the network resource group to host the VM's"
}

variable "RG-Location" {
  description = "Location of the network resource group to host the VM's"
}

variable "RG-Id" {
  description = "ID of the network resource group to host the VM's"
}

variable "ObjNames-Prefix" {
  description = "Prefix appended to cloud objects names"
}

variable "Tags-Prefix" {
  description = "Prefix appended to cloud objects tags"
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

variable "NSG1-Id" {
  description = "Network security group to apply to VM interfaces"
}

variable "FrontSN-IPv4-Id" {
  description = "Frontend subnet IPv4 ID"
}

variable "BackSN-IPv4-Id" {
  description = "Backend subnet IPv4 ID"
}

variable "SSH-pub-key-file" {
  description = "File containing public SSH key to be authorized on account on remote servers"
  type    = string
}

variable "SSH-agent-ID" {
  description = "SSH ID to be addedd to SSH agent"
  type    = string
}
variable "SSH-username" {
  description = "Linux account to create on remote servers"
  type    = string
}

variable "Pub-hostname1" {
  description = "Hostname of frontend server public IPv4"
  type    = string
}
variable "Pub-hostname2" {
  description = "Hostname of backend server public IPv4"
  type    = string
}
variable "FE-hostname1" {
  description = "Hostname of frontend server"
  type    = string
}
variable "BE-hostname1" {
  description = "Hostname of backend server"
  type    = string
}
