module "talos_cluster" {
  source = "../../modules/talos-cluster"

  proxmox_target_node    = var.proxmox_target_node
  proxmox_storage_device = var.proxmox_storage_device

  talos_version      = var.talos_version
  kubernetes_version = var.kubernetes_version
  talos_iso_filename = var.talos_iso_filename

  cluster_name          = var.cluster_name
  cluster_vip_shared_ip = var.cluster_vip_shared_ip
  node_data             = var.node_data

  network_gateway                   = var.network_gateway
  network_prefix                    = var.network_prefix
  dns_server                        = var.dns_server
  vlan_tag                          = var.vlan_tag
  allow_scheduling_on_controlplanes = var.allow_scheduling_on_controlplanes
}

# Kubeconfig + Talosconfig
resource "local_sensitive_file" "kubeconfig" {
  content         = module.talos_cluster.kubeconfig
  filename        = "${path.module}/secrets/kubeconfig"
  file_permission = "0600"
}

resource "local_sensitive_file" "talosconfig" {
  content         = module.talos_cluster.talosconfig
  filename        = "${path.module}/secrets/talosconfig"
  file_permission = "0600"
}
