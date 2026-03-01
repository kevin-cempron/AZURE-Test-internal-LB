output "VM1-id" {
  description = "id of VM1"
  value       = azurerm_linux_virtual_machine.VM1-Website.id
}

output "VM2-id" {
  description = "id of VM2"
  value       = azurerm_linux_virtual_machine.VM2-Website.id
}

output "VM3-id" {
  description = "id of VM3"
  value       = azurerm_linux_virtual_machine.VM3-test.id
}

### PRIVATE ###############
output "VM1-Website-internal-ip" {
  description = "Internal IP of VM1"
  value       = azurerm_network_interface.NIC-VM1-Website.ip_configuration[0].private_ip_address
}

output "VM2-Website-internal-ip" {
  description = "Internal IP of VM2"
  value       = azurerm_network_interface.NIC-VM2-Website.ip_configuration[0].private_ip_address
}

output "VM3-test-internal-ip" {
  description = "Internal IP of VM3"
  value       = azurerm_network_interface.NIC-VM3-test.ip_configuration[0].private_ip_address
}

### PUBLIC ########################

output "VM1-Website-public-ip" {
  description = "Public IP of VM1"
  value       = azurerm_public_ip.pip-VM1-Website.ip_address
}

output "VM2-Website-public-ip" {
  description = "Public IP of VM2"
  value       = azurerm_public_ip.pip-VM2-Website.ip_address
}

output "VM3-Test-public-ip" {
  description = "Public IP of VM3"
  value       = azurerm_public_ip.pip-VM3-test.ip_address
}