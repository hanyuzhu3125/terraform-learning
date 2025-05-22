resource "helm_release" "monitoring_stack" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "57.0.3"

  namespace        = "monitoring"
  create_namespace = true

  values = [
    <<-EOF
    grafana:
      adminPassword: "prom-operator"
      service:
        type: LoadBalancer
      ingress:
        enabled: false
    prometheus:
      service:
        type: LoadBalancer
    EOF
  ]

  depends_on = [module.eks]
}