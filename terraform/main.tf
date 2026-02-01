provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_volume" "ubuntu_image" {
  name   = "ubuntu-22.04.qcow2"
  pool   = "default"
  source = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
  format = "qcow2"
}

resource "libvirt_volume" "ubuntu_resized" {
  name           = "ubuntu-vm-disk.qcow2"
  pool           = "default"
  base_volume_id = libvirt_volume.ubuntu_image.id
  format         = "qcow2"
  
  # Specify size in bytes (e.g., 20GB = 20 * 1024 * 1024 * 1024)
  size = 21474836480 
}

resource "libvirt_cloudinit_disk" "cloudinit" {
  name = "cloudinit.iso"
  pool = "default"

  user_data = <<EOF
#cloud-config
users:
  - name: devops
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    ssh-authorized-keys:
      - ${file(var.ssh_public_key_path)}

ssh_pwauth: false
disable_root: true
EOF
}

resource "libvirt_domain" "vm" {
  name   = var.vm_name
  memory = var.memory
  vcpu   = var.vcpu
  

  cloudinit = libvirt_cloudinit_disk.cloudinit.id

  network_interface {
    network_name   = "default"
    wait_for_lease = true
  }

  disk {
    volume_id = libvirt_volume.ubuntu_resized.id
  }
}
