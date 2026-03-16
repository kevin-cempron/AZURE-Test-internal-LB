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
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCwtvm5PUIS1BT04aNTqGSyyrsBrmNzncxQzRFxJE6vIatJ3y3H/5TwHxweLsuL1QkDkTyriq/ns/+cw8pre1lv1n+Vrz5TgRVdu23MO0GMRZz6yX7sw8M3n8QgdtAN+4UyP2dE9Ht/aHQqNpGRDDgyslXSz3AKcCV0nyvASPdW9TTssU+U+86nPlyVV0PDeDE97g5RqyrVpno2zq7PNTdgJ8Rhw8T7ADUM6CPLCUAGBFiQuwpkfrgxzFMGMGvFRHY1yYRtfpD401HkO22Ozgjg6U8BGixpGcCBoQFcOXpPp66ogURsQMDEBiID+sYjdeI2p5yUkf98TcbmgoelcMIYxqc0aaqv/dWjtoRhDsM0fBe3FXVdD1kTAcSUTUIZR56vYlkQg5hAAiIPsQuMxa/rE0nc0Aze0xQsFIcUK8L5sWLEhCTP0H9EdoTwr8928lLzygmZmpj4ys8XAXfOdqfIjhMrPIBaZU3Zgr75jOrEvRNXDzgIVyC/WJkXF9o5ck7T7naIqa5iPbd+91JZZtpXJ2aT9O0idCvEPs4rVyk56Y0bvIw9NNQgBTM0oOGHD6cKXaVvHbmxfCMsxEvOUtGbr7jQsO/Fm8AD7FD8jW9ed4z88iX25AYvgl5FlHpZF2y/FMAEa2KxKIfJDoDDt7cm2HTX4of4/aM3KxPqLHzn2Q=="
}