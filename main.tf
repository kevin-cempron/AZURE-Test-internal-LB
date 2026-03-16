provider "azurerm" {
  features {}
  use_oidc = true
}

#Resource Group creation which will include all all the resources ##########
resource "azurerm_resource_group" "rg_test_internal_lb" {
  name     = "rg_test_internal_lb"
  location = var.azure_region
}



#Virtual Network creation which will include the 3 VM ###########
resource "azurerm_virtual_network" "vnet_test_internal_lb" {
  name                = "vnet_test_internal_lb"
  resource_group_name = azurerm_resource_group.rg_test_internal_lb.name
  location            = azurerm_resource_group.rg_test_internal_lb.location
  address_space       = ["192.168.50.0/24"]

  tags = {
    environment = "test"
    purpose     = "virtual-network"
  }
}

resource "azurerm_subnet" "subnet_test_internal_lb" {
  name                 = "subnet_test_internal_lb"
  resource_group_name  = azurerm_resource_group.rg_test_internal_lb.name
  virtual_network_name = azurerm_virtual_network.vnet_test_internal_lb.name
  address_prefixes     = ["192.168.50.0/24"]
}

resource "azurerm_ssh_public_key" "ssh_public" {
  name = "ssh_public"
  resource_group_name = azurerm_resource_group.rg_test_internal_lb.name
  location = azurerm_resource_group.rg_test_internal_lb.location
  public_key = var.ssh_public
}

module "vm_creation" {
  source   = "./module/vm-linux"
  for_each = var.virtual_machines

  vm_name        = each.value.vm_name
  priv_ip_adress = each.value.priv_ip_adress

  ssh_key        = azurerm_ssh_public_key.ssh_public.public_key
  rg_name        = azurerm_resource_group.rg_test_internal_lb.name
  localization   = azurerm_resource_group.rg_test_internal_lb.location
  subnet_id      = azurerm_subnet.subnet_test_internal_lb.id

}

## creating network security group

resource "azurerm_network_security_group" "SG_able_to_connect_on_public_SSH" {
  name                = "SG-public-SSH"
  location            = azurerm_resource_group.rg_test_internal_lb.location
  resource_group_name = azurerm_resource_group.rg_test_internal_lb.name

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

resource "azurerm_subnet_network_security_group_association" "SG_to_Subnet" {
  subnet_id                 = azurerm_subnet.subnet_test_internal_lb.id
  network_security_group_id = azurerm_network_security_group.SG_able_to_connect_on_public_SSH.id
}

## Creating Load balancer and put 2 VM-Website in a Back Pool


#Creation of the load balancer

resource "azurerm_lb" "lb_website" {
  name                = "lb_website"
  resource_group_name = azurerm_resource_group.rg_test_internal_lb.name
  location            = azurerm_resource_group.rg_test_internal_lb.location

  frontend_ip_configuration {
    name                          = "fip_lb_website"
    subnet_id                     = azurerm_subnet.subnet_test_internal_lb.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "192.168.50.15"
  }
}

# Creation of the backend pool

resource "azurerm_lb_backend_address_pool" "BEP_lb_website" {
  name            = "BEP_lb_website"
  loadbalancer_id = azurerm_lb.lb_website.id
}

# Associate backend pool with the network card
resource "azurerm_network_interface_backend_address_pool_association" "NIC_VM1_test_TO_BEP_lb_website" {
  network_interface_id    = module.vm_creation["vm1-website"].nic_id
  ip_configuration_name   = module.vm_creation["vm1-website"].nic_ip_name
  backend_address_pool_id = azurerm_lb_backend_address_pool.BEP_lb_website.id
}

resource "azurerm_network_interface_backend_address_pool_association" "NIC_VM2_test_TO_BEP_lb_website" {
  network_interface_id    = module.vm_creation["vm2-website"].nic_id
  ip_configuration_name   = module.vm_creation["vm2-website"].nic_ip_name
  backend_address_pool_id = azurerm_lb_backend_address_pool.BEP_lb_website.id
}

# Creation of the rule of the LB

resource "azurerm_lb_rule" "lb-rule-website" {
  name                           = "lb-rule-Website"
  loadbalancer_id                = azurerm_lb.lb_website.id
  protocol                       = "Tcp"
  frontend_port                  = 8000
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.lb_website.frontend_ip_configuration[0].name
  probe_id                       = azurerm_lb_probe.Probe-lb-website.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.BEP_lb_website.id]
}

resource "azurerm_lb_probe" "Probe-lb-website" {
  name            = "probe_lb_website"
  loadbalancer_id = azurerm_lb.lb_website.id
  port            = 80
  protocol        = "Http"
  request_path    = "/"
}

###### CREATION OF PRIVATE DNS ZONE on in independant VNET

resource "azurerm_private_dns_zone" "private-dns-zone" {
  name                = "umbrella-corp.com"
  resource_group_name = azurerm_resource_group.rg_test_internal_lb.name
}


resource "azurerm_private_dns_zone_virtual_network_link" "link_dns_lb" {
  name                  = "link_dns_lb"
  resource_group_name   = azurerm_resource_group.rg_test_internal_lb.name
  private_dns_zone_name = azurerm_private_dns_zone.private-dns-zone.name
  virtual_network_id    = azurerm_virtual_network.vnet_test_internal_lb.id
}


resource "azurerm_private_dns_a_record" "example" {
  name                = "website"
  zone_name           = azurerm_private_dns_zone.private-dns-zone.name
  resource_group_name = azurerm_resource_group.rg_test_internal_lb.name
  ttl                 = 300
  records             = ["192.168.50.15"]
}



