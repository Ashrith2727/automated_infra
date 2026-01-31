output "vm_ip" {
  description = "IP address of the VM"
  value       = libvirt_domain.vm.network_interface[0].addresses[0]
}
