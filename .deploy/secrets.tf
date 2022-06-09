data "aws_secretsmanager_secret" "server_token" {
  name = "${lookup(var.secret_prefix, local.env)}/cross_server_token"
}

data "aws_secretsmanager_secret_version" "server_token" {
  secret_id = data.aws_secretsmanager_secret.server_token.id
}

resource "random_password" "trigger_dashboard_token" {
  length    = 12
  special   = false
  lower     = true
  upper     = true
  min_upper = 2
}

resource "aws_secretsmanager_secret" "trigger_dashboard_token" {
  name                    = "${local.env}/trigger_dashboard_token"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "trigger_dashboard_token" {
  secret_id     = aws_secretsmanager_secret.trigger_dashboard_token.id
  secret_string = <<EOT
  {
    "trigger_dashboard_token": "${random_password.trigger_dashboard_token.result}",
  }
  EOT
}
