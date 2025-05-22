output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = data.aws_eks_cluster.cluster.endpoint
}

output "grafana_url" {
  description = "Grafana LoadBalancer DNS (may take a few minutes after apply)"
  value       = try(
    helm_release.monitoring_stack.status == "deployed" ?
    "http://${helm_release.monitoring_stack.name}-grafana.${helm_release.monitoring_stack.namespace}.svc.cluster.local" :
    "",
    ""
  )
}