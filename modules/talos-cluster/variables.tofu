variable "proxmox_target_node" {
  description = "Proxmox node to deploy VMs on"
  type        = string
}

variable "proxmox_storage_device" {
  description = "Proxmox storage pool for VM disks"
  type        = string
}

variable "talos_version" {
  description = "Talos version without v prefix (e.g. 1.13.3)"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version (e.g. 1.32.3)"
  type        = string
}

variable "talos_iso_filename" {
  description = "Talos nocloud ISO filename on Proxmox local storage"
  type        = string
  default     = "nocloud-amd64.iso"
}

variable "cluster_name" {
  description = "Cluster name"
  type        = string
}

variable "cluster_vip_shared_ip" {
  description = "Virtual IP for controlplane HA"
  type        = string
}

variable "node_data" {
  description = "Controlplane and worker node definitions. Map key = node IP."
  type = object({
    controlplanes = map(object({
      install_disk  = string
      install_image = string
      hostname      = optional(string)
      cores         = optional(number, 2)
      memory_mb     = optional(number, 4096)
      disk_gb       = optional(number, 50)
    }))
    workers = map(object({
      install_disk  = string
      install_image = string
      hostname      = optional(string)
      cores         = optional(number, 4)
      memory_mb     = optional(number, 8192)
      disk_gb       = optional(number, 100)
    }))
  })
}

variable "network_gateway" {
  type = string
}

variable "network_prefix" {
  type    = number
  default = 24
}

variable "dns_server" {
  type    = string
  default = "1.1.1.1"
}

variable "vlan_tag" {
  type    = number
  default = 0
}

variable "allow_scheduling_on_controlplanes" {
  type    = bool
  default = true
}

variable "talos_config_patch_controlplane" {
  description = "Extra config patch YAML for controlplane nodes"
  type        = string
  default     = ""
}

variable "talos_config_patch_worker" {
  description = "Extra config patch YAML for worker nodes"
  type        = string
  default     = ""
}
