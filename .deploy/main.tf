resource "helm_release" "app" {
  depends_on = [module.db]
  chart      = "./helm"
  namespace  = "example-co"
  name       = "demo-api-${local.env}"
  values     = local.helm_values
}
