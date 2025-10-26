data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

# VPC and subnet data
data "aws_vpc" "shared" {
  tags = {
    "Name" = "${local.business-unit}-${var.environment}"
  }
}

data "aws_subnet" "data_subnets_a" {
  vpc_id = data.aws_vpc.shared.id
  tags = {
    "Name" = "${local.business-unit}-${var.environment}-${local.set}-data-${data.aws_region.current.name}a"
  }
}

data "aws_subnet" "data_subnets_b" {
  vpc_id = data.aws_vpc.shared.id
  tags = {
    "Name" = "${local.business-unit}-${var.environment}-${local.set}-data-${data.aws_region.current.name}b"
  }
}

data "aws_subnet" "data_subnets_c" {
  vpc_id = data.aws_vpc.shared.id
  tags = {
    "Name" = "${local.business-unit}-${var.environment}-${local.set}-data-${data.aws_region.current.name}c"
  }
}

data "aws_subnet" "private_subnets_a" {
  vpc_id = data.aws_vpc.shared.id
  tags = {
    "Name" = "${local.business-unit}-${var.environment}-${local.set}-private-${data.aws_region.current.name}a"
  }
}

# ECR Repository
data "aws_ecr_repository" "file_transfer_in_clamav_scanner" {
  name = "${local.project}-container-images/hmpps-dwh-landing-zone-antivirus-check"
}

########################
# Source Generic lambda ID
data "aws_security_group" "generic_lambda" {
  vpc_id = data.aws_vpc.shared.id

  filter {
    name   = "group-name"
    values = ["dwh-generic-lambda-sg*"]
  }

  filter {
    name   = "tag:Name"
    values = ["dwh-generic-lambda-sg"]
  }

  filter {
    name   = "tag:Used_By"
    values = ["service_bundle"]
  }
}

########################
# Source All Secrets
data "aws_secretsmanager_secret" "this" {
  for_each = {
    for k, v in var.endpoints : k => v
    if v.setup
  }
  # Same secret is used by Nomis Binary Reader and LogMiner (clustered tables) endpoints
  name = "external/${local.project}-${each.key == local.clustered_tables ? local.nomis : each.key}-source-secrets"
}

data "aws_secretsmanager_secret_version" "this" {
  for_each = {
    for k, v in var.endpoints : k => v
    if v.setup
  }

  # Same secret is used by Nomis Binary Reader and LogMiner (clustered tables) endpoints
  secret_id = data.aws_secretsmanager_secret.this[each.key == local.clustered_tables ? local.nomis : each.key].id
}

# S3 Buckets
data "aws_s3_bucket" "landing" {
  bucket = "${local.project}-landing-zone-${var.environment}"
}

data "aws_s3_bucket" "landing_processing" {
  bucket = "${local.project}-landing-processing-zone-${var.environment}"
}

data "aws_s3_bucket" "quarantine" {
  bucket = "${local.project}-quarantine-zone-${var.environment}"
}

data "aws_s3_bucket" "schema_registry" {
  bucket = "${local.project}-schema-registry-${var.environment}"
}

data "aws_s3_bucket" "raw" {
  bucket = "${local.project}-raw-zone-${var.environment}"
}

data "aws_s3_bucket" "glue" {
  bucket = "${local.project}-glue-jobs-${var.environment}"
}

data "aws_s3_bucket" "raw_archive" {
  bucket = "${local.project}-raw-archive-${var.environment}"
}

data "aws_s3_bucket" "structured" {
  bucket = "${local.project}-structured-zone-${var.environment}"
}

data "aws_s3_bucket" "violations" {
  bucket = "${local.project}-violation-${var.environment}"
}

data "aws_s3_bucket" "curated" {
  bucket = "${local.project}-curated-zone-${var.environment}"
}

data "aws_s3_bucket" "temp_reload" {
  bucket = "${local.project}-temp-reload-${var.environment}"
}

data "aws_s3_bucket" "artifact-store" {
  bucket = "${local.project}-artifact-store-${var.environment}"
}

data "aws_s3_bucket" "glue_jobs" {
  bucket = "${local.project}-glue-jobs-${var.environment}"
}

data "aws_s3_bucket" "domain" {
  bucket = "${local.project}-domain-${var.environment}"
}

# Retrieve KMS
data "aws_kms_key" "default" {
  key_id = "alias/${local.project}-s3-kms"
}

# Glue Connection for Operational Data Store
data "aws_glue_connection" "glue_operational_datastore_connection" {
  id = "${local.account_id}:${local.project}-operational-datastore-connection"
}

# Glue Connection for Nomis
data "aws_glue_connection" "glue_nomis_connection" {
  id = "${local.account_id}:${local.project}-nomis-connection"
}

# All Glue Connections for DPS
data "aws_glue_connection" "glue_dps_connection" {
  for_each = local.dps_endpoints
  id       = "${local.account_id}:${local.project}-${each.key}-connection"
}

# Operational Data Store credentials secret
data "aws_secretsmanager_secret" "operational_db_secret" {
  name = "${local.project}-rds-operational-db-secret"
}

# Nomis credentials secret
data "aws_secretsmanager_secret" "nomis_secret" {
  name = "external/${local.project}-nomis-source-secrets"
}

# All secrets for DPS
data "aws_secretsmanager_secret" "dps_secret" {
  for_each = local.dps_endpoints
  name     = "external/${local.project}-${each.key}-source-secrets"
}

# All secrets for DWH
data "aws_secretsmanager_secret" "dwh_secret" {
  count = local.is_dev_or_test ? 1 : 0

  name = "external/${local.project}-dps-test-db-source-secrets"
}

data "aws_secretsmanager_secret" "redshift" {
  name = "dwh-redshift-sqlworkbench-${var.environment}"
}

data "aws_secretsmanager_secret_version" "redshift" {
  secret_id = data.aws_secretsmanager_secret.redshift.id
}
