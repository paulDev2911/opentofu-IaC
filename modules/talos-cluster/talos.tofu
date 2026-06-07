# Cluster Secrets
resource "talos_machine_secrets" "this" {
  talos_version = "v${var.talos_version}"
}

# Machine Configurations
data "talos_machine_configuration" "controlplane" {
  cluster_name       = var.cluster_name
  cluster_endpoint   = "https://${var.cluster_vip_shared_ip}:6443"
  machine_type       = "controlplane"
  machine_secrets    = talos_machine_secrets.this.machine_secrets
  talos_version      = "v${var.talos_version}"
  kubernetes_version = var.kubernetes_version
}

data "talos_machine_configuration" "worker" {
  cluster_name       = var.cluster_name
  cluster_endpoint   = "https://${var.cluster_vip_shared_ip}:6443"
  machine_type       = "worker"
  machine_secrets    = talos_machine_secrets.this.machine_secrets
  talos_version      = "v${var.talos_version}"
  kubernetes_version = var.kubernetes_version
}

# Client Configuration (talosconfig)
data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = concat([var.cluster_vip_shared_ip], [for k, v in var.node_data.controlplanes : k])
}

# apply Config on Controlplane Nodes
resource "talos_machine_configuration_apply" "controlplane" {
  depends_on = [proxmox_vm_qemu.controlplane]
  for_each   = var.node_data.controlplanes

  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controlplane.machine_configuration
  node                        = each.key

  config_patches = concat(
    [
      templatefile("${path.module}/templates/controlplane.tftpl", {
        hostname                          = each.value.hostname != null ? each.value.hostname : format("%s-cp-%s", var.cluster_name, index(keys(var.node_data.controlplanes), each.key))
        install_disk                      = each.value.install_disk
        install_image                     = each.value.install_image
        dns                               = var.dns_server
        ip_address                        = each.key
        network_prefix                    = var.network_prefix
        network_gateway                   = var.network_gateway
        vip_shared_ip                     = var.cluster_vip_shared_ip
        allow_scheduling_on_controlplanes = var.allow_scheduling_on_controlplanes
        cilium_manifest = file("${path.module}/cilium.yaml")
        }),
    ],
    var.talos_config_patch_controlplane != "" ? [var.talos_config_patch_controlplane] : []
  )
}

# apply Config on Worker Nodes
resource "talos_machine_configuration_apply" "worker" {
  depends_on = [proxmox_vm_qemu.worker]
  for_each   = var.node_data.workers

  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker.machine_configuration
  node                        = each.key

  config_patches = concat(
    [
      templatefile("${path.module}/templates/worker.tftpl", {
        hostname        = each.value.hostname != null ? each.value.hostname : format("%s-worker-%s", var.cluster_name, index(keys(var.node_data.workers), each.key))
        install_disk    = each.value.install_disk
        install_image   = each.value.install_image
        dns             = var.dns_server
        ip_address      = each.key
        network_prefix  = var.network_prefix
        network_gateway = var.network_gateway
      }),
    ],
    var.talos_config_patch_worker != "" ? [var.talos_config_patch_worker] : []
  )
}

# Bootstrap
resource "talos_machine_bootstrap" "this" {
  depends_on           = [talos_machine_configuration_apply.controlplane]
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = [for k, v in var.node_data.controlplanes : k][0]
}

# call Kubeconfig
resource "talos_cluster_kubeconfig" "this" {
  depends_on           = [talos_machine_bootstrap.this]
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = [for k, v in var.node_data.controlplanes : k][0]
  endpoint             = var.cluster_vip_shared_ip
}
