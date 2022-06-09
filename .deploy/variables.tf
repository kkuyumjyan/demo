variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "environment" {
  type    = string
  default = "development"
}

variable "vpc_id" {
  type = map(string)
  default = {
    development = "vpc-0edbb8f123456789"
    staging     = "vpc-0b00e2f123456789"
    production  = "vpc-0492d3c123456789"
  }
}

variable "eks_name" {
  type = map(string)
  default = {
    development = "eks-dev"
    staging     = "eks-stage"
    production  = "eks-prod"
  }
}

variable "database_name" {
  default = "example-co_tv_triggers"
  type    = string
}

variable "database_username" {
  default = "postgres"
  type    = string
}

variable "image_tag" {
  default = "latest"
  type    = string
}

variable "ingress_hostname" {
  type = map(string)
  default = {
    development = "dev.example-co.tv"
    staging     = "stage.example-co.tv"
    production  = "example-co.tv"
  }
}

variable "secret_prefix" {
  type = map(string)
  default = {
    development = "dev"
    staging     = "dev"
    production  = "prod"
  }
}
