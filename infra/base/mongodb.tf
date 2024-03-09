resource "random_password" "root_password" {
  length  = 16
  special = false
}

resource "aws_docdb_subnet_group" "private_subnets" {
  name       = "private_subnets"
  subnet_ids = module.vpc.private_subnets
  depends_on = [module.vpc]
}

resource "aws_docdb_cluster_parameter_group" "mongodb_params" {
  family = "docdb5.0"
  name   = "nestjs-lambda-example-params"

  parameter {
    name  = "tls"
    value = "disabled"
  }

  parameter {
    name         = "ttl_monitor"
    value        = "disabled"
    apply_method = "immediate"
  }
}

resource "aws_docdb_cluster" "mongodb" {
  cluster_identifier              = "nestjs-lambda-example"
  master_username                 = "root"
  master_password                 = random_password.root_password.result
  db_subnet_group_name            = aws_docdb_subnet_group.private_subnets.id
  vpc_security_group_ids          = [aws_security_group.mongodb_sg.id]
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.mongodb_params.name
  apply_immediately               = true
  skip_final_snapshot             = true

  depends_on = [
    random_password.root_password,
    aws_security_group.mongodb_sg,
    aws_docdb_subnet_group.private_subnets,
    aws_docdb_cluster_parameter_group.mongodb_params
  ]
}

resource "aws_docdb_cluster_instance" "primary_instance" {
  count              = 1
  identifier         = "primary-instance"
  cluster_identifier = aws_docdb_cluster.mongodb.id
  instance_class     = "db.t3.medium"
  apply_immediately  = true
  depends_on         = [aws_docdb_cluster.mongodb]
}

resource "aws_secretsmanager_secret" "mongodb_creds" {
  name_prefix = "secrets/mongodb_creds"
}

resource "aws_secretsmanager_secret_version" "mongodb_creds" {
  secret_id = aws_secretsmanager_secret.mongodb_creds.id
  secret_string = jsonencode({
    master_user     = "root"
    master_password = random_password.root_password.result
    endpoint        = aws_docdb_cluster.mongodb.endpoint
  })
  depends_on = [aws_docdb_cluster.mongodb, aws_secretsmanager_secret.mongodb_creds]
}
