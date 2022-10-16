resource "helm_release" "hextris" {
  name = "hetrix-chart"
  chart = "."
  repository = "./hextris-chart"
  namespace = var.namespace_name
  max_history = 3
  create_namespace = true
  wait = true
  reset_values = true
}