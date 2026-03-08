variable "vm_name" {
    description = "Name of the vm"
    type        = string
}

variable "rg_name" {
    description = "Name of the resource group where the resource will be link to"
    type        = string
}

variable "localization" {
    description = "Location of the resource"
    type        = string
}

variable "subnet_id" {
    description = "Subnet ID for the network card to be in"
    type        = string
}

variable "priv_ip_adress" {
    description = "Private IP of the Network Card"
    type        = string 
}

variable "ssh_key" {
    description = "ssh Public key"
    type        = string
}