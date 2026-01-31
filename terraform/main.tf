provider "libvirt" {
  uri = "qemu:///session"
}

resource "libvirt_pool" "default" {
  name = "automated-infra-pool"
  type = "dir"
  path = "${pathexpand("~")}/libvirt-pools/automated_infra"
}

resource "libvirt_volume" "ubuntu_image" {
  name   = "ubuntu-22.04.qcow2"
  pool   = libvirt_pool.default.name
  source = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
  format = "qcow2"
}

resource "libvirt_cloudinit_disk" "cloudinit" {
  name = "cloudinit.iso"
  pool = libvirt_pool.default.name

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
    volume_id = libvirt_volume.ubuntu_image.id
  }
}
