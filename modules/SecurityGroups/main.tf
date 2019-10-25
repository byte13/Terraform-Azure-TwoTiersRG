# Create network security group

# Configure the http Provider
provider "http" {
  version    = "~> 1.1.1"
}

# Get current external IPv4 address
data "http" "CurrentExternalIPv4" {
  url ="https://v4.ident.me"
}

# Get current external IPv6 address
data "http" "CurrentExternalIPv6" {
  url ="https://v6.ident.me"
}

resource "azurerm_network_security_group" "Byte13_NSG1" {
    name                = "${var.ObjNames-Prefix}_NSG1"
    location            = var.RG-Location
    resource_group_name = var.RG-Name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        #source_address_prefix      = "*"
        source_address_prefix      = data.http.CurrentExternalIPv4.body
        destination_address_prefix = var.FrontSN-IPv4-CIDR
    }

    security_rule {
        name                       = "Front2BackMySQL"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3306"
        source_address_prefix      = var.FrontSN-IPv4-CIDR
        destination_address_prefix = var.BackSN-IPv4-CIDR
    }

    security_rule {
        name                       = "Front2BackSSH"
        priority                   = 1003
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = var.FrontSN-IPv4-CIDR
        destination_address_prefix = var.BackSN-IPv4-CIDR
    }

    security_rule {
        name                       = "CurrentExtIP2BackSSH"
        priority                   = 1004
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = data.http.CurrentExternalIPv4.body
        destination_address_prefix = var.BackSN-IPv4-CIDR
    }

    security_rule {
        name                       = "HTTP2FrontEnd"
        priority                   = 1005
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = var.FrontSN-IPv4-CIDR
    }

    security_rule {
        name                       = "HTTPS2FrontEnd"
        priority                   = 1006
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = var.FrontSN-IPv4-CIDR
    }

    tags = {
        environment = "${var.Tags-Prefix}_Terraform"
    }
}
