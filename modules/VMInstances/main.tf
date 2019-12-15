# Create public IP addresses for the exposed services
# Obtain a public IPv4 address for frontend server
resource "azurerm_public_ip" "Byte13_PubIP1" {
    name                = "${var.ObjNames-Prefix}_PubIP1"
    resource_group_name = var.RG-Name
    location            = var.RG-Location
    allocation_method   = "Dynamic"
    domain_name_label   = var.Pub-hostname1

    tags = {
        environmemt = "${var.Tags-Prefix}_Terraform"
    }
}

# Obtain a public IPv4 address for backend server
resource "azurerm_public_ip" "Byte13_PubIP2" {
    name                = "${var.ObjNames-Prefix}_PubIP2"
    resource_group_name = var.RG-Name
    location            = var.RG-Location
    allocation_method   = "Dynamic"
    domain_name_label   = var.Pub-hostname2

    tags = {
        environmemt = "${var.Tags-Prefix}_Terraform"
    }
}

# Create network interface card for the frontend VM and map the first aforecreated public IPv4 address
resource "azurerm_network_interface" "Byte13_FENIC1" {
    name                      = "${var.ObjNames-Prefix}_FrontEndNIC1"
    resource_group_name       = var.RG-Name
    location                  = var.RG-Location
    network_security_group_id = var.NSG1-Id
    internal_dns_name_label   = var.FE-hostname1 

    ip_configuration {
        name                          = "${var.ObjNames-Prefix}_FrontEndNICConf"
        subnet_id                     = var.FrontSN-IPv4-Id
        private_ip_address_allocation = "dynamic"
        public_ip_address_id          = azurerm_public_ip.Byte13_PubIP1.id
    }

    tags = {
        environment = "${var.Tags-Prefix}_Terraform"
    }
}

# Create network interface card for the backend VM and map the second aforecreated public IP address
resource "azurerm_network_interface" "Byte13_BENIC1" {
    name                      = "${var.ObjNames-Prefix}_BackEndNIC1"
    resource_group_name       = var.RG-Name
    location                  = var.RG-Location
    network_security_group_id = var.NSG1-Id
    internal_dns_name_label   = var.BE-hostname1 

    ip_configuration {
        name                          = "${var.ObjNames-Prefix}_BackEndNICConf"
        subnet_id                     = var.BackSN-IPv4-Id
        private_ip_address_allocation = "dynamic"
        public_ip_address_id          = azurerm_public_ip.Byte13_PubIP2.id
    }

    tags = {
        environment = "${var.Tags-Prefix}_Terraform"
    }
}

provider "random" {
    version = "~> 2.2"
}
# Create account ID for storage account 
resource "random_id" "Byte13_StorageId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = var.RG-Name
    }

    byte_length = 8
}

# Create storage account for boot messages 
resource "azurerm_storage_account" "Byte13_StorageAcct1" {
    name                     = "diag${random_id.Byte13_StorageId.hex}"
    resource_group_name      = var.RG-Name
    location                 = var.RG-Location
    account_replication_type = "LRS"
    account_tier             = "Standard"

    tags = {
        environment = "${var.Tags-Prefix}_Terraform"
    }
}

