### PRIVATE ###############
output "VM1-Website-internal-ip" {
  description = "Internal IP of VM1"
  value       = module.vm_creation["vm1-website"].nic_priv_address
}

output "VM2-Website-internal-ip" {
  description = "Internal IP of VM2"
  value       = module.vm_creation["vm2-website"].nic_priv_address
}

output "VM3-test-internal-ip" {
  description = "Internal IP of VM3"
  value       = module.vm_creation["vm3-client"].nic_priv_address
}

### PUBLIC ########################

output "VM1-Website-public-ip" {
  description = "Public IP of VM1"
  value       = module.vm_creation["vm1-website"].public_ip
}

output "VM2-Website-public-ip" {
  description = "Public IP of VM2"
  value       = module.vm_creation["vm2-website"].public_ip
}

output "VM3-Test-public-ip" {
  description = "Public IP of VM3"
  value       = module.vm_creation["vm3-client"].public_ip
}