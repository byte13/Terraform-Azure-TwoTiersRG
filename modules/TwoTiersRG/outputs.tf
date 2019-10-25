output "RG-Name" {
  value = "${azurerm_resource_group.Byte13_RGNet1.name}"
}

output "RG-Id" {
  value = "${azurerm_resource_group.Byte13_RGNet1.id}"
}

output "FrontSN-IPv4-CIDR" {
  value = "${azurerm_subnet.Byte13_FrontSNIPv4.address_prefix}"
}

output "FrontSN-IPv4-Id" {
  value = "${azurerm_subnet.Byte13_FrontSNIPv4.id}"
}

output "BackSN-IPv4-CIDR" {
  value = "${azurerm_subnet.Byte13_BackSNIPv4.address_prefix}"
}

output "BackSN-IPv4-Id" {
  value = "${azurerm_subnet.Byte13_BackSNIPv4.id}"
}

