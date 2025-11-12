locals {
  project    = "dataworks"
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name

  tags = {
    project       = local.project
    business_unit = "data-platform"
    environment   = var.environment
    owner         = "modular-data"
    application   = "dataworks-domains"
  }
  dps_endpoints  = { for key, value in var.endpoints : key => value if value.setup && startswith(key, "dps") }
  is_dev_or_test = var.environment == "development" || var.environment == "test"
  # We only want to enable write to Operational DataStore in certain environments until it is available in all environments
  glue_datahub_job_extra_ods_args = (local.is_dev_or_test || var.environment == "preproduction" ? {
    "--dwh.operational.data.store.write.enabled"              = "true"
    "--dwh.operational.data.store.loading.schema.name"        = "loading"
    "--dwh.operational.data.store.glue.connection.name"       = data.aws_glue_connection.glue_operational_datastore_connection.name
    "--dwh.operational.data.store.tables.to.write.table.name" = "configuration.datahub_managed_tables"
    "--dwh.operational.data.store.jdbc.batch.size"            = 5000
  } : {})

  kms_read_access_policy_arn   = "arn:aws:iam::${local.account_id}:policy/${local.project}_kms_read_policy"
  s3_read_write_policy_arn     = "arn:aws:iam::${local.account_id}:policy/${local.project}_s3_read_write_policy"
  all_state_machine_policy_arn = "arn:aws:iam::${local.account_id}:policy/${local.project}_all_state_machine_policy"
  dps_host = {
    for key, value in local.dps_endpoints :
    key => jsondecode(data.aws_secretsmanager_secret_version.this[key].secret_string)["endpoint"]
  }
  dps_port_num = {
    for key, value in local.dps_endpoints :
    key => jsondecode(data.aws_secretsmanager_secret_version.this[key].secret_string)["port"]
  }
  dps_database_name = {
    for key, value in local.dps_endpoints :
    key => jsondecode(data.aws_secretsmanager_secret_version.this[key].secret_string)["db_name"]
  }
  dps_full_connection_strings = {
    for key, value in local.dps_endpoints :
    replace(key, "-", "_") => "postgres://jdbc:postgresql://${local.dps_host[key]}:${local.dps_port_num[key]}/${local.dps_database_name[key]}?$${${data.aws_secretsmanager_secret.this[key].name}}"
  }

  nomis            = "nomis"
  clustered_tables = "clustered-tables"
  nomis_secret     = data.aws_secretsmanager_secret_version.this[local.nomis].secret_string

  redshift_host = jsondecode(data.aws_secretsmanager_secret_version.redshift.secret_string)["host"]
  redshift_datamart_connection_string = {
    redshift_datamart = "redshift://jdbc:redshift://${local.redshift_host}/datamart?$${${data.aws_secretsmanager_secret.redshift.name}}"
  }
}
