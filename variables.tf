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
  }))
}

variable "ssh_public" {
  description = "Public key for ssh"
  type = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCvvoGXh+X9WkflAwDm0ifPARGDBDlRQS94zoQ+nj7C4pFPacOpygI9rn5l0s77RTQQNuHKSpjkeYMQG4nbjCh7OgN/8Ai713rVgCBDKaob77m+JFoNr/JSLeeeODtiav2uIZqlpI5JyyYC8MFy7HdmJOB8RTi8bWYFITrS2Uo4FT+ZQoMnrboYJOTcDC4167Dgx+5UUYyXBqLLhtyRPLa951uzx6U7As90hqTxDcf7h5aWchne47mMzjAnDkmGle00u+Yvt2wCS3BjlyffwculS9ZffmHd9zi/FXMpfVlDnKyMqvo3TMcUk1mVCvRcmdgBey2drrsyJuFOSfh/j/vJy1cZ5ECN+W7Vmsdjpupt13xqpkHzV7Yq3YSx4zfsnNXeCn5OvvaA+3rd2MwpMQqZz2bahSLcqbATLGTVrI/4fLdWtmngjyZYAW+hJ4gxqAtcO+D8oQsnV9Cd75wJZwHS5GNxGZhr8CZDPqsR9kw/9qC5EcJSnYvU3JFlAvY3cW4UoSXCmLF3KwYtB8IDD/tZZyRKJgqjEnkl+HbK7838Q1WpeGp/WXZn2v+rzL1uvgaoarurm8szpslly9VUSvSeUuV8CF5H99nwSc2RHh3e0QS1d9g2Cog65wSE5LrdeADnGuwnFsnluLqHWBl/A5/Q/77CuTM+HsS4chDT3+cxUw=="
}