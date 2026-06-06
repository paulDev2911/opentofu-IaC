# proxmox
variable "proxmox_api_url" {
  description = "Proxmox API URL (e.g. https://192.168.2.84:8006/api2/json)"
  type        = string
}

variable "proxmox_api_token_id" {
  description = "Proxmox API token ID (e.g. root@pam!opentofu)"
  type        = string
  sensitive   = true
}

variable "proxmox_api_token_secret" {
  description = "Proxmox API token secret"
  type        = string
  sensitive   = true
}

variable "proxmox_target_node" {
  description = "Proxmox node name (e.g. pve01)"
  type        = string
}

variable "proxmox_storage_device" {
  description = "Proxmox storage pool for VM disks (e.g. pvepool01)"
  type        = string
}

# talos / kubernetes
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

# cluster
variable "cluster_name" {
  description = "Cluster name"
  type        = string
  default     = "homelab"
}

variable "cluster_vip_shared_ip" {
  description = "Virtual IP for controlplane (single-node: same as CP IP)"
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

# network
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
  description = "VLAN tag for VM interfaces. 0 = no VLAN."
  type        = number
  default     = 0
}

variable "allow_scheduling_on_controlplanes" {
  description = "Allow pods on controlplane nodes (recommended for small homelabs)"
  type        = bool
  default     = true
}
