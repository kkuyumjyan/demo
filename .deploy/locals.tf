locals {
  env = terraform.workspace

  helm_values = [templatefile("${path.module}/values.yaml", {
    ENVIRONMENT             = local.env
    AWS_ACCESS_KEY_ID       = aws_iam_access_key.demo_api.id
    AWS_SECRET_ACCESS_KEY   = aws_iam_access_key.demo_api.secret
    INGRESS_HOST            = lookup(var.ingress_hostname, local.env)
    IMAGE_TAG               = var.image_tag
    DB_NAME                 = var.database_name
    DB_USER                 = var.database_username
    DB_PASSWORD             = module.db.cluster_master_password
    DB_HOST                 = module.db.cluster_endpoint
    DB_PORT                 = "5432"
    SERVER_TOKEN            = jsondecode(data.aws_secretsmanager_secret_version.server_token.secret_string)["cross_server_token"]
    TRIGGER_DASHBOARD_TOKEN = random_password.trigger_dashboard_token.result
  })]
}