# Create the backend VM from Ubuntu image
resource "azurerm_virtual_machine" "Byte13_BEVM1" {
    name                  = "${var.ObjNames-Prefix}_BackEndVM1"
    resource_group_name   = var.RG-Name
    location              = var.RG-Location
    network_interface_ids = [azurerm_network_interface.Byte13_BENIC1.id]
    vm_size               = "Standard_DS1_v2"

    # Uncomment this line to delete the OS disk automatically when deleting the VM
    delete_os_disk_on_termination = true

    # Uncomment this line to delete the data disks automatically when deleting the VM
    delete_data_disks_on_termination = true

    storage_os_disk {
        name              = "${var.ObjNames-Prefix}_BackEndVM1-OSDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }

    # In case an Image containin gMariaDB is prefered, the following block requires to accept licence terms, first
    # If not done, yet, in the Azure tenant, use the following commands :
    # $ az login
    # $ az vm image list --all --publisher mariadb --offer mariadb-server
    # $ az vm image accept-terms --urn mariadb:mariadb-server:standalone:<latest version>
    #storage_image_reference {
    #    publisher = "mariadb"
    #    offer     = "mariadb-server"
    #    sku       = "standalone"
    #    version   = "latest"
    #}

    #plan {
    #    name      = "standalone"
    #    publisher = "mariadb"
    #    product   = "mariadb-server"
    #}

    storage_image_reference {
        publisher = var.ARM-Image-Publisher
        offer     = var.ARM-Image-Offer 
        sku       = var.ARM-Image-Sku 
        version   = var.ARM-Image-Build 
    }

    os_profile {
        computer_name  = var.BE-hostname1
        admin_username = var.SSH-username 
        # admin_password = var.admin-password
    }

    os_profile_linux_config {
        disable_password_authentication = "true"
        ssh_keys {
            #path     = var.SSH-authZ-file
            path     = "/home/${var.SSH-username}/.ssh/authorized_keys"
            key_data = file(var.SSH-pub-key-file) 
        }
    }

    boot_diagnostics {
        enabled     = "true"
        storage_uri = azurerm_storage_account.Byte13_StorageAcct1.primary_blob_endpoint
    }

    # Perfrom SysAdmin operations on remote VM
    provisioner "remote-exec" {
        connection {
            type           = "ssh"
            agent          = "true"
            agent_identity = var.SSH-agent-ID
            host           = azurerm_public_ip.Byte13_PubIP2.fqdn 
            user           = var.SSH-username
            # private_key  = file(var.SSH-priv-key-file) 
        }

        # Ensure apt is clean and install some facilities
        inline = [
          "sudo rm -rf /var/lib/apt/lists/*",
          "sudo apt-get clean",
          "sudo apt update",
          "sudo apt -y dist-upgrade",
          "sudo apt -y install nmap",
          "sudo apt -y install htop"
        ]
    }

    tags = {
        environment = "${var.Tags-Prefix}_Terraform"
    }
}

# Create the frontend VM
resource "azurerm_virtual_machine" "Byte13_VM1" {
    name                  = "${var.ObjNames-Prefix}_FrontEndVM1"
    resource_group_name   = var.RG-Name
    location              = var.RG-Location
    network_interface_ids = [azurerm_network_interface.Byte13_FENIC1.id]
    vm_size               = "Standard_DS1_v2"

  # Wait for MariaDB backend is available
    depends_on            = [azurerm_virtual_machine.Byte13_BEVM1]

  # Uncomment this line to delete the OS disk automatically when deleting the VM
    delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
    delete_data_disks_on_termination = true

    storage_os_disk {
        name              = "${var.ObjNames-Prefix}_FrontEndVM1-OSDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }

    storage_image_reference {
        publisher = var.ARM-Image-Publisher
        offer     = var.ARM-Image-Offer 
        sku       = var.ARM-Image-Sku 
        version   = var.ARM-Image-Build 
    }

    os_profile {
        computer_name  = var.FE-hostname1
        admin_username = var.SSH-username 
    }

    os_profile_linux_config {
        disable_password_authentication = "true"
        ssh_keys {
            # path     = var.SSH-authZ-file
            path     = "/home/${var.SSH-username}/.ssh/authorized_keys"
            key_data = file(var.SSH-pub-key-file) 
        }
    }

    boot_diagnostics {
        enabled     = "true"
        storage_uri = azurerm_storage_account.Byte13_StorageAcct1.primary_blob_endpoint
    }

    # Perfrom SysAdmin operations on remote VM
    provisioner "remote-exec" {
        connection {
            type           = "ssh"
            agent          = "true"
            agent_identity = var.SSH-agent-ID
            host           = azurerm_public_ip.Byte13_PubIP1.fqdn 
            user           = var.SSH-username
            # private_key  = file(var.SSH-priv-key-file) 
        }

        # Ensure apt is clean and install some facilities
        inline = [
          "sudo rm -rf /var/lib/apt/lists/*",
          "sudo apt-get clean",
          "sudo apt update",
          "sudo apt -y dist-upgrade",
          "sudo apt -y install nmap",
          "sudo apt -y install htop"
        ]
    }

    tags = {
        environment = "${var.Tags-Prefix}_Terraform"
    }
}

