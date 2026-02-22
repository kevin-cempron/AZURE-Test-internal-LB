provider "azurerm" {
  features {}
}

#Resource Group creation which will include all all the resources ##########
resource "azurerm_resource_group" "rg-test-internal-lb" {
  name     = "rg-test-internal-lb"
  location = var.azure_region
}



#Virtual Network creation which will include the 3 VM ###########
resource "azurerm_virtual_network" "vnet-test-internal-lb" {
  name                = "vnet-test-internal-lb"
  resource_group_name = azurerm_resource_group.rg-test-internal-lb.name
  location            = azurerm_resource_group.rg-test-internal-lb.location
  address_space       = ["192.168.50.0/24"]

  tags = {
    environment = "test"
    purpose     = "virtual-network"
  }
}

resource "azurerm_subnet" "subnet-test-internal-lb" {
  name                 = "subnet-test-internal-lb"
  resource_group_name  = azurerm_resource_group.rg-test-internal-lb.name
  virtual_network_name = azurerm_virtual_network.vnet-test-internal-lb.name
  address_prefixes     = ["192.168.50.0/24"]
}

#CREATION OF THE NETWORK INTERFACE FOR VM1 with a public IP to be able to connect through ssh ########
resource "azurerm_public_ip" "pip-VM1-Website" {
  name                = "pip-VM1-Website"
  resource_group_name = azurerm_resource_group.rg-test-internal-lb.name
  location            = azurerm_resource_group.rg-test-internal-lb.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "NIC-VM1-Website" {
  name                = "NIC-VM1-Website"
  resource_group_name = azurerm_resource_group.rg-test-internal-lb.name
  location            = azurerm_resource_group.rg-test-internal-lb.location
  ip_configuration {
    name                          = "internalip-VM1-Website"
    subnet_id                     = azurerm_subnet.subnet-test-internal-lb.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "192.168.50.10"
    public_ip_address_id          = azurerm_public_ip.pip-VM1-Website.id
  }
}



#creation of the Linux Virtual Machine which will be part of the backend pool ##########
resource "azurerm_linux_virtual_machine" "VM1-Website" {
  name                = "VM1-Website"
  resource_group_name = azurerm_resource_group.rg-test-internal-lb.name
  location            = azurerm_resource_group.rg-test-internal-lb.location
  size                = "Standard_D2s_v3"
  admin_username      = "azureuser"
  admin_ssh_key {
    username   = "azureuser"
    public_key = var.ssh_pub_key
  }
  network_interface_ids = [
    azurerm_network_interface.NIC-VM1-Website.id,
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

  tags = {
    environment = "test"
    purpose     = "virtual-machine"
  }
}


#CREATION OF NETWORK CARD OF VM2 WITH PUBLIC IP TO BE ABLE TO CONNECT THROUGH SSH ##########
resource "azurerm_public_ip" "pip-VM2-Website" {
  name                = "pip-VM2-Website"
  resource_group_name = azurerm_resource_group.rg-test-internal-lb.name
  location            = azurerm_resource_group.rg-test-internal-lb.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "NIC-VM2-Website" {
  name                = "NIC-VM2-Website"
  resource_group_name = azurerm_resource_group.rg-test-internal-lb.name
  location            = azurerm_resource_group.rg-test-internal-lb.location
  ip_configuration {
    name                          = "internalip-VM2-Website"
    subnet_id                     = azurerm_subnet.subnet-test-internal-lb.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "192.168.50.11"
    public_ip_address_id          = azurerm_public_ip.pip-VM2-Website.id
  }
}

resource "azurerm_linux_virtual_machine" "VM2-Website" {
  name                = "VM2-Website"
  resource_group_name = azurerm_resource_group.rg-test-internal-lb.name
  location            = azurerm_resource_group.rg-test-internal-lb.location
  size                = "Standard_D2s_v3"
  admin_username      = "azureuser"
  admin_ssh_key {
    username   = "azureuser"
    public_key = var.ssh_pub_key
  }
  network_interface_ids = [
    azurerm_network_interface.NIC-VM2-Website.id,
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

  tags = {
    environment = "test"
    purpose     = "virtual-machine"
  }
}


#### Network card for VM3 with an public IP adress ########

resource "azurerm_public_ip" "pip-VM3-test" {
  name                = "pip-VM3-test"
  resource_group_name = azurerm_resource_group.rg-test-internal-lb.name
  location            = azurerm_resource_group.rg-test-internal-lb.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "NIC-VM3-test" {
  name                = "NIC-VM3-Test"
  resource_group_name = azurerm_resource_group.rg-test-internal-lb.name
  location            = azurerm_resource_group.rg-test-internal-lb.location

  ip_configuration {
    name                          = "internalip-VM3-test"
    subnet_id                     = azurerm_subnet.subnet-test-internal-lb.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "192.168.50.13"
    public_ip_address_id          = azurerm_public_ip.pip-VM3-test.id
  }
}

##### CREATION OF Virtual Machine VM3-test which will be use to test the website ######

resource "azurerm_linux_virtual_machine" "VM3-test" {
  name                = "VM3-test"
  resource_group_name = azurerm_resource_group.rg-test-internal-lb.name
  location            = azurerm_resource_group.rg-test-internal-lb.location
  size                = "Standard_D2s_v3"
  admin_username      = "azureuser"
  admin_ssh_key {
    username   = "azureuser"
    public_key = var.ssh_pub_key
  }
  network_interface_ids = [
    azurerm_network_interface.NIC-VM3-test.id
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

  tags = {
    environment = "test"
    purpose     = "virtual-machine"
  }
}


## creating network security group

resource "azurerm_network_security_group" "SG-able-to-connect-on-public-SSH" {
  name                = "SG-public-SSH"
  location            = azurerm_resource_group.rg-test-internal-lb.location
  resource_group_name = azurerm_resource_group.rg-test-internal-lb.name

  security_rule {
    name                       = "Allow_ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow_http"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

### Association of Subnet and security group

resource "azurerm_subnet_network_security_group_association" "SG-to-Subnet" {
  subnet_id                 = azurerm_subnet.subnet-test-internal-lb.id
  network_security_group_id = azurerm_network_security_group.SG-able-to-connect-on-public-SSH.id
}

## Creating Load balancer and put 2 VM-Website in a Back Pool


#Creation of the load balancer

resource "azurerm_lb" "lb_website" {
  name                = "lb_website"
  resource_group_name = azurerm_resource_group.rg-test-internal-lb.name
  location            = azurerm_resource_group.rg-test-internal-lb.location

  frontend_ip_configuration {
    name               = "fip_lb_website"
    subnet_id          = azurerm_subnet.subnet-test-internal-lb.id
    private_ip_address_allocation = "Static"
    private_ip_address = "192.168.50.15"
  }
}

# Creation of the backend pool

resource "azurerm_lb_backend_address_pool" "BEP_lb_website" {
  name            = "BEP_lb_website"
  loadbalancer_id = azurerm_lb.lb_website.id
}

# Associate backend pool with the network card
resource "azurerm_network_interface_backend_address_pool_association" "NIC-VM1-test_TO_BEP_lb_website" {
  network_interface_id    = azurerm_network_interface.NIC-VM1-Website.id
  ip_configuration_name   = azurerm_network_interface.NIC-VM1-Website.ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.BEP_lb_website.id
}

resource "azurerm_network_interface_backend_address_pool_association" "NIC-VM2-test_TO_BEP_lb_website" {
  network_interface_id    = azurerm_network_interface.NIC-VM2-Website.id
  ip_configuration_name   = azurerm_network_interface.NIC-VM2-Website.ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.BEP_lb_website.id
}

# Creation of the nat rule

resource "azurerm_lb_rule" "lb-rule-website" {
  name                           = "lb-rule-Website"
  loadbalancer_id                = azurerm_lb.lb_website.id
  protocol                       = "Tcp"
  frontend_port                  = 8000
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.lb_website.frontend_ip_configuration[0].name
  probe_id = azurerm_lb_probe.Probe-lb-website.id
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.BEP_lb_website.id]
}

resource "azurerm_lb_probe" "Probe-lb-website" {
  name            = "probe_lb_website"
  loadbalancer_id = azurerm_lb.lb_website.id
  port            = 80
  protocol        = "Http"
  request_path    = "/"
}