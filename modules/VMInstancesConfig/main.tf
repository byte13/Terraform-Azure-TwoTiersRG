####################################################################
# The following blocks prepare Ansible inventory files with
# respective VM instances IP address or FQDN
#
provider "local" {
   version = "~> 1.4"
}

provider "template" {
   version = "~> 2.1"
}

data  "template_file" "Frontend-servers_template" {
    template = file("./templates/Frontend-servers_inventory.tpl")
    vars = {
        Frontend-server = var.PubIP1-FQDN
    }
}

resource "local_file" "Frontend-servers_inventory-file" {
    content  = data.template_file.Frontend-servers_template.rendered
    filename = "${var.Ansible-PlayDir}/Frontend-servers_inventory"
    file_permission = 640
}

# The following blocks prepare Ansible inventory file for backend server 
data  "template_file" "Backend-servers_template" {
    template = file("./templates/Backend-servers_inventory.tpl")
    vars = {
        Backend-server = var.PubIP2-FQDN
    }
}

resource "local_file" "Backend-servers_inventory-file" {
    content  = data.template_file.Backend-servers_template.rendered
    filename = "${var.Ansible-PlayDir}/Backend-servers_inventory"
    file_permission = 640
}
#
# End of preparation of Ansible inventory files
####################################################################

provider "null" {
   version = "~> 2.1"
}

# Perfrom SysAdmin operations on remote VMs
resource "null_resource" "Byte13_NullRES1" {

    # Check if the resource is to be created
    count = var.Ansible-MariaDB-Enabled == true ? 1 : 0

    # Perfrom SysAdmin operations on backend server 
    provisioner "remote-exec" {
        connection {
            type           = "ssh"
            host           = var.PubIP2-FQDN
            agent          = "true"
            agent_identity = var.SSH-agent-ID
            user           = var.SSH-username
        }

        # Ensure apt is clean and install some facilities
        inline = [
          "sudo rm -rf /var/lib/apt/lists/*",
          "sudo apt-get clean",
          "sudo apt update",
          "sudo apt -y install aptitude",
          "sudo apt -y install nmap",
          "sudo apt -y install hping3",
          "sudo apt -y install htop"
        ]
    }

    # This is where we install MariaDB on backend server using ansible-playbook
    provisioner "local-exec" {
        # Without checking SSH remote host key (NOT a good security practice)
        # To be safer, change "StrictHostKeyChecking=no" to "StrictHostKeyChecking=yes" on next line
        command = "cd ${var.Ansible-PlayDir} && ansible-playbook -u ${var.SSH-username} --ssh-common-args='-o StrictHostKeyChecking=no' -i '${var.Ansible-PlayDir}/Backend-servers_inventory' -l Azure_MariaDB --extra-vars 'nc_serverPrivIP=${var.PrivIP1-IPv4} nc_serverPrivFQDN=${var.FE-hostname1}' --vault-id nc@${var.Ansible-NCVaultPwd} Linux_Install-NextCloud_with-roles.yml"
    }

    # Remove Ansible inventory for backend servers 
    provisioner "local-exec" {
        command = "if [ -f ${var.Ansible-PlayDir}/Backend-servers_inventory ] ; then shred -u -z ${var.Ansible-PlayDir}/Backend-servers_inventory ; fi"
    }
}

resource "null_resource" "Byte13_NullRES2" {
   
  # Wait for MariaDB backend to be available
    depends_on            = [null_resource.Byte13_NullRES1]
   
    # Check if the resource is to be created
    count = var.Ansible-NC-Enabled == true ? 1 : 0

    # Perfrom SysAdmin operations on frontend server 
    provisioner "remote-exec" {
        connection {
            type           = "ssh"
            host           = var.PubIP1-FQDN
            agent          = "true"
            agent_identity = var.SSH-agent-ID
            user           = var.SSH-username
        }

        # Ensure apt is clean and install some facilities
        inline = [
          "sudo rm -rf /var/lib/apt/lists/*",
          "sudo apt-get clean",
          "sudo apt update",
          "sudo apt -y install aptitude",
          "sudo apt -y install nmap",
          "sudo apt -y install hping3",
          "sudo apt -y install htop"
        ]
    }

    # This is where we install Nextcloud on frontend server using ansible-playbook
    provisioner "local-exec" {
        # Without checking SSH remote host key (NOT a good security practice)
        # To be safer, change "StrictHostKeyChecking=no" to "StrictHostKeyChecking=yes" on next line
        command = "cd ${var.Ansible-PlayDir} && ansible-playbook -u ${var.SSH-username} --ssh-common-args='-o StrictHostKeyChecking=no' -i '${var.Ansible-PlayDir}/Frontend-servers_inventory' -l Azure_Nextcloud --extra-vars 'nc_dbserver=${var.BE-hostname1} nc_trusteddomain=${var.PubIP1-FQDN} nc_version=${var.Nextcloud-Version} nc_datadir=${var.Nextcloud-DataDir} le_email=${var.Letsencrypt-email}' --vault-id redis@${var.Ansible-RedisVaultPwd}  --vault-id nc@${var.Ansible-NCVaultPwd} Linux_Install-NextCloud_with-roles.yml"
    }

    # Remove Ansible inventory for Frontend servers 
    provisioner "local-exec" {
        command = "if [ -f ${var.Ansible-PlayDir}/Frontend-servers_inventory ] ; then shred -u -z ${var.Ansible-PlayDir}/Frontend-servers_inventory ; fi"
    }
}
