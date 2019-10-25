# Create a resource group
resource "azurerm_resource_group" "Byte13_RGNet1" {
  name     = "${var.ObjNames-Prefix}_RGNet1"
  location = "${var.RG-Location}"
}

# Create a virtual network
resource "azurerm_virtual_network" "Byte13_VNetIPv4" {
  name                = "${var.ObjNames-Prefix}_VNetIPv4"
  address_space       = ["${var.RG-IPv4-CIDR}"]
  location            = "${azurerm_resource_group.Byte13_RGNet1.location}"
  resource_group_name = "${azurerm_resource_group.Byte13_RGNet1.name}"
}

# Create a frontend subnet within the virtual network
resource "azurerm_subnet" "Byte13_FrontSNIPv4" {
  name                 = "${var.ObjNames-Prefix}_FrontSNIPv4"
  resource_group_name  = "${azurerm_resource_group.Byte13_RGNet1.name}"
  virtual_network_name = "${azurerm_virtual_network.Byte13_VNetIPv4.name}"
  # Calculate subnet based on current RG parent virtual network address space
  address_prefix       = "${cidrsubnet(azurerm_virtual_network.Byte13_VNetIPv4.address_space[0], 8, 1)}"
}

# Create a backend subnet within the virtual network
resource "azurerm_subnet" "Byte13_BackSNIPv4" {
  name                 = "${var.ObjNames-Prefix}_BackSSNIPv4"
  resource_group_name  = "${azurerm_resource_group.Byte13_RGNet1.name}"
  virtual_network_name = "${azurerm_virtual_network.Byte13_VNetIPv4.name}"
  # Calculate subnet based on current RG parent virtual network address space
  address_prefix       = "${cidrsubnet(azurerm_virtual_network.Byte13_VNetIPv4.address_space[0], 8, 2)}"
}
