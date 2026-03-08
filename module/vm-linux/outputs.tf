output "nic_id" {
    value = azurerm_network_interface.NIC_VM.id
}

output "nic_name" {
    value = azurerm_network_interface.NIC_VM.name
}

output "nic_ip_name" {
    value = azurerm_network_interface.NIC_VM.ip_configuration[0].name
}

output "nic_priv_address" {
    value =  azurerm_network_interface.NIC_VM.ip_configuration[0].private_ip_address
}

output "public_ip" {
    value = azurerm_public_ip.pip_VM.ip_address
}