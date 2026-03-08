variable "azure_region" {
  description = "The Azure region where resources will be created."
  type        = string
  default     = "eastus"
}

variable "virtual_machines" {
  description = "virtual machines set in a map where key index is the name of the vm, and key value is set to object where the variable needed for the creation of the VM is set"
  type = map(object({
    vm_name        = string
    priv_ip_adress = string
    ssh_key        = string
  }))
}