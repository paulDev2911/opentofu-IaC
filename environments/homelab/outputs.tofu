output "controlplane_ips" {
  description = "Controlplane node IPs"
  value       = module.talos_cluster.controlplane_ips
}

output "worker_ips" {
  description = "Worker node IPs"
  value       = module.talos_cluster.worker_ips
}

output "kubeconfig_path" {
  description = "Path to kubeconfig"
  value       = local_sensitive_file.kubeconfig.filename
}

output "talosconfig_path" {
  description = "Path to talosconfig"
  value       = local_sensitive_file.talosconfig.filename
}
