variable "RG-Name" {
  description = "Resource group to assign the security group to"
}

variable "RG-Location" {
  description = "Resource group location"
}

variable "ObjNames-Prefix" {
  description = "Prefix appended to cloud objects names"
}

variable "Tags-Prefix" {
  description = "Prefix appended to cloud objects tags"
}

variable "FrontSN-IPv4-CIDR" {
  description = "Frontend subnet IPv4 CIDR"
}

variable "BackSN-IPv4-CIDR" {
  description = "Backend subnet IPv4 CIDR"
}
