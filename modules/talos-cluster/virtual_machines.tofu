resource "proxmox_vm_qemu" "controlplane" {
  for_each = var.node_data.controlplanes

  name        = each.value.hostname != null ? each.value.hostname : format("%s-cp-%s", var.cluster_name, index(keys(var.node_data.controlplanes), each.key))
  target_node = var.proxmox_target_node
  agent       = 1
  vm_state    = "running"
  memory      = each.value.memory_mb
  boot        = "order=virtio0;ide2"
  nameserver  = var.dns_server

  cpu {
    cores = each.value.cores
  }

  vga {
    type = "std"
  }

  disk {
    slot    = "ide0"
    type    = "cloudinit"
    storage = var.proxmox_storage_device
  }

  disk {
    slot = "ide2"
    type = "cdrom"
    iso  = "local:iso/${var.talos_iso_filename}"
  }

  disk {
    slot    = "virtio0"
    type    = "disk"
    storage = var.proxmox_storage_device
    size    = "${each.value.disk_gb}G"
    discard = true
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
    tag    = var.vlan_tag
  }

  os_type   = "cloud-init"
  ipconfig0 = "ip=${each.key}/${var.network_prefix},gw=${var.network_gateway}"
}

resource "proxmox_vm_qemu" "worker" {
  for_each = var.node_data.workers

  name        = each.value.hostname != null ? each.value.hostname : format("%s-worker-%s", var.cluster_name, index(keys(var.node_data.workers), each.key))
  target_node = var.proxmox_target_node
  agent       = 1
  vm_state    = "running"
  memory      = each.value.memory_mb
  boot        = "order=virtio0;ide2"
  nameserver  = var.dns_server

  cpu {
    cores = each.value.cores
  }

  vga {
    type = "std"
  }

  disk {
    slot    = "ide0"
    type    = "cloudinit"
    storage = var.proxmox_storage_device
  }

  disk {
    slot = "ide2"
    type = "cdrom"
    iso  = "local:iso/${var.talos_iso_filename}"
  }

  disk {
    slot    = "virtio0"
    type    = "disk"
    storage = var.proxmox_storage_device
    size    = "${each.value.disk_gb}G"
    discard = true
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
    tag    = var.vlan_tag
  }

  os_type   = "cloud-init"
  ipconfig0 = "ip=${each.key}/${var.network_prefix},gw=${var.network_gateway}"
}
