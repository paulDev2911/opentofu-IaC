terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc07"
    }
    talos = {
      source  = "siderolabs/talos"
      version = ">= 0.11.0"
    }
  }
}
