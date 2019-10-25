output "PubIP1-FQDN" {
  value = "${azurerm_public_ip.Byte13_PubIP1.fqdn}"
}

output "PubIP1-IPv4" {
  value = "${azurerm_public_ip.Byte13_PubIP1.ip_address}"
}

output "PrivIP1-IPv4" {
  value = "${azurerm_network_interface.Byte13_FENIC1.private_ip_address}"
}

output "FE-hostname1" {
  value = "${azurerm_network_interface.Byte13_FENIC1.internal_dns_name_label}"
}

output "PubIP2-FQDN" {
  value = "${azurerm_public_ip.Byte13_PubIP2.fqdn}"
}

output "PubIP2-IPv4" {
  value = "${azurerm_public_ip.Byte13_PubIP2.ip_address}"
}

output "PrivIP2-IPv4" {
  value = "${azurerm_network_interface.Byte13_BENIC1.private_ip_address}"
}

output "BE-hostname1" {
  value = "${azurerm_network_interface.Byte13_BENIC1.internal_dns_name_label}"
}
