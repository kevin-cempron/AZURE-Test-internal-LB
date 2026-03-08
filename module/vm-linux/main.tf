#CREATION OF THE NETWORK INTERFACE FOR VM1 with a public IP to be able to connect through ssh ########

resource "azurerm_public_ip" "pip_VM" {
  name                = "pip-${var.vm_name}"
  resource_group_name = var.rg_name
  location            = var.localization
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "NIC_VM" {
  name                = "NIC_${var.vm_name}"
  resource_group_name = var.rg_name
  location            = var.localization
  ip_configuration {
    name                          = "internalip-${var.vm_name}"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.priv_ip_adress
    public_ip_address_id          = azurerm_public_ip.pip_VM.id
  }
}



#creation of the Linux Virtual Machine which will be part of the backend pool ##########
resource "azurerm_linux_virtual_machine" "VM" {
  name                = var.vm_name
  resource_group_name = var.rg_name
  location            = var.localization
  size                = "Standard_D2s_v3"
  admin_username      = "azureuser"
  admin_ssh_key {
    username   = "azureuser"
    public_key = var.ssh_key
  }
  network_interface_ids = [
    azurerm_network_interface.NIC_VM.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}