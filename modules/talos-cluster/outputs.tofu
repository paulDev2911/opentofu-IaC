output "talosconfig" {
  description = "Talosconfig for talosctl"
  value       = data.talos_client_configuration.this.talos_config
  sensitive   = true
}

output "kubeconfig" {
  description = "Kubeconfig for kubectl"
  value       = talos_cluster_kubeconfig.this.kubeconfig_raw
  sensitive   = true
}

output "controlplane_ips" {
  description = "Controlplane node IPs"
  value       = [for k, v in var.node_data.controlplanes : k]
}

output "worker_ips" {
  description = "Worker node IPs"
  value       = [for k, v in var.node_data.workers : k]
}
