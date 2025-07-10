resource "random_integer" "vmid" {
  min = 9000
  max = 9999
}

resource "random_pet" "name" {
  length = 2
}
resource "proxmox_vm_qemu" "cloudinit" {

  vmid        = random_integer.vmid.result
  name        = random_pet.name.id
  target_node = var.target_node

  clone      = "linux-cloudinit-template"
  full_clone = true
  bios       = "seabios"
  agent      = 1
  scsihw     = "virtio-scsi-single"
  os_type    = "cloud-init"
  memory     = 2048
  onboot     = true
  vm_state   = "running"
  ipconfig0  = "ip=dhcp"
  skip_ipv6  = true

  ciuser     = var.ciuser
  cipassword = var.cipassword
  sshkeys    = var.ssh_public_key
  cpu {
    type    = "host"
    sockets = 1
    cores   = 1
  }

  network {
    id       = 0
    model    = "virtio"
    firewall = true
    bridge   = "vmbr0"
  }
  serial {
    id   = 0
    type = "socket"
  }

  disks {
    scsi {
      scsi0 {
        disk {
          size      = "32G"
          storage   = var.datacenter_storage
          replicate = "true"
        }
      }
    }
    ide {
      ide0 {
        cloudinit {
          storage = var.datacenter_storage
        }
      }
    }
  }
}
