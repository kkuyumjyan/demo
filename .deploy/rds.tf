data "aws_subnet_ids" "private" {
  vpc_id = lookup(var.vpc_id, local.env)

  tags = {
    tier = "private"
  }
}

resource "aws_secretsmanager_secret" "rds_password" {
  name = "dbpassword-demo-api-${local.env}"
}

resource "aws_secretsmanager_secret_version" "rds_password" {
  secret_id     = aws_secretsmanager_secret.rds_password.id
  secret_string = module.db.cluster_master_password
}


data "aws_rds_engine_version" "postgresql" {
  engine  = "aurora-postgresql"
  version = "13.6"
}

resource "aws_db_parameter_group" "postgresql" {
  name        = "demo-api-${local.env}-aurora-db-postgres13"
  family      = "aurora-postgresql13"
  description = "${var.database_name}-aurora-db-postgres13-parameter-group"
}

resource "aws_rds_cluster_parameter_group" "postgresql" {
  name        = "demo-api-${local.env}-aurora-postgres13-cluster"
  family      = "aurora-postgresql13"
  description = "demo-api-${local.env}-aurora-postgres13-cluster"
}

module "db" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "7.1.0"

  name              = "db-triggers-${local.env}"
  database_name     = var.database_name
  engine            = data.aws_rds_engine_version.postgresql.engine
  engine_mode       = "provisioned"
  engine_version    = data.aws_rds_engine_version.postgresql.version
  storage_encrypted = true

  master_username        = var.database_username
  create_random_password = true

  vpc_id                = lookup(var.vpc_id, local.env)
  subnets               = data.aws_subnet_ids.private.ids
  create_security_group = true
  allowed_cidr_blocks   = ["10.0.0.0/16"]

  monitoring_interval = 60

  apply_immediately   = true
  skip_final_snapshot = true

  db_parameter_group_name         = aws_db_parameter_group.postgresql.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.postgresql.id

  serverlessv2_scaling_configuration = {
    min_capacity = 1
    max_capacity = 8
  }

  instance_class = "db.serverless"
  instances = {
    one = {}
  }
}
