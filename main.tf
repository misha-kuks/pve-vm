terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = ">=1.0.0"
    }
  }
  required_version = ">= 0.14"
}

provider "proxmox" {
  pm_api_url = "https://${var.pve_ip_address}:8006/api2/json"
  pm_user =var.pm_user
  pm_password =var.pm_password
  pm_log_file   = "terraform-plugin-proxmox.log"
 
}

resource "proxmox_vm_qemu" "virtual_machine" {
  count = 2
  name = "MyVMPVE${count.index + 1}"
  target_node = var.proxmox_host
  clone = var.template
  os_type = "cloud-init"
  agent = 1
  cores = 4
  sockets = "1"
  memory = 4096
  cpu = "host"
  scsihw = "virtio-scsi-pci"
  bootdisk = "virtio0"

disk {
    slot = 0
    size = "10G"
    type = "virtio"
    storage = var.storage
}
network {
    model           = "virtio"
    bridge          = "vmbr0"
}

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

# Cloud Init Settings
ipconfig0 = "ip=10.0.155.20${count.index + 1}/24,gw=10.0.155.1"
 ssh_user = "ubuntu" 
 sshkeys = var.ssh_keys


}
