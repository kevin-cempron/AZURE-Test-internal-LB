variable "azure_region" {
  description = "The Azure region where resources will be created."
  type        = string
  default     = "eastus"
}

variable "ssh_pub_key" {
  description = "Public key to be able to authenticate on the server"
  type        = string
}