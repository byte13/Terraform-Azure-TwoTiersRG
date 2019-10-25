#
# Display some information about various resources
#
output "RG-Name" {
  value = module.TwoTiersRG.RG-Name
}

output "FrontSN-IPv4-CIDR" {
  value = module.TwoTiersRG.FrontSN-IPv4-CIDR
}

output "BackSN-IPv4-CIDR" {
  value = module.TwoTiersRG.BackSN-IPv4-CIDR
}

output "PubIP1-FQDN" {
  value = module.VMInstances.PubIP1-FQDN
}

output "PubIP1-IPv4" {
  value = module.VMInstances.PubIP1-IPv4
}

output "FE-hostname1" {
  value = module.VMInstances.FE-hostname1
}

output "PrivIP1-IPv4" {
  value = module.VMInstances.PrivIP1-IPv4
}

output "PubIP2-FQDN" {
  value = module.VMInstances.PubIP2-FQDN
}

output "PubIP2-IPv4" {
  value = module.VMInstances.PubIP2-IPv4
}

output "BE-hostname1" {
  value = module.VMInstances.BE-hostname1
}

output "PrivIP2-IPv4" {
  value = module.VMInstances.PrivIP2-IPv4
}

