variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
  default     = "automated-infra-vm"
}

variable "memory" {
  description = "Memory in MB"
  type        = number
  default     = 2048
}

variable "vcpu" {
  description = "Number of vCPUs"
  type        = number
  default     = 2
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key"
  type        = string
  default     = "~/.ssh/automated_infra.pub"
}
