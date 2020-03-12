#######################
# Cloudwatch Exporter #
#######################

resource "helm_release" "cloudwatch_exporter" {
  count     = var.enable_cloudwatch_exporter ? 1 : 0

  name      = "cloudwatch-exporter"
  namespace = kubernetes_namespace.monitoring.id
  chart     = "stable/prometheus-cloudwatch-exporter"

  values = [
    file("${path.module}/resources/cloudwatch-exporter.yaml"),
  ]

  set {
    name  = "aws.role"
    value = aws_iam_role.cloudwatch_exporter.0.name
  }

  depends_on = [
    var.dependence_deploy,
    helm_release.prometheus_operator,
  ]

  lifecycle {
    ignore_changes = [keyring]
  }
}

