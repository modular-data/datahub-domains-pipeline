# Setup Endpoints,
# checkov:skip=CKV_TF_1: Commit hash not enforced for legacy module
module "setup-dms-endpoints" {
  source = "git::https://github.com/modular-data/datahub-tf-service-modules.git//modules/domains/dms-endpoints?ref=main"

  for_each = {
    for k, v in var.endpoints : k => v
    if v.setup
  }

  setup_dms_endpoints       = each.value["setup"]
  setup_dms_iam             = each.value["setup_dms_iam"]
  setup_dms_source_endpoint = each.value["setup_dms_source_endpoint"]
  setup_dms_s3_endpoint     = each.value["setup_dms_s3_endpoint"]
  source_engine_name        = each.value["source_engine"]["type"]
  source_ssl_mode           = each.value["source_engine"]["ssl_mode"]
  dms_source_name           = "${each.value["dms_source_name"]}${each.value["name_suffix"]}"
  dms_target_name           = each.value["dms_target_name"]
  project_id                = local.project   # common
  env                       = var.environment # common
  short_name                = each.key
  source_db_name            = jsondecode(data.aws_secretsmanager_secret_version.this[each.key].secret_string).db_name
  source_app_username       = jsondecode(data.aws_secretsmanager_secret_version.this[each.key].secret_string).user
  source_app_password       = each.key == local.nomis ? "${jsondecode(data.aws_secretsmanager_secret_version.this[each.key].secret_string).password},${jsondecode(data.aws_secretsmanager_secret_version.this[each.key].secret_string).asm_password}" : jsondecode(data.aws_secretsmanager_secret_version.this[each.key].secret_string).password
  source_address            = jsondecode(data.aws_secretsmanager_secret_version.this[each.key].secret_string).endpoint
  source_db_port            = tonumber(jsondecode(data.aws_secretsmanager_secret_version.this[each.key].secret_string).port)
  extra_attributes          = lower(each.value["source_engine"]["type"]) == lower("oracle") && (length(regexall(lower(".*useBFile=Y.*"), lower(each.value["source_engine"]["extra_attributes"]))) > 0 || length(regexall(lower(".*useBFile=true.*"), lower(each.value["source_engine"]["extra_attributes"]))) > 0) ? "asm_server=${jsondecode(data.aws_secretsmanager_secret_version.this[each.key].secret_string).asm_server}:${jsondecode(data.aws_secretsmanager_secret_version.this[each.key].secret_string).port}/+ASM;asm_user=${jsondecode(data.aws_secretsmanager_secret_version.this[each.key].secret_string).asm_user};${each.value["source_engine"]["extra_attributes"]}" : each.value["source_engine"]["extra_attributes"]
  bucket_name               = data.aws_s3_bucket.raw.id

  tags = merge(
    local.tags,
    {
      resource-type   = "DMS Endpoint"
      jira            = "main"
      domain          = "Common"
      domain-category = startswith(lower(each.key), "dps") ? "dps" : "nomis"
  })

  source_postgres_heartbeat_enable = try(each.value["source_engine"]["heartbeat_enabled"], false)
}

# DMS Instances
# checkov:skip=CKV_TF_1: Commit hash not enforced for legacy module
module "dms-instance" {
  source = "git::https://github.com/modular-data/datahub-tf-service-modules.git//modules/domains/dms-instance?ref=main"

  for_each = {
    for k, v in var.instances : k => v
    if v.setup
  }

  name                         = "${local.project}-dms-${each.key}"
  project_id                   = local.project   # common
  env                          = var.environment # common
  setup_dms_instance           = each.value.setup
  replication_instance_version = each.value.replication_instance_version
  allow_major_version_upgrade  = var.allow_major_version_upgrade
  replication_instance_class   = each.value.replication_instance_class
  replication_instance_storage = try(each.value.replication_instance_storage, var.replication_instance_storage)
  subnet_ids                   = [data.aws_subnet.data_subnets_a.id, data.aws_subnet.data_subnets_b.id, data.aws_subnet.data_subnets_c.id] #each.value.subnets                   # common
  vpc_cidr                     = [data.aws_vpc.shared.cidr_block]
  vpc                          = data.aws_vpc.shared.id

  dms_log_retention_in_days = var.dms_log_group_retention_in_days

  tags = merge(
    local.tags,
    {
      resource-type   = "DMS Instance"
      jira            = "DWH301"
      name            = "${local.project}-dms-${each.key}"
      domain          = "Common"
      domain-category = "Common"
    }
  )
}

# DMS Task, Specific to Domain (Many Instances)
# checkov:skip=CKV_TF_1: Commit hash not enforced for legacy module
module "dms-task" {
  source = "git::https://github.com/modular-data/datahub-tf-service-modules.git//modules/domains/dms-task?ref=main"

  for_each = {
    for k, v in var.domains : k => v
    if try(v.setup_rep_task, var.setup_rep_task)
  }

  enable_replication_task   = try(each.value.setup_rep_task, var.setup_rep_task)
  name                      = each.value.domain_type == local.nomis ? "${local.project}-dms-${each.value.domain_type}-${var.nomis_source_engine}-s3-${each.key}${try(each.value.split_dms_task, var.split_dms_task) ? "-full-load" : ""}" : "${local.project}-dms-${each.value.domain_type}-${var.dps_source_engine}-s3-${each.key}${try(each.value.split_dms_task, var.split_dms_task) ? "-full-load" : ""}"
  project_id                = local.project   # common
  env                       = var.environment # common
  short_name                = each.value.domain_type
  dms_replication_instance  = module.dms-instance["${each.value.domain_type}-${each.value.replication_instance_suffix}"].dms_replication_instance_arn
  migration_type            = try(each.value.split_dms_task, var.split_dms_task) ? "full-load" : each.value.migration_type
  replication_task_settings = file("${path.module}/${each.value.replication_task_settings}")
  table_mappings            = file("${path.module}/${each.value.table_mappings}")
  rename_rule_source_schema = each.value.rename_source_schema
  rename_rule_output_space  = each.value.rename_output_space
  dms_source_endpoint       = each.value.domain_type == local.nomis ? module.setup-dms-endpoints[each.key == local.clustered_tables ? local.clustered_tables : local.nomis].dms_source_endpoint_arn : module.setup-dms-endpoints[each.key].dms_source_endpoint_arn
  dms_target_endpoint       = each.value.domain_type == local.nomis ? module.setup-dms-endpoints[local.nomis].dms_target_endpoint_arn : module.setup-dms-endpoints[each.key].dms_target_endpoint_arn

  depends_on = [
    module.dms-instance,
    module.setup-dms-endpoints
  ]

  tags = merge(
    local.tags,
    {
      resource-type   = "dms"
      jira            = "main"
      domain          = each.key
      domain-category = each.value.domain_type
    }
  )
}

# DMS Task, Specific to Domain (Many Instances)
# checkov:skip=CKV_TF_1: Commit hash not enforced for legacy module
module "dms-cdc-task" {
  source = "git::https://github.com/modular-data/datahub-tf-service-modules.git//modules/domains/dms-task?ref=main"

  for_each = {
    for k, v in var.domains : k => v
    if try(v.setup_rep_task, var.setup_rep_task) && try(v.split_dms_task, var.split_dms_task)
  }

  enable_replication_task   = try(each.value.setup_rep_task, var.setup_rep_task)
  name                      = each.value.domain_type == local.nomis ? "${local.project}-dms-${each.value.domain_type}-${var.nomis_source_engine}-s3-${each.key}-cdc" : "${local.project}-dms-${each.value.domain_type}-${var.dps_source_engine}-s3-${each.key}-cdc"
  project_id                = local.project   # common
  env                       = var.environment # common
  short_name                = each.value.domain_type
  dms_replication_instance  = module.dms-instance["${each.value.domain_type}-${each.value.replication_instance_suffix}"].dms_replication_instance_arn
  migration_type            = "cdc"
  replication_task_settings = file("${path.module}/${each.value.replication_task_settings}")
  table_mappings            = file("${path.module}/${each.value.table_mappings}")
  rename_rule_source_schema = each.value.rename_source_schema
  rename_rule_output_space  = each.value.rename_output_space
  dms_source_endpoint       = each.value.domain_type == local.nomis ? module.setup-dms-endpoints[local.nomis].dms_source_endpoint_arn : module.setup-dms-endpoints[each.key].dms_source_endpoint_arn
  dms_target_endpoint       = each.value.domain_type == local.nomis ? module.setup-dms-endpoints[local.nomis].dms_target_endpoint_arn : module.setup-dms-endpoints[each.key].dms_target_endpoint_arn

  depends_on = [
    module.dms-instance,
    module.setup-dms-endpoints
  ]

  tags = merge(
    local.tags,
    {
      resource-type   = "dms"
      jira            = "DWH1925"
      domain          = each.key
      domain-category = each.value.domain_type
    }
  )
}

# Setup Lambda/Triggers, Common Resources
# checkov:skip=CKV_TF_1: Commit hash not enforced for legacy module
module "lambda-setup" {
  source                                    = "git::https://github.com/modular-data/datahub-tf-service-modules.git//modules/domains/pipeline-lambda?ref=main"
  setup_step_function_notification_lambda   = var.setup_step_function_notification_lambda
  step_function_notification_lambda         = var.step_function_notification_lambda
  s3_file_transfer_lambda_code_s3_bucket    = var.artifact_s3_bucket
  reporting_lambda_code_s3_key              = var.reporting_lambda_code_s3_key
  step_function_notification_lambda_handler = var.step_function_notification_lambda_handler
  step_function_notification_lambda_runtime = var.step_function_notification_lambda_runtime
  step_function_notification_lambda_policies = [
    local.kms_read_access_policy_arn,
    "arn:aws:iam::${local.account_id}:policy/${local.project}_all_state_machine_policy",
    "arn:aws:iam::${local.account_id}:policy/${local.project}_dynamo_db_access_policy"
  ]
  step_function_notification_lambda_tracing = var.step_function_notification_lambda_tracing
  step_function_notification_lambda_trigger = var.step_function_notification_lambda_trigger
  lambda_subnet_ids                         = [data.aws_subnet.data_subnets_a.id, data.aws_subnet.data_subnets_b.id, data.aws_subnet.data_subnets_c.id]
  lambda_security_group_ids                 = [data.aws_security_group.generic_lambda.id] # Fallback Static, var.lambda_security_group_ids
  lambda_log_retention_in_days              = var.lambda_log_retention_in_days

  depends_on = [
    module.dms-instance,
    module.dms-task
  ]


  tags = merge(
    local.tags,
    {
      resource-type   = "Lambda"
      jira            = "main"
      domain          = "Common"
      domain-category = "Common"
    }
  )
}

# Postgres Tickle Lambda used to ensure the DMS Postgres replication slot on read replicas keeps moving
# checkov:skip=CKV_TF_1: Commit hash not enforced for legacy module
module "postgres-tickle-lambda" {
  source = "git::https://github.com/modular-data/datahub-tf-service-modules.git//modules/domains/postgres-tickle-lambda?ref=main"


  setup_postgres_tickle_lambda = var.setup_postgres_tickle_lambda
  postgres_tickle_lambda_name  = "dataworks-postgres-tickle"
  lambda_code_s3_bucket        = var.artifact_s3_bucket
  lambda_code_s3_key           = var.postgres_tickle_lambda_jar_s3_key
  lambda_log_retention_in_days = var.lambda_log_retention_in_days
  lambda_timeout_in_seconds    = var.postgres_tickle_lambda_timeout_in_seconds
  lambda_subnet_ids            = [data.aws_subnet.data_subnets_a.id, data.aws_subnet.data_subnets_b.id, data.aws_subnet.data_subnets_c.id]
  lambda_security_group_ids    = [data.aws_security_group.generic_lambda.id]
  secret_arns                  = [for s in data.aws_secretsmanager_secret.dps_secret : s.arn]
}

# Shared logging configuration for glue jobs
resource "aws_s3_object" "glue_job_shared_custom_log4j_properties" {
  bucket = data.aws_s3_bucket.glue_jobs.id
  key    = "logging/ingestion-jobs/log4j2.properties"
  source = "files/log4j2.properties"
  etag   = filemd5("files/log4j2.properties")
}
# checkov:skip=CKV_TF_1: Commit hash not enforced for legacy module
module "reconciliation-jobs" {
  source = "git::https://github.com/modular-data/datahub-tf-service-modules.git//modules/domains/reconciliation-job?ref=main"

  for_each = {
    for k, v in var.domains : k => v
    if try(v.setup_reconciliation_job, var.setup_reconciliation_job)
  }

  env                          = var.environment
  account_region               = local.region
  account_id                   = local.account_id
  log_group_retention_in_days  = var.glue_log_group_retention_in_days
  enable_continuous_log_filter = false
  project_id                   = local.project
  s3_kms_arn                   = data.aws_kms_key.default.arn
  execution_class              = "STANDARD"
  job_name                     = "${local.project}-reconciliation-${each.key}-${var.environment}"
  short_name                   = "${local.project}-reconciliation-${each.key}"
  glue_version                 = try(each.value.glue_job_version_override, var.glue_job_version)
  temp_dir                     = "s3://${data.aws_s3_bucket.glue.id}/tmp/${local.project}-reconciliation-${each.key}-${var.environment}/"
  spark_event_logs             = "s3://${data.aws_s3_bucket.glue.id}/spark-logs/${local.project}-reconciliation-${each.key}-${var.environment}/"
  enable_spark_ui              = try(each.value.enable_spark_ui_override, var.enable_spark_ui)

  create_job          = try(each.value.setup_reconciliation_job, var.setup_reconciliation_job)
  create_sec_conf     = try(each.value.glue_reconciliation_job_create_sec_conf_override, var.glue_reconciliation_job_create_sec_conf)
  create_role         = try(each.value.create_reconciliation_job_role, var.create_reconciliation_job_role)
  script_file_version = try(each.value.script_version_override, var.script_version)
  worker_type         = try(each.value.glue_reconciliation_job_worker_type_override, var.glue_reconciliation_job_worker_type)
  num_workers         = try(each.value.glue_reconciliation_job_num_workers_override, var.glue_reconciliation_job_num_workers)
  max_concurrent_runs = try(each.value.glue_reconciliation_job_max_concurrent_override, var.glue_reconciliation_job_max_concurrent)
  job_schedule        = try(each.value.glue_reconciliation_job_schedule_override, var.glue_reconciliation_job_schedule)

  connections = contains([local.nomis, local.clustered_tables], each.value.domain_type) ? [
    data.aws_glue_connection.glue_operational_datastore_connection.name,
    data.aws_glue_connection.glue_nomis_connection.name
    ] : [
    data.aws_glue_connection.glue_operational_datastore_connection.name,
    data.aws_glue_connection.glue_dps_connection[each.key].name
  ]

  additional_secret_arns = contains([local.nomis, local.clustered_tables], each.value.domain_type) ? [
    data.aws_secretsmanager_secret.operational_db_secret.arn,
    data.aws_secretsmanager_secret.nomis_secret.arn
    ] : (local.is_dev_or_test ? [
      data.aws_secretsmanager_secret.operational_db_secret.arn,
      data.aws_secretsmanager_secret.dps_secret[each.key].arn,
      # The dpr test DB is only available in dev and test environments
      data.aws_secretsmanager_secret.dpr_secret[0].arn
      ] : [
      data.aws_secretsmanager_secret.operational_db_secret.arn,
      data.aws_secretsmanager_secret.dps_secret[each.key].arn
  ])

  tags = merge(
    local.tags,
    {
      name            = "${local.project}-data-reconciliation-${var.environment}"
      jira            = "DWH1117"
      resource-type   = "Glue Job"
      domain          = each.key
      domain-category = each.value.domain_type
    }
  )

  glue_job_arguments = merge(local.glue_datahub_job_extra_ods_args, {
    "--extra-jars"                                                          = try("s3://${data.aws_s3_bucket.artifact-store.id}/build-artifacts/digital-prison-reporting-jobs/jars/${each.value.jar_version_override}", "s3://${data.aws_s3_bucket.artifact-store.id}/build-artifacts/digital-prison-reporting-jobs/jars/${var.jar_version}")
    "--dataworks.log.level"                                                       = try(each.value.glue_reconciliation_job_log_level, var.glue_reconciliation_job_log_level)
    "--extra-files"                                                         = "s3://${aws_s3_object.glue_job_shared_custom_log4j_properties.bucket}/${aws_s3_object.glue_job_shared_custom_log4j_properties.key}"
    "--class"                                                               = "uk.gov.justice.digital.job.DataReconciliationJob"
    "--dataworks.aws.region"                                                      = local.region
    "--dataworks.config.s3.bucket"                                                = data.aws_s3_bucket.glue.id
    "--dataworks.raw.s3.path"                                                     = "s3://${data.aws_s3_bucket.raw.id}/"
    "--dataworks.structured.s3.path"                                              = "s3://${data.aws_s3_bucket.structured.id}/"
    "--dataworks.curated.s3.path"                                                 = "s3://${data.aws_s3_bucket.curated.id}/"
    "--dataworks.raw.archive.s3.path"                                             = "s3://${data.aws_s3_bucket.raw_archive.id}/"
    "--dataworks.contract.registryName"                                           = "${local.project}-schema-registry-${var.environment}"
    "--dataworks.reconciliation.checks.to.run"                                    = "current_state_counts,change_data_counts"
    "--dataworks.config.key"                                                      = each.key
    "--dataworks.dms.replication.task.id"                                         = module.dms-task[each.key].replication_task_id
    "--dataworks.reconciliation.datasource.source.schema.name"                    = each.value.domain_type == local.nomis ? "OMS_OWNER" : "public"
    "--dataworks.reconciliation.datasource.should.uppercase.tablenames"           = each.value.domain_type == local.nomis ? "true" : "false"
    "--dataworks.reconciliation.datasource.glue.connection.name"                  = each.value.domain_type == local.nomis ? data.aws_glue_connection.glue_nomis_connection.name : data.aws_glue_connection.glue_dps_connection[each.key].name
    "--dataworks.reconciliation.fail.job.if.checks.fail"                          = "false"
    "--dataworks.reconciliation.report.results.to.cloudwatch"                     = "true"
    "--dataworks.reconciliation.cloudwatch.metrics.namespace"                     = var.glue_reconciliation_job_metrics_namespace
    "--dataworks.reconciliation.changedatacounts.tolerance.relative.percentage"   = try(each.value.glue_reconciliation_job_changedatacounts_tolerance_relative_percentage, var.glue_reconciliation_job_changedatacounts_tolerance_relative_percentage)
    "--dataworks.reconciliation.changedatacounts.tolerance.absolute"              = try(each.value.glue_reconciliation_job_changedatacounts_tolerance_absolute, var.glue_reconciliation_job_changedatacounts_tolerance_absolute)
    "--dataworks.reconciliation.currentstatecounts.tolerance.relative.percentage" = try(each.value.glue_reconciliation_job_currentstatecounts_tolerance_relative_percentage, var.glue_reconciliation_job_currentstatecounts_tolerance_relative_percentage)
    "--dataworks.reconciliation.currentstatecounts.tolerance.absolute"            = try(each.value.glue_reconciliation_job_currentstatecounts_tolerance_absolute, var.glue_reconciliation_job_currentstatecounts_tolerance_absolute)
  })
}

#Ingestion Jobs, Specific to Domain (Many Instances)
# checkov:skip=CKV_TF_1: Commit hash not enforced for legacy module
module "ingestion-jobs" {
  for_each = {
    for k, v in var.domains : k => v
    if try(v.setup_ingestion_jobs, var.setup_ingestion_jobs)
  }

  # Common
  batch_only      = try(each.value.batch_only, var.batch_only)
  script_version  = try(each.value.script_version_override, var.script_version)
  jar_version     = try(each.value.jar_version_override, var.jar_version)
  account_region  = local.region
  account_id      = local.account_id
  project_id      = local.project   # common
  env             = var.environment # common
  s3_kms_arn      = data.aws_kms_key.default.arn
  enable_spark_ui = try(each.value.enable_spark_ui_override, var.enable_spark_ui) # Common for all Jobs

  glue_log_group_retention_in_days = var.glue_log_group_retention_in_days
  source                           = "git::https://github.com/modular-data/datahub-tf-service-modules.git//modules/domains/ingestion-jobs?ref=main"

  # CDC
  setup_cdc_job                       = each.value.setup_cdc_job
  glue_cdc_create_role                = each.value.glue_cdc_create_role
  glue_cdc_job_name                   = "${local.project}-cdc-${each.key}-${var.environment}"
  glue_cdc_job_short_name             = "${local.project}-cdc-${each.key}"
  glue_cdc_job_glue_version           = try(each.value.glue_job_version_override, var.glue_job_version)
  glue_cdc_description                = "(Domain, ${each.key}): Monitors the reporting hub for table changes and applies them to structured and curated zones"
  glue_cdc_create_sec_conf            = each.value.glue_cdc_create_sec_conf
  glue_cdc_language                   = "scala"
  glue_cdc_checkpoint_dir             = "s3://${data.aws_s3_bucket.glue.id}/checkpoint/${local.project}-cdc-${each.key}-${var.environment}/"
  glue_cdc_temp_dir                   = "s3://${data.aws_s3_bucket.glue.id}/tmp/${local.project}-cdc-${each.key}-${var.environment}/"
  glue_cdc_spark_event_logs           = "s3://${data.aws_s3_bucket.glue.id}/spark-logs/${local.project}-cdc-${each.key}-${var.environment}/"
  glue_cdc_enable_cont_log_filter     = false
  glue_cdc_execution_class            = "STANDARD"
  glue_cdc_additional_policies        = null
  glue_cdc_job_worker_type            = try(each.value.glue_cdc_job_worker_type_override, var.glue_cdc_job_worker_type)
  glue_cdc_job_num_workers            = try(each.value.glue_cdc_job_num_workers_override, var.glue_cdc_job_num_workers)
  glue_cdc_max_concurrent             = var.glue_cdc_max_concurrent
  glue_cdc_maintenance_window         = var.glue_cdc_maintenance_window
  glue_cdc_job_connections            = [data.aws_glue_connection.glue_operational_datastore_connection.name]
  glue_cdc_job_additional_secret_arns = [data.aws_secretsmanager_secret.operational_db_secret.arn]

  glue_cdc_arguments = merge(local.glue_datahub_job_extra_ods_args, {
    "--extra-jars"                                = try("s3://${data.aws_s3_bucket.artifact-store.id}/build-artifacts/digital-prison-reporting-jobs/jars/${each.value.jar_version_override}", "s3://${data.aws_s3_bucket.artifact-store.id}/build-artifacts/digital-prison-reporting-jobs/jars/${var.jar_version}")
    "--extra-files"                               = "s3://${aws_s3_object.glue_job_shared_custom_log4j_properties.bucket}/${aws_s3_object.glue_job_shared_custom_log4j_properties.key}"
    "--job-bookmark-option"                       = "job-bookmark-disable"
    "--class"                                     = "uk.gov.justice.digital.job.DataHubCdcJob"
    "--datalake-formats"                          = "delta"
    "--dataworks.aws.region"                            = local.region
    "--dataworks.raw.archive.s3.path"                   = "s3://${data.aws_s3_bucket.raw_archive.id}/"
    "--dataworks.raw.s3.path"                           = "s3://${data.aws_s3_bucket.raw.id}/"
    "--dataworks.structured.s3.path"                    = "s3://${data.aws_s3_bucket.structured.id}/"
    "--dataworks.violations.s3.path"                    = "s3://${data.aws_s3_bucket.violations.id}/"
    "--dataworks.curated.s3.path"                       = "s3://${data.aws_s3_bucket.curated.id}/"
    "--dataworks.datastorage.retry.maxAttempts"         = tostring(var.glue_cdc_job_retry_max_attempts)
    "--dataworks.datastorage.retry.minWaitMillis"       = tostring(var.glue_cdc_job_retry_min_wait_millis)
    "--dataworks.datastorage.retry.maxWaitMillis"       = tostring(var.glue_cdc_job_retry_max_wait_millis)
    "--dataworks.spark.broadcast.timeout.seconds"       = try(each.value.glue_cdc_job_spark_broadcast_timeout_seconds, var.glue_cdc_job_spark_broadcast_timeout_seconds)
    "--dataworks.disable.auto.broadcast.join.threshold" = try(each.value.glue_cdc_job_disable_auto_broadcast_join_threshold, var.glue_cdc_job_disable_auto_broadcast_join_threshold)
    "--dataworks.streaming.job.max.files.per.trigger"   = try(each.value.glue_cdc_job_max_files_per_trigger, var.glue_cdc_job_max_files_per_trigger)
    "--dataworks.spark.sql.maxrecordsperfile"           = try(each.value.glue_cdc_job_max_records_per_file, var.glue_cdc_job_max_records_per_file)
    "--enable-metrics"                            = true
    "--enable-auto-scaling"                       = true
    "--enable-job-insights"                       = true
    "--dataworks.contract.registryName"                 = "${local.project}-schema-registry-${var.environment}"
    "--dataworks.config.s3.bucket"                      = data.aws_s3_bucket.glue.id
    "--dataworks.domain.registry"                       = "${local.project}-domain-registry-${var.environment}"
    "--dataworks.schema.cache.max.size"                 = var.glue_cdc_max_cache_size
    "--dataworks.schema.cache.expiry.minutes"           = var.glue_cdc_cache_expiry_minutes
    "--dataworks.log.level"                             = var.glue_cdc_job_log_level
    "--dataworks.config.s3.bucket"                      = data.aws_s3_bucket.glue.id
    "--dataworks.config.key"                            = each.key
  })

  # BATCH
  setup_batch_job                       = each.value.setup_batch_job
  glue_batch_create_role                = each.value.glue_batch_create_role
  glue_batch_job_name                   = "${local.project}-batch-${each.key}-${var.environment}"
  glue_batch_job_short_name             = "${local.project}-batch-${each.key}"
  glue_batch_job_glue_version           = try(each.value.glue_job_version_override, var.glue_job_version)
  glue_batch_description                = "Domain, ${each.key}: Applies initial batch load inserts from reporting hub to structured and curated zones"
  glue_batch_create_sec_conf            = each.value.glue_batch_create_sec_conf
  glue_batch_language                   = "scala"
  glue_batch_temp_dir                   = "s3://${data.aws_s3_bucket.glue.id}/tmp/${local.project}-batch-${each.key}-${var.environment}/"
  glue_batch_spark_event_logs           = "s3://${data.aws_s3_bucket.glue.id}/spark-logs/${local.project}-batch-${each.key}-${var.environment}/"
  glue_batch_enable_cont_log_filter     = false
  glue_batch_execution_class            = "STANDARD"
  glue_batch_job_worker_type            = try(each.value.glue_batch_job_worker_type_override, var.glue_batch_job_worker_type)
  glue_batch_job_num_workers            = try(each.value.glue_batch_job_num_workers_override, var.glue_batch_job_num_workers)
  glue_batch_max_concurrent             = var.glue_batch_max_concurrent
  glue_batch_additional_policies        = module.setup-dms-endpoints[local.nomis].dms_s3_iam_policy_admin_arn
  glue_batch_job_connections            = [data.aws_glue_connection.glue_operational_datastore_connection.name]
  glue_batch_job_additional_secret_arns = [data.aws_secretsmanager_secret.operational_db_secret.arn]

  glue_batch_arguments = merge(local.glue_datahub_job_extra_ods_args, {
    "--extra-jars"                          = try("s3://${data.aws_s3_bucket.artifact-store.id}/build-artifacts/digital-prison-reporting-jobs/jars/${each.value.jar_version_override}", "s3://${data.aws_s3_bucket.artifact-store.id}/build-artifacts/digital-prison-reporting-jobs/jars/${var.jar_version}")
    "--extra-files"                         = "s3://${aws_s3_object.glue_job_shared_custom_log4j_properties.bucket}/${aws_s3_object.glue_job_shared_custom_log4j_properties.key}"
    "--class"                               = "uk.gov.justice.digital.job.DataHubBatchJob"
    "--datalake-formats"                    = "delta"
    "--dataworks.aws.region"                      = local.region
    "--dataworks.raw.s3.path"                     = "s3://${data.aws_s3_bucket.raw.id}/"
    "--dataworks.structured.s3.path"              = "s3://${data.aws_s3_bucket.structured.id}/"
    "--dataworks.violations.s3.path"              = "s3://${data.aws_s3_bucket.violations.id}/"
    "--dataworks.curated.s3.path"                 = "s3://${data.aws_s3_bucket.curated.id}/"
    "--dataworks.contract.registryName"           = "${local.project}-schema-registry-${var.environment}"
    "--dataworks.datastorage.retry.maxAttempts"   = tostring(var.glue_batch_job_retry_max_attempts)
    "--dataworks.datastorage.retry.minWaitMillis" = tostring(var.glue_batch_job_retry_min_wait_millis)
    "--dataworks.datastorage.retry.maxWaitMillis" = tostring(var.glue_batch_job_retry_max_wait_millis)
    "--dataworks.log.level"                       = var.glue_batch_job_log_level
    "--dataworks.config.s3.bucket"                = data.aws_s3_bucket.glue.id
    "--dataworks.config.key"                      = each.key
  })

  # Archive
  setup_archive_job                   = each.value.setup_archive_job
  glue_archive_create_role            = each.value.glue_archive_create_role
  glue_archive_job_name               = "${local.project}-archive-${each.key}-${var.environment}"
  glue_archive_job_short_name         = "${local.project}-archive-${each.key}"
  glue_archive_job_glue_version       = try(each.value.glue_job_version_override, var.glue_job_version)
  glue_archive_description            = "Domain, ${each.key}: Archives processed raw files"
  glue_archive_create_sec_conf        = each.value.glue_archive_create_sec_conf
  glue_archive_language               = "scala"
  glue_archive_temp_dir               = "s3://${data.aws_s3_bucket.glue.id}/tmp/${local.project}-archive-${each.key}-${var.environment}/"
  glue_archive_spark_event_logs       = "s3://${data.aws_s3_bucket.glue.id}/spark-logs/${local.project}-archive-${each.key}-${var.environment}/"
  glue_archive_enable_cont_log_filter = false
  glue_archive_execution_class        = "STANDARD"
  glue_archive_job_worker_type        = var.glue_archive_job_worker_type
  glue_archive_job_num_workers        = var.glue_archive_job_num_workers
  glue_archive_max_concurrent         = var.glue_archive_max_concurrent
  glue_archive_additional_policies    = module.setup-dms-endpoints[local.nomis].dms_s3_iam_policy_admin_arn

  glue_archive_arguments = {
    "--extra-jars"                                = try("s3://${data.aws_s3_bucket.artifact-store.id}/build-artifacts/digital-prison-reporting-jobs/jars/${each.value.jar_version_override}", "s3://${data.aws_s3_bucket.artifact-store.id}/build-artifacts/digital-prison-reporting-jobs/jars/${var.jar_version}")
    "--extra-files"                               = "s3://${aws_s3_object.glue_job_shared_custom_log4j_properties.bucket}/${aws_s3_object.glue_job_shared_custom_log4j_properties.key}"
    "--class"                                     = "uk.gov.justice.digital.job.RawFileArchiveJob"
    "--datalake-formats"                          = "delta"
    "--dataworks.aws.region"                            = local.region
    "--dataworks.file.transfer.source.bucket"           = data.aws_s3_bucket.raw.id
    "--dataworks.file.transfer.destination.bucket"      = data.aws_s3_bucket.raw_archive.id
    "--dataworks.datastorage.retry.maxAttempts"         = tostring(var.glue_s3_max_attempts)
    "--dataworks.datastorage.retry.minWaitMillis"       = tostring(var.glue_s3_retry_min_wait_millis)
    "--dataworks.datastorage.retry.maxWaitMillis"       = tostring(var.glue_s3_retry_max_wait_millis)
    "--dataworks.raw.file.retention.period.amount"      = tostring(var.glue_raw_file_retention_amount)
    "--dataworks.raw.file.retention.period.unit"        = var.glue_raw_file_retention_unit
    "--dataworks.file.transfer.use.default.parallelism" = tostring(try(each.value.file_transfer_use_default_parallelism, var.file_transfer_use_default_parallelism))
    "--dataworks.file.transfer.parallelism"             = tostring(try(each.value.file_transfer_parallelism, var.file_transfer_parallelism))
    "--dataworks.jobs.s3.bucket"                        = data.aws_s3_bucket.glue.id
    "--checkpoint.location"                       = "s3://${data.aws_s3_bucket.glue.id}/checkpoint/${local.project}-cdc-${each.key}-${var.environment}/"
    "--dataworks.log.level"                             = var.glue_archive_job_log_level
    "--dataworks.config.s3.bucket"                      = data.aws_s3_bucket.glue.id
    "--dataworks.config.key"                            = each.key
  }

  # Unprocessed Raw Files Check
  setup_unprocessed_raw_files_check_job                   = each.value.setup_unprocessed_raw_files_check_job
  glue_unprocessed_raw_files_check_create_role            = each.value.glue_unprocessed_raw_files_check_create_role
  glue_unprocessed_raw_files_check_job_name               = "pending-files-check-${each.key}-${var.environment}"
  glue_unprocessed_raw_files_check_job_short_name         = "pending-files-check-${each.key}"
  glue_unprocessed_raw_files_check_job_glue_version       = try(each.value.glue_job_version_override, var.glue_job_version)
  glue_unprocessed_raw_files_check_description            = "Domain, ${each.key}: Check that all raw files have been processed"
  glue_unprocessed_raw_files_check_create_sec_conf        = each.value.glue_unprocessed_raw_files_check_create_sec_conf
  glue_unprocessed_raw_files_check_language               = "scala"
  glue_unprocessed_raw_files_check_temp_dir               = "s3://${data.aws_s3_bucket.glue.id}/tmp/pending-files-check-${each.key}-${var.environment}/"
  glue_unprocessed_raw_files_check_spark_event_logs       = "s3://${data.aws_s3_bucket.glue.id}/spark-logs/pending-files-check-${each.key}-${var.environment}/"
  glue_unprocessed_raw_files_check_enable_cont_log_filter = false
  glue_unprocessed_raw_files_check_execution_class        = "STANDARD"
  glue_unprocessed_raw_files_check_job_worker_type        = var.glue_unprocessed_raw_files_check_job_worker_type
  glue_unprocessed_raw_files_check_job_num_workers        = var.glue_unprocessed_raw_files_check_job_num_workers
  glue_unprocessed_raw_files_check_max_concurrent         = var.glue_unprocessed_raw_files_check_max_concurrent
  glue_unprocessed_raw_files_check_additional_policies    = module.setup-dms-endpoints[local.nomis].dms_s3_iam_policy_admin_arn

  glue_unprocessed_raw_files_check_arguments = {
    "--extra-jars"                          = try("s3://${data.aws_s3_bucket.artifact-store.id}/build-artifacts/digital-prison-reporting-jobs/jars/${each.value.jar_version_override}", "s3://${data.aws_s3_bucket.artifact-store.id}/build-artifacts/digital-prison-reporting-jobs/jars/${var.jar_version}")
    "--extra-files"                         = "s3://${aws_s3_object.glue_job_shared_custom_log4j_properties.bucket}/${aws_s3_object.glue_job_shared_custom_log4j_properties.key}"
    "--class"                               = "uk.gov.justice.digital.job.UnprocessedRawFilesCheckJob"
    "--checkpoint.location"                 = "s3://${data.aws_s3_bucket.glue.id}/checkpoint/${local.project}-cdc-${each.key}-${var.environment}/"
    "--dataworks.config.s3.bucket"                = data.aws_s3_bucket.glue.id,
    "--dataworks.file.transfer.source.bucket"     = data.aws_s3_bucket.raw.id
    "--dataworks.datastorage.retry.maxAttempts"   = tostring(var.glue_s3_max_attempts)
    "--dataworks.datastorage.retry.minWaitMillis" = tostring(var.glue_s3_retry_min_wait_millis)
    "--dataworks.datastorage.retry.maxWaitMillis" = tostring(var.glue_s3_retry_max_wait_millis)
    "--dataworks.aws.region"                      = local.region
    "--dataworks.log.level"                       = var.glue_unprocessed_raw_files_check_job_log_level
    "--dataworks.config.key"                      = each.key
  }

  # Create Archive Backfill Job
  setup_archive_backfill_job                       = try(each.value.enable_archive_backfill, var.enable_archive_backfill)
  glue_archive_backfill_job_role                   = try(each.value.enable_archive_backfill, var.enable_archive_backfill)
  glue_archive_backfill_job_name                   = "${local.project}-archive-backfill-${each.key}-${var.environment}"
  glue_archive_backfill_job_short_name             = "${local.project}-archive-backfill-${each.key}"
  glue_archive_backfill_job_glue_version           = try(each.value.glue_job_version_override, var.glue_job_version)
  glue_archive_backfill_job_description            = "Creates a copy of the archive data retroactively processed to ensure data consistency without compromising integrity.\nArguments:\n--dataworks.raw.archive.s3.path: (Required) Path to the raw archive bucket\n--dataworks.temp.reload.s3.path: (Required) Bucket where the backfilled archive will be written to\n--dataworks.temp.reload.output.folder: (Required) Folder within the temp reload bucket where the back-filled archive will be written to\n--dataworks.config.s3.bucket: (Required) Bucket in which the configs are located\n--dataworks.config.key: (Required) The configuration value e.g prisoner\n--dataworks.contract.registryName: (Required) Bucket containing the schema contracts\n--dataworks.batch.load.fileglobpattern: (Required) The file glob pattern to use"
  glue_archive_backfill_job_create_sec_conf        = try(each.value.enable_archive_backfill, var.enable_archive_backfill)
  glue_archive_backfill_job_language               = "scala"
  glue_archive_backfill_job_temp_dir               = "s3://${data.aws_s3_bucket.glue.id}/tmp/archive-backfill-${each.key}-${var.environment}/"
  glue_archive_backfill_job_spark_event_logs       = "s3://${data.aws_s3_bucket.glue.id}/spark-logs/archive-backfill-${each.key}-${var.environment}/"
  glue_archive_backfill_job_enable_cont_log_filter = false
  glue_archive_backfill_job_execution_class        = "STANDARD"
  glue_archive_backfill_job_worker_type            = try(each.value.glue_archive_backfill_job_worker_type, var.glue_archive_backfill_job_worker_type)
  glue_archive_backfill_job_num_workers            = try(each.value.glue_archive_backfill_job_num_workers, var.glue_archive_backfill_job_num_workers)
  glue_archive_backfill_job_max_concurrent         = var.glue_archive_backfill_job_max_concurrent
  glue_archive_backfill_job_additional_policies    = module.setup-dms-endpoints[local.nomis].dms_s3_iam_policy_admin_arn

  glue_archive_backfill_job_arguments = {
    "--extra-jars"                     = try("s3://${data.aws_s3_bucket.artifact-store.id}/build-artifacts/digital-prison-reporting-jobs/jars/${each.value.jar_version_override}", "s3://${data.aws_s3_bucket.artifact-store.id}/build-artifacts/digital-prison-reporting-jobs/jars/${var.jar_version}")
    "--extra-files"                    = "s3://${aws_s3_object.glue_job_shared_custom_log4j_properties.bucket}/${aws_s3_object.glue_job_shared_custom_log4j_properties.key}"
    "--class"                          = "uk.gov.justice.digital.job.ArchiveBackfillJob"
    "--dataworks.raw.archive.s3.path"        = "s3://${data.aws_s3_bucket.raw_archive.id}/",
    "--dataworks.temp.reload.s3.path"        = "s3://${data.aws_s3_bucket.temp_reload.id}/",
    "--dataworks.config.s3.bucket"           = data.aws_s3_bucket.glue.id
    "--dataworks.config.key"                 = each.key
    "--dataworks.contract.registryName"      = "${local.project}-schema-registry-${var.environment}"
    "--dataworks.batch.load.fileglobpattern" = "*.parquet"
    "--dataworks.temp.reload.output.folder"  = "backfilled-archive",
    "--dataworks.aws.region"                 = local.region
    "--dataworks.log.level"                  = var.glue_archive_backfill_job_log_level
  }

  # Create Reload Diff Job
  setup_create_reload_diff_job                       = each.value.setup_create_reload_diff_job
  glue_create_reload_diff_job_role                   = each.value.glue_create_reload_diff_job_role
  glue_create_reload_diff_job_name                   = "${local.project}-create-reload-diff-${each.key}-${var.environment}"
  glue_create_reload_diff_job_short_name             = "${local.project}-create-reload-diff-${each.key}"
  glue_create_reload_diff_job_glue_version           = try(each.value.glue_job_version_override, var.glue_job_version)
  glue_create_reload_diff_job_description            = "Creates a Diff Between The Reload and Archive Data.\nArguments:\n--dataworks.raw.s3.path: (Required) Path to the raw bucket\n--dataworks.raw.archive.s3.path: (Required) Path to the raw archive bucket\n--dataworks.temp.reload.s3.path: (Required) Bucket where the diffs will be written to\n--dataworks.temp.reload.output.folder: (Required) Folder within the temp reload bucket where the diffs will be written to\n--dataworks.config.s3.bucket: (Required) Bucket in which the configs are located\n--dataworks.config.key: (Required) The configuration value e.g prisoner\n--dataworks.contract.registryName: (Required) Bucket containing the schema contracts\n--dataworks.batch.load.fileglobpattern: (Required) The file glob pattern to use"
  glue_create_reload_diff_job_create_sec_conf        = each.value.glue_create_reload_diff_job_create_sec_conf
  glue_create_reload_diff_job_language               = "scala"
  glue_create_reload_diff_job_temp_dir               = "s3://${data.aws_s3_bucket.glue.id}/tmp/create-reload-diff-${each.key}-${var.environment}/"
  glue_create_reload_diff_job_spark_event_logs       = "s3://${data.aws_s3_bucket.glue.id}/spark-logs/create-reload-diff-${each.key}-${var.environment}/"
  glue_create_reload_diff_job_enable_cont_log_filter = false
  glue_create_reload_diff_job_execution_class        = "STANDARD"
  glue_create_reload_diff_job_worker_type            = try(each.value.glue_create_reload_diff_job_worker_type, var.glue_create_reload_diff_job_worker_type)
  glue_create_reload_diff_job_num_workers            = try(each.value.glue_create_reload_diff_job_num_workers_override, var.glue_create_reload_diff_job_num_workers)
  glue_create_reload_diff_job_max_concurrent         = var.glue_create_reload_diff_job_max_concurrent
  glue_create_reload_diff_job_additional_policies    = module.setup-dms-endpoints[local.nomis].dms_s3_iam_policy_admin_arn

  glue_create_reload_diff_job_arguments = {
    "--extra-jars"                     = try("s3://${data.aws_s3_bucket.artifact-store.id}/build-artifacts/digital-prison-reporting-jobs/jars/${each.value.jar_version_override}", "s3://${data.aws_s3_bucket.artifact-store.id}/build-artifacts/digital-prison-reporting-jobs/jars/${var.jar_version}")
    "--extra-files"                    = "s3://${aws_s3_object.glue_job_shared_custom_log4j_properties.bucket}/${aws_s3_object.glue_job_shared_custom_log4j_properties.key}"
    "--class"                          = "uk.gov.justice.digital.job.CreateReloadDiffJob"
    "--dataworks.raw.s3.path"                = "s3://${data.aws_s3_bucket.raw.id}/",
    "--dataworks.raw.archive.s3.path"        = "s3://${data.aws_s3_bucket.raw_archive.id}/",
    "--dataworks.temp.reload.s3.path"        = "s3://${data.aws_s3_bucket.temp_reload.id}/",
    "--dataworks.config.s3.bucket"           = data.aws_s3_bucket.glue.id
    "--dataworks.config.key"                 = each.key
    "--dataworks.contract.registryName"      = "${local.project}-schema-registry-${var.environment}"
    "--dataworks.batch.load.fileglobpattern" = "*.parquet"
    "--dataworks.temp.reload.output.folder"  = "diffs",
    "--dataworks.dms.replication.task.id"    = each.value.setup_create_reload_diff_job ? try(module.dms-task[each.key].replication_task_id, null) : null
    "--dataworks.reload.checkpoint.use.now"  = try(each.value.reload_diff_job_checkpoint_use_now_timestamp, false)
    "--dataworks.aws.region"                 = local.region
    "--dataworks.log.level"                  = var.glue_create_reload_diff_job_log_level
  }

  tags = merge(
    local.tags,
    {
      resource-type   = "Glue Job"
      jira            = "main"
      domain          = each.key
      domain-category = each.value.domain_type
    }
  )


  depends_on = [
    module.lambda-setup,
    module.dms-task
  ]
}

#Ingestion Pipeline, Specific to Domain (Many Instances)
# checkov:skip=CKV_TF_1: Commit hash not enforced for legacy module
module "ingestion-pipeline" {
  source = "git::https://github.com/modular-data/datahub-tf-service-modules.git//modules/domains/ingestion-pipeline?ref=main"

  for_each = {
    for k, v in var.domains : k => v
    if try(v.setup_ingestion_pipeline, var.setup_ingestion_pipeline)
  }

  batch_only                                   = try(each.value.batch_only, var.batch_only)
  file_transfer_in                             = each.value.domain_type == "file-transfer-in"
  split_pipeline                               = try(each.value.split_dms_task, var.split_dms_task)
  setup_data_ingestion_pipeline                = try(each.value.setup_ingestion_pipeline, var.setup_ingestion_pipeline)
  data_ingestion_pipeline                      = "${local.project}-ingestion-pipeline${try(each.value.batch_only, var.batch_only) ? "-batch" : ""}-${each.value.domain_type}-${each.key}-${var.environment}"
  domain                                       = each.key
  domain_s3_prefix                             = each.value.rename_output_space
  dms_replication_task_arn                     = try(module.dms-task[each.key].dms_replication_task_arn, null)
  dms_cdc_replication_task_arn                 = try(each.value.split_dms_task, var.split_dms_task) ? try(module.dms-cdc-task[each.key].dms_replication_task_arn, null) : null
  replication_task_id                          = try(module.dms-task[each.key].replication_task_id, null)
  cdc_replication_task_id                      = try(each.value.split_dms_task, var.split_dms_task) ? try(module.dms-cdc-task[each.key].replication_task_id, null) : null
  glue_reporting_hub_batch_jobname             = "${local.project}-batch-${each.key}-${var.environment}"
  glue_hive_table_creation_jobname             = "${local.project}-hive-table-creation-${var.environment}"
  glue_reporting_hub_cdc_jobname               = "${local.project}-cdc-${each.key}-${var.environment}"
  glue_stop_glue_instance_job                  = "${local.project}-stop-glue-instance-job-${var.environment}"
  stop_dms_task_job                            = "${local.project}-stop-dms-task-job-${var.environment}"
  set_cdc_dms_start_time_job                   = try(each.value.split_dms_task, var.split_dms_task) ? "${local.project}-set-cdc-dms-start-time-job-${var.environment}" : null
  glue_trigger_activation_job                  = "${local.project}-activate-glue-trigger-job-${var.environment}"
  archive_job_trigger_name                     = "${local.project}-archive-${each.key}-${var.environment}-trigger"
  glue_archive_job                             = "${local.project}-archive-${each.key}-${var.environment}"
  glue_reconciliation_job                      = "${local.project}-reconciliation-${each.key}-${var.environment}"
  s3_landing_bucket_id                         = data.aws_s3_bucket.landing.id
  s3_landing_processing_bucket_id              = data.aws_s3_bucket.landing_processing.id
  s3_raw_bucket_id                             = data.aws_s3_bucket.raw.id
  s3_raw_archive_bucket_id                     = data.aws_s3_bucket.raw_archive.id
  s3_structured_bucket_id                      = data.aws_s3_bucket.structured.id
  s3_curated_bucket_id                         = data.aws_s3_bucket.curated.id
  s3_temp_reload_bucket_id                     = data.aws_s3_bucket.temp_reload.id
  s3_glue_bucket_id                            = data.aws_s3_bucket.glue.id
  s3_structured_path                           = "s3://${data.aws_s3_bucket.structured.id}/${each.value.rename_output_space}/"
  s3_curated_path                              = "s3://${data.aws_s3_bucket.curated.id}/${each.value.rename_output_space}/"
  file_transfer_parallelism                    = try(each.value.file_transfer_parallelism, var.file_transfer_parallelism)
  file_transfer_use_default_parallelism        = try(each.value.file_transfer_use_default_parallelism, var.file_transfer_use_default_parallelism)
  glue_s3_file_transfer_job                    = "${local.project}-s3-file-transfer-job-${var.environment}"
  glue_s3_data_deletion_job                    = "${local.project}-s3-data-deletion-job-${var.environment}"
  glue_switch_prisons_hive_data_location_job   = "${local.project}-switch-prisons-data-source-${var.environment}"
  glue_maintenance_retention_job               = "${local.project}-maintenance-retention-${var.environment}"
  glue_maintenance_compaction_job              = "${local.project}-maintenance-compaction-${var.environment}"
  pipeline_notification_lambda_function        = "${var.step_function_notification_lambda}-function"
  landing_zone_antivirus_check_lambda_function = var.setup_file_transfer_in_lambdas ? module.landing_zone_antivirus_check_lambda.lambda_name : ""
  landing_zone_processing_lambda_function      = var.setup_file_transfer_in_lambdas ? module.landing_zone_processing_lambda.lambda_name : ""


  landing_zone_antivirus_check_lambda_timeout_in_seconds   = var.landing_zone_antivirus_check_lambda_timeout_in_seconds
  landing_zone_processing_lambda_timeout_in_seconds        = var.landing_zone_processing_lambda_timeout_in_seconds
  pipeline_notification_lambda_function_ignore_dms_failure = try(each.value.split_dms_task, var.split_dms_task) ? try(each.value.pipeline_notification_lambda_function_ignore_dms_failure, false) : false

  compaction_structured_num_workers = try(each.value.ingestion_compaction_structured_num_workers, var.compaction_structured_num_workers)
  compaction_structured_worker_type = try(each.value.ingestion_compaction_structured_worker_type, var.compaction_structured_worker_type)
  compaction_curated_num_workers    = try(each.value.ingestion_compaction_curated_num_workers, var.compaction_curated_num_workers)
  compaction_curated_worker_type    = try(each.value.ingestion_compaction_curated_worker_type, var.compaction_curated_worker_type)

  retention_structured_num_workers = try(each.value.ingestion_retention_structured_num_workers, var.retention_structured_num_workers)
  retention_structured_worker_type = try(each.value.ingestion_retention_structured_worker_type, var.retention_structured_worker_type)
  retention_curated_num_workers    = try(each.value.ingestion_retention_curated_num_workers, var.retention_curated_num_workers)
  retention_curated_worker_type    = try(each.value.ingestion_retention_curated_worker_type, var.retention_curated_worker_type)

  glue_s3_max_attempts          = try(each.value.glue_s3_max_attempts, var.glue_s3_max_attempts)
  glue_s3_retry_min_wait_millis = try(each.value.glue_s3_retry_min_wait_millis, var.glue_s3_retry_min_wait_millis)
  glue_s3_retry_max_wait_millis = try(each.value.glue_s3_retry_max_wait_millis, var.glue_s3_retry_max_wait_millis)

  step_function_execution_role_arn = "arn:aws:iam::${local.account_id}:role/${local.project}-step-function-execution-role"

  tags = merge(
    local.tags,
    {
      resource-type   = "Step Function"
      jira            = "main"
      domain          = each.key
      domain-category = each.value.domain_type
    }
  )
}

#Reload Pipeline, Specific to Domain (Many Instances)
# checkov:skip=CKV_TF_1: Commit hash not enforced for legacy module
module "reload-pipeline" {
  source = "git::https://github.com/modular-data/datahub-tf-service-modules.git//modules/domains/reload-pipeline?ref=main"

  for_each = {
    for k, v in var.domains : k => v
    if try(v.setup_reload_pipeline, var.setup_reload_pipeline)
  }

  batch_only                                   = try(each.value.batch_only, var.batch_only)
  file_transfer_in                             = each.value.domain_type == "file-transfer-in"
  split_pipeline                               = try(each.value.split_dms_task, var.split_dms_task)
  setup_reload_pipeline                        = try(each.value.setup_reload_pipeline, var.setup_reload_pipeline)
  reload_pipeline                              = "${local.project}-reload-pipeline${try(each.value.batch_only, var.batch_only) ? "-batch" : ""}-${each.value.domain_type}-${each.key}-${var.environment}"
  enable_archive_backfill                      = try(each.value.enable_archive_backfill, var.enable_archive_backfill)
  domain                                       = each.key
  domain_s3_prefix                             = each.value.rename_output_space
  dms_replication_task_arn                     = try(module.dms-task[each.key].dms_replication_task_arn, null)
  dms_cdc_replication_task_arn                 = try(each.value.split_dms_task, var.split_dms_task) ? try(module.dms-cdc-task[each.key].dms_replication_task_arn, null) : null
  replication_task_id                          = try(module.dms-task[each.key].replication_task_id, null)
  cdc_replication_task_id                      = try(each.value.split_dms_task, var.split_dms_task) ? try(module.dms-cdc-task[each.key].replication_task_id, null) : null
  glue_reporting_hub_batch_jobname             = "${local.project}-batch-${each.key}-${var.environment}"
  glue_hive_table_creation_jobname             = "${local.project}-hive-table-creation-${var.environment}"
  glue_reporting_hub_cdc_jobname               = "${local.project}-cdc-${each.key}-${var.environment}"
  glue_stop_glue_instance_job                  = "${local.project}-stop-glue-instance-job-${var.environment}"
  stop_dms_task_job                            = "${local.project}-stop-dms-task-job-${var.environment}"
  set_cdc_dms_start_time_job                   = try(each.value.split_dms_task, var.split_dms_task) ? "${local.project}-set-cdc-dms-start-time-job-${var.environment}" : null
  glue_trigger_activation_job                  = "${local.project}-activate-glue-trigger-job-${var.environment}"
  archive_job_trigger_name                     = "${local.project}-archive-${each.key}-${var.environment}-trigger"
  glue_archive_job                             = "${local.project}-archive-${each.key}-${var.environment}"
  glue_unprocessed_raw_files_check_job         = "pending-files-check-${each.key}-${var.environment}"
  glue_create_reload_diff_job                  = "${local.project}-create-reload-diff-${each.key}-${var.environment}"
  archive_backfill_job                         = "${local.project}-archive-backfill-${each.key}-${var.environment}"
  glue_reconciliation_job                      = "${local.project}-reconciliation-${each.key}-${var.environment}"
  s3_landing_bucket_id                         = data.aws_s3_bucket.landing.id
  s3_landing_processing_bucket_id              = data.aws_s3_bucket.landing_processing.id
  s3_raw_bucket_id                             = data.aws_s3_bucket.raw.id
  s3_raw_archive_bucket_id                     = data.aws_s3_bucket.raw_archive.id
  s3_structured_bucket_id                      = data.aws_s3_bucket.structured.id
  s3_curated_bucket_id                         = data.aws_s3_bucket.curated.id
  s3_temp_reload_bucket_id                     = data.aws_s3_bucket.temp_reload.id
  s3_glue_bucket_id                            = data.aws_s3_bucket.glue.id
  s3_structured_path                           = "s3://${data.aws_s3_bucket.structured.id}/${each.value.rename_output_space}/"
  s3_curated_path                              = "s3://${data.aws_s3_bucket.curated.id}/${each.value.rename_output_space}/"
  file_transfer_parallelism                    = try(each.value.file_transfer_parallelism, var.file_transfer_parallelism)
  file_transfer_use_default_parallelism        = try(each.value.file_transfer_use_default_parallelism, var.file_transfer_use_default_parallelism)
  glue_s3_file_transfer_job                    = "${local.project}-s3-file-transfer-job-${var.environment}"
  glue_s3_data_deletion_job                    = "${local.project}-s3-data-deletion-job-${var.environment}"
  glue_switch_prisons_hive_data_location_job   = "${local.project}-switch-prisons-data-source-${var.environment}"
  glue_maintenance_retention_job               = "${local.project}-maintenance-retention-${var.environment}"
  glue_maintenance_compaction_job              = "${local.project}-maintenance-compaction-${var.environment}"
  pipeline_notification_lambda_function        = "${var.step_function_notification_lambda}-function"
  landing_zone_antivirus_check_lambda_function = var.setup_file_transfer_in_lambdas ? module.landing_zone_antivirus_check_lambda.lambda_name : ""
  landing_zone_processing_lambda_function      = var.setup_file_transfer_in_lambdas ? module.landing_zone_processing_lambda.lambda_name : ""


  compaction_structured_num_workers = try(each.value.reload_compaction_structured_num_workers, var.compaction_structured_num_workers)
  compaction_structured_worker_type = try(each.value.reload_compaction_structured_worker_type, var.compaction_structured_worker_type)
  compaction_curated_num_workers    = try(each.value.reload_compaction_curated_num_workers, var.compaction_curated_num_workers)
  compaction_curated_worker_type    = try(each.value.reload_compaction_curated_worker_type, var.compaction_curated_worker_type)

  retention_structured_num_workers = try(each.value.reload_retention_structured_num_workers, var.retention_structured_num_workers)
  retention_structured_worker_type = try(each.value.reload_retention_structured_worker_type, var.retention_structured_worker_type)
  retention_curated_num_workers    = try(each.value.reload_retention_curated_num_workers, var.retention_curated_num_workers)
  retention_curated_worker_type    = try(each.value.reload_retention_curated_worker_type, var.retention_curated_worker_type)

  processed_files_check_wait_interval_seconds = try(each.value.reload_pipeline_processed_files_check_wait_interval_seconds, var.processed_files_check_wait_interval_seconds)
  processed_files_check_max_attempts          = try(each.value.reload_pipeline_processed_files_check_max_attempts, var.processed_files_check_max_attempts)

  glue_s3_max_attempts          = try(each.value.glue_s3_max_attempts, var.glue_s3_max_attempts)
  glue_s3_retry_min_wait_millis = try(each.value.glue_s3_retry_min_wait_millis, var.glue_s3_retry_min_wait_millis)
  glue_s3_retry_max_wait_millis = try(each.value.glue_s3_retry_max_wait_millis, var.glue_s3_retry_max_wait_millis)

  step_function_execution_role_arn = "arn:aws:iam::${local.account_id}:role/${local.project}-step-function-execution-role"

  landing_zone_antivirus_check_lambda_timeout_in_seconds   = var.landing_zone_antivirus_check_lambda_timeout_in_seconds
  landing_zone_processing_lambda_timeout_in_seconds        = var.landing_zone_processing_lambda_timeout_in_seconds
  pipeline_notification_lambda_function_ignore_dms_failure = try(each.value.split_dms_task, var.split_dms_task) ? try(each.value.pipeline_notification_lambda_function_ignore_dms_failure, false) : false

  tags = merge(
    local.tags,
    {
      resource-type   = "Step Function"
      jira            = "main"
      domain          = each.key
      domain-category = each.value.domain_type
    }
  )

}

#Replay Pipeline, Specific to Domain (Many Instances)
# checkov:skip=CKV_TF_1: Commit hash not enforced for legacy module
module "replay-pipeline" {
  source = "git::https://github.com/modular-data/datahub-tf-service-modules.git//modules/domains/replay-pipeline?ref=main"

  for_each = {
    for k, v in var.domains : k => v
    if try(v.setup_replay_pipeline, var.setup_replay_pipeline) && try(!v.batch_only, !var.batch_only)
  }

  setup_replay_pipeline                      = try(each.value.setup_replay_pipeline, var.setup_replay_pipeline)
  replay_pipeline                            = "${local.project}-replay-pipeline-${each.value.domain_type}-${each.key}-${var.environment}"
  domain                                     = each.key
  dms_replication_task_arn                   = try(each.value.split_dms_task, var.split_dms_task) ? module.dms-cdc-task[each.key].dms_replication_task_arn : module.dms-task[each.key].dms_replication_task_arn
  replication_task_id                        = try(each.value.split_dms_task, var.split_dms_task) ? module.dms-cdc-task[each.key].replication_task_id : module.dms-task[each.key].replication_task_id
  glue_reporting_hub_batch_jobname           = "${local.project}-batch-${each.key}-${var.environment}"
  glue_reporting_hub_cdc_jobname             = "${local.project}-cdc-${each.key}-${var.environment}"
  glue_stop_glue_instance_job                = "${local.project}-stop-glue-instance-job-${var.environment}"
  stop_dms_task_job                          = "${local.project}-stop-dms-task-job-${var.environment}"
  glue_trigger_activation_job                = "${local.project}-activate-glue-trigger-job-${var.environment}"
  archive_job_trigger_name                   = "${local.project}-archive-${each.key}-${var.environment}-trigger"
  glue_archive_job                           = "${local.project}-archive-${each.key}-${var.environment}"
  glue_unprocessed_raw_files_check_job       = "pending-files-check-${each.key}-${var.environment}"
  s3_raw_bucket_id                           = data.aws_s3_bucket.raw.id
  s3_raw_archive_bucket_id                   = data.aws_s3_bucket.raw_archive.id
  s3_structured_bucket_id                    = data.aws_s3_bucket.structured.id
  s3_curated_bucket_id                       = data.aws_s3_bucket.curated.id
  s3_temp_reload_bucket_id                   = data.aws_s3_bucket.temp_reload.id
  s3_glue_bucket_id                          = data.aws_s3_bucket.glue.id
  s3_structured_path                         = "s3://${data.aws_s3_bucket.structured.id}/${each.value.rename_output_space}/"
  s3_curated_path                            = "s3://${data.aws_s3_bucket.curated.id}/${each.value.rename_output_space}/"
  file_transfer_parallelism                  = try(each.value.file_transfer_parallelism, var.file_transfer_parallelism)
  file_transfer_use_default_parallelism      = try(each.value.file_transfer_use_default_parallelism, var.file_transfer_use_default_parallelism)
  glue_s3_file_transfer_job                  = "${local.project}-s3-file-transfer-job-${var.environment}"
  glue_s3_data_deletion_job                  = "${local.project}-s3-data-deletion-job-${var.environment}"
  glue_switch_prisons_hive_data_location_job = "${local.project}-switch-prisons-data-source-${var.environment}"
  glue_maintenance_retention_job             = "${local.project}-maintenance-retention-${var.environment}"
  glue_maintenance_compaction_job            = "${local.project}-maintenance-compaction-${var.environment}"

  compaction_structured_num_workers = try(each.value.replay_compaction_structured_num_workers, var.compaction_structured_num_workers)
  compaction_structured_worker_type = try(each.value.replay_compaction_structured_worker_type, var.compaction_structured_worker_type)
  compaction_curated_num_workers    = try(each.value.replay_compaction_curated_num_workers, var.compaction_curated_num_workers)
  compaction_curated_worker_type    = try(each.value.replay_compaction_curated_worker_type, var.compaction_curated_worker_type)

  retention_structured_num_workers = try(each.value.replay_retention_structured_num_workers, var.retention_structured_num_workers)
  retention_structured_worker_type = try(each.value.replay_retention_structured_worker_type, var.retention_structured_worker_type)
  retention_curated_num_workers    = try(each.value.replay_retention_curated_num_workers, var.retention_curated_num_workers)
  retention_curated_worker_type    = try(each.value.replay_retention_curated_worker_type, var.retention_curated_worker_type)

  processed_files_check_wait_interval_seconds = try(each.value.replay_pipeline_processed_files_check_wait_interval_seconds, var.processed_files_check_wait_interval_seconds)
  processed_files_check_max_attempts          = try(each.value.replay_pipeline_processed_files_check_max_attempts, var.processed_files_check_max_attempts)

  glue_s3_max_attempts          = try(each.value.glue_s3_max_attempts, var.glue_s3_max_attempts)
  glue_s3_retry_min_wait_millis = try(each.value.glue_s3_retry_min_wait_millis, var.glue_s3_retry_min_wait_millis)
  glue_s3_retry_max_wait_millis = try(each.value.glue_s3_retry_max_wait_millis, var.glue_s3_retry_max_wait_millis)

  step_function_execution_role_arn = "arn:aws:iam::${local.account_id}:role/${local.project}-step-function-execution-role"

  tags = merge(
    local.tags,
    {
      resource-type   = "Step Function"
      jira            = "main"
      domain          = each.key
      domain-category = each.value.domain_type
    }
  )
}

#Pipeline to Start CDC, Specific to Domain (Many Instances)
# checkov:skip=CKV_TF_1: Commit hash not enforced for legacy module
module "cdc-start-pipeline" {
  source = "git::https://github.com/modular-data/datahub-tf-service-modules.git//modules/domains/start-cdc-pipeline?ref=main"

  for_each = {
    for k, v in var.domains : k => v
    if try(v.setup_start_cdc_pipeline, var.setup_start_cdc_pipeline) && try(!v.batch_only, !var.batch_only)
  }

  setup_start_cdc_pipeline       = try(each.value.setup_start_cdc_pipeline, var.setup_start_cdc_pipeline)
  start_cdc_pipeline             = "${local.project}-start-cdc-${each.value.domain_type}-${each.key}-${var.environment}"
  domain                         = each.key
  dms_replication_task_arn       = try(each.value.split_dms_task, var.split_dms_task) ? module.dms-cdc-task[each.key].dms_replication_task_arn : module.dms-task[each.key].dms_replication_task_arn
  replication_task_id            = try(each.value.split_dms_task, var.split_dms_task) ? module.dms-cdc-task[each.key].replication_task_id : module.dms-task[each.key].replication_task_id
  stop_dms_task_job              = "${local.project}-stop-dms-task-job-${var.environment}"
  glue_stop_glue_instance_job    = "${local.project}-stop-glue-instance-job-${var.environment}"
  glue_reporting_hub_cdc_jobname = "${local.project}-cdc-${each.key}-${var.environment}"
  s3_glue_bucket_id              = data.aws_s3_bucket.glue.id

  step_function_execution_role_arn = "arn:aws:iam::${local.account_id}:role/${local.project}-step-function-execution-role"

  tags = merge(
    local.tags,
    {
      resource-type   = "Step Function"
      jira            = "main"
      domain          = each.key
      domain-category = each.value.domain_type
    }
  )
}

#Pipeline to Stop CDC, Specific to Domain (Many Instances)
# checkov:skip=CKV_TF_1: Commit hash not enforced for legacy module
module "cdc-stop-pipeline" {
  source = "git::https://github.com/modular-data/datahub-tf-service-modules.git//modules/domains/stop-cdc-pipeline?ref=main"

  for_each = {
    for k, v in var.domains : k => v
    if try(v.setup_stop_cdc_pipeline, var.setup_stop_cdc_pipeline) && try(!v.batch_only, !var.batch_only)
  }

  setup_stop_cdc_pipeline        = try(each.value.setup_stop_cdc_pipeline, var.setup_stop_cdc_pipeline)
  stop_cdc_pipeline              = "${local.project}-stop-cdc-${each.value.domain_type}-${each.key}-${var.environment}"
  replication_task_id            = try(each.value.split_dms_task, var.split_dms_task) ? module.dms-cdc-task[each.key].replication_task_id : module.dms-task[each.key].replication_task_id
  stop_dms_task_job              = "${local.project}-stop-dms-task-job-${var.environment}"
  glue_stop_glue_instance_job    = "${local.project}-stop-glue-instance-job-${var.environment}"
  glue_reporting_hub_cdc_jobname = "${local.project}-cdc-${each.key}-${var.environment}"

  glue_unprocessed_raw_files_check_job = "pending-files-check-${each.key}-${var.environment}"
  step_function_execution_role_arn     = "arn:aws:iam::${local.account_id}:role/${local.project}-step-function-execution-role"

  processed_files_check_wait_interval_seconds = try(each.value.stop_cdc_pipeline_processed_files_check_wait_interval_seconds, var.processed_files_check_wait_interval_seconds)
  processed_files_check_max_attempts          = try(each.value.stop_cdc_pipeline_processed_files_check_max_attempts, var.processed_files_check_max_attempts)

  tags = merge(
    local.tags,
    {
      resource-type   = "Step Function"
      jira            = "main"
      domain          = each.key
      domain-category = each.value.domain_type
    }
  )
}

# Pipeline To Execute Maintenance Jobs Across The Zones, Specific to Domain (Many Instances)
# checkov:skip=CKV_TF_1: Commit hash not enforced for legacy module
module "maintenance-pipeline" {
  source = "git::https://github.com/modular-data/datahub-tf-service-modules.git//modules/domains/maintenance-pipeline?ref=main"

  for_each = {
    for k, v in var.domains : k => v
    if try(v.setup_maintenance_pipeline, var.setup_maintenance_pipeline) && try(!v.batch_only, !var.batch_only)
  }

  setup_maintenance_pipeline = try(each.value.setup_maintenance_pipeline, var.setup_maintenance_pipeline)
  maintenance_pipeline_name  = "${local.project}-maintenance-pipeline-${each.value.domain_type}-${each.key}-${var.environment}"
  domain                     = each.key
  replication_task_id        = try(each.value.split_dms_task, var.split_dms_task) ? module.dms-cdc-task[each.key].replication_task_id : module.dms-task[each.key].replication_task_id
  dms_replication_task_arn   = try(each.value.split_dms_task, var.split_dms_task) ? module.dms-cdc-task[each.key].dms_replication_task_arn : module.dms-task[each.key].dms_replication_task_arn

  stop_dms_task_job               = "${local.project}-stop-dms-task-job-${var.environment}"
  glue_stop_glue_instance_job     = "${local.project}-stop-glue-instance-job-${var.environment}"
  glue_maintenance_compaction_job = "${local.project}-maintenance-compaction-${var.environment}"
  glue_maintenance_retention_job  = "${local.project}-maintenance-retention-${var.environment}"
  glue_reporting_hub_cdc_jobname  = "${local.project}-cdc-${each.key}-${var.environment}"

  s3_glue_bucket_id  = data.aws_s3_bucket.glue.id
  s3_structured_path = "s3://${data.aws_s3_bucket.structured.id}/${each.value.rename_output_space}/"
  s3_curated_path    = "s3://${data.aws_s3_bucket.curated.id}/${each.value.rename_output_space}/"

  compaction_structured_num_workers = try(each.value.compaction_structured_num_workers, var.compaction_structured_num_workers)
  compaction_structured_worker_type = try(each.value.compaction_structured_worker_type, var.compaction_structured_worker_type)
  compaction_curated_num_workers    = try(each.value.compaction_curated_num_workers, var.compaction_curated_num_workers)
  compaction_curated_worker_type    = try(each.value.compaction_curated_worker_type, var.compaction_curated_worker_type)

  retention_structured_num_workers = try(each.value.retention_structured_num_workers, var.retention_structured_num_workers)
  retention_structured_worker_type = try(each.value.retention_structured_worker_type, var.retention_structured_worker_type)
  retention_curated_num_workers    = try(each.value.retention_curated_num_workers, var.retention_curated_num_workers)
  retention_curated_worker_type    = try(each.value.retention_curated_worker_type, var.retention_curated_worker_type)

  processed_files_check_wait_interval_seconds = try(each.value.maintenance_pipeline_processed_files_check_wait_interval_seconds, var.processed_files_check_wait_interval_seconds)
  processed_files_check_max_attempts          = try(each.value.maintenance_pipeline_processed_files_check_max_attempts, var.processed_files_check_max_attempts)

  glue_s3_max_attempts          = try(each.value.glue_s3_max_attempts, var.glue_s3_max_attempts)
  glue_s3_retry_min_wait_millis = try(each.value.glue_s3_retry_min_wait_millis, var.glue_s3_retry_min_wait_millis)
  glue_s3_retry_max_wait_millis = try(each.value.glue_s3_retry_max_wait_millis, var.glue_s3_retry_max_wait_millis)

  glue_unprocessed_raw_files_check_job = "pending-files-check-${each.key}-${var.environment}"
  step_function_execution_role_arn     = "arn:aws:iam::${local.account_id}:role/${local.project}-step-function-execution-role"

  glue_archive_job            = "${local.project}-archive-${each.key}-${var.environment}"
  glue_trigger_activation_job = "${local.project}-activate-glue-trigger-job-${var.environment}"
  archive_job_trigger_name    = "${local.project}-archive-${each.key}-${var.environment}-trigger"

  tags = merge(
    local.tags,
    {
      resource-type   = "Step Function"
      jira            = "main"
      domain          = each.key
      domain-category = each.value.domain_type
    }
  )
}


#Pipeline Start Triggers, Specific to Domain (Many Instances)
# checkov:skip=CKV_TF_1: Commit hash not enforced for legacy module
module "pipeline-start-triggers" {
  source = "git::https://github.com/modular-data/datahub-tf-service-modules.git//modules/eventbridge_trigger?ref=main"

  for_each = {
    for k, v in var.domains : k => v
    if try(v.create_start_pipeline_schedule, var.create_start_pipeline_schedule) && try(!v.batch_only, !var.batch_only)
  }

  create_eventbridge_schedule = try(each.value.create_start_pipeline_schedule, var.create_start_pipeline_schedule)
  enable_eventbridge_schedule = try(each.value.enable_cdc_start_pipeline_schedule, var.enable_cdc_start_pipeline_schedule)
  eventbridge_trigger_name    = "${local.project}-start-cdc-${each.value.domain_type}-${each.key}-${var.environment}"
  schedule_expression         = try(each.value.cdc_start_pipeline_cron_schedule_expression, var.cdc_start_pipeline_cron_schedule_expression)
  description                 = "Triggers a Step Function Based on a Given Schedule"

  time_window_mode          = "FLEXIBLE"
  maximum_window_in_minutes = try(each.value.cdc_start_pipeline_max_window_in_minutes, var.cdc_start_pipeline_max_window_in_minutes)

  arn      = "arn:aws:states:${local.region}:${local.account_id}:stateMachine:${local.project}-start-cdc-${each.value.domain_type}-${each.key}-${var.environment}"
  role_arn = "arn:aws:iam::${local.account_id}:role/${local.project}-step-function-execution-role"

  input = jsonencode({
    StateMachineArn = "arn:aws:states:${local.region}:${local.account_id}:stateMachine:${local.project}-start-cdc-${each.value.domain_type}-${each.key}-${var.environment}"
    Input           = ""
  })
}

#Pipeline Stop Triggers, Specific to Domain (Many Instances)
# checkov:skip=CKV_TF_1: Commit hash not enforced for legacy module
module "pipeline-stop-triggers" {
  source = "git::https://github.com/modular-data/datahub-tf-service-modules.git//modules/eventbridge_trigger?ref=main"

  for_each = {
    for k, v in var.domains : k => v
    if try(v.create_stop_pipeline_schedule, var.create_stop_pipeline_schedule) && try(!v.batch_only, !var.batch_only)
  }

  create_eventbridge_schedule = try(each.value.create_stop_pipeline_schedule, var.create_stop_pipeline_schedule)
  enable_eventbridge_schedule = try(each.value.enable_cdc_stop_pipeline_schedule, var.enable_cdc_stop_pipeline_schedule)
  eventbridge_trigger_name    = "${local.project}-stop-cdc-${each.value.domain_type}-${each.key}-${var.environment}"
  schedule_expression         = try(each.value.cdc_stop_pipeline_cron_schedule_expression, var.cdc_stop_pipeline_cron_schedule_expression)
  description                 = "Triggers a Step Function Based on a Given Schedule"

  time_window_mode          = "FLEXIBLE"
  maximum_window_in_minutes = try(each.value.cdc_stop_pipeline_max_window_in_minutes, var.cdc_stop_pipeline_max_window_in_minutes)

  arn      = "arn:aws:states:${local.region}:${local.account_id}:stateMachine:${local.project}-stop-cdc-${each.value.domain_type}-${each.key}-${var.environment}"
  role_arn = "arn:aws:iam::${local.account_id}:role/${local.project}-step-function-execution-role"

  input = jsonencode({
    StateMachineArn = "arn:aws:states:${local.region}:${local.account_id}:stateMachine:${local.project}-stop-cdc-${each.value.domain_type}-${each.key}-${var.environment}"
    Input           = ""
  })
}

# Trigger to Start the Maintenance Pipeline, Specific to Domain (Many Instances)
# checkov:skip=CKV_TF_1: Commit hash not enforced for legacy module
module "maintenance-pipeline-triggers" {
  source = "git::https://github.com/modular-data/datahub-tf-service-modules.git//modules/eventbridge_trigger?ref=main"

  for_each = {
    for k, v in var.domains : k => v
    if try(v.create_maintenance_pipeline_schedule, var.create_maintenance_pipeline_schedule) && try(!v.batch_only, !var.batch_only)
  }

  create_eventbridge_schedule = try(each.value.create_maintenance_pipeline_schedule, var.create_maintenance_pipeline_schedule)
  enable_eventbridge_schedule = try(each.value.enable_maintenance_pipeline_schedule, var.enable_maintenance_pipeline_schedule)
  eventbridge_trigger_name    = "${local.project}-maintenance-pipeline-${each.value.domain_type}-${each.key}-${var.environment}"
  schedule_expression         = try(each.value.maintenance_pipeline_cron_schedule_expression, var.maintenance_pipeline_cron_schedule_expression)
  description                 = "Triggers the Maintenance Pipeline Based on a Given Schedule"

  time_window_mode          = "FLEXIBLE"
  maximum_window_in_minutes = try(each.value.maintenance_pipeline_max_window_in_minutes, var.maintenance_pipeline_max_window_in_minutes)

  arn      = "arn:aws:states:${local.region}:${local.account_id}:stateMachine:${local.project}-maintenance-pipeline-${each.value.domain_type}-${each.key}-${var.environment}"
  role_arn = "arn:aws:iam::${local.account_id}:role/${local.project}-step-function-execution-role"

  input = jsonencode({
    StateMachineArn = "arn:aws:states:${local.region}:${local.account_id}:stateMachine:${local.project}-maintenance-pipeline-${each.value.domain_type}-${each.key}-${var.environment}"
    Input           = ""
  })
}

# Trigger to Start the Ingestion Pipeline, Only Applicable to Batch Only Domains (Many Instances)
# checkov:skip=CKV_TF_1: Commit hash not enforced for legacy module
module "ingestion-pipeline-triggers" {
  source = "git::https://github.com/modular-data/datahub-tf-service-modules.git//modules/eventbridge_trigger?ref=main"

  for_each = {
    for k, v in var.domains : k => v
    if try(v.create_ingestion_pipeline_schedule, var.create_ingestion_pipeline_schedule)
  }

  create_eventbridge_schedule = try(each.value.create_ingestion_pipeline_schedule, var.create_ingestion_pipeline_schedule)
  enable_eventbridge_schedule = try(each.value.enable_ingestion_pipeline_schedule, var.enable_ingestion_pipeline_schedule)
  eventbridge_trigger_name    = "${local.project}-ingestion-pipeline-${each.value.domain_type}-${each.key}-${var.environment}"
  schedule_expression         = try(each.value.ingestion_pipeline_cron_schedule_expression, var.ingestion_pipeline_cron_schedule_expression)
  description                 = "Triggers the Ingestion Pipeline Based on a Given Schedule"

  time_window_mode          = "FLEXIBLE"
  maximum_window_in_minutes = try(each.value.ingestion_pipeline_max_window_in_minutes, var.ingestion_pipeline_max_window_in_minutes)

  arn      = "arn:aws:states:${local.region}:${local.account_id}:stateMachine:${local.project}-ingestion-pipeline${try(each.value.batch_only, var.batch_only) ? "-batch" : ""}-${each.value.domain_type}-${each.key}-${var.environment}"
  role_arn = "arn:aws:iam::${local.account_id}:role/${local.project}-step-function-execution-role"

  input = jsonencode({
    StateMachineArn = "arn:aws:states:${local.region}:${local.account_id}:stateMachine:${local.project}-ingestion-pipeline${try(each.value.batch_only, var.batch_only) ? "-batch" : ""}-${each.value.domain_type}-${each.key}-${var.environment}"
    Input           = ""
  })
}

# Trigger to Start the Reload Pipeline, Only Applicable to Batch Only Domains (Many Instances)
# checkov:skip=CKV_TF_1: Commit hash not enforced for legacy module
module "reload-pipeline-triggers" {
  source = "git::https://github.com/modular-data/datahub-tf-service-modules.git//modules/eventbridge_trigger?ref=main"

  for_each = {
    for k, v in var.domains : k => v
    if try(v.create_reload_pipeline_schedule, var.create_reload_pipeline_schedule) && try(v.batch_only, var.batch_only)
  }

  create_eventbridge_schedule = try(each.value.create_reload_pipeline_schedule, var.create_reload_pipeline_schedule)
  enable_eventbridge_schedule = try(each.value.enable_reload_pipeline_schedule, var.enable_reload_pipeline_schedule)
  eventbridge_trigger_name    = "${local.project}-reload-pipeline-${each.value.domain_type}-${each.key}-${var.environment}"
  schedule_expression         = try(each.value.reload_pipeline_cron_schedule_expression, var.reload_pipeline_cron_schedule_expression)
  description                 = "Triggers the Reload Pipeline Based on a Given Schedule"

  time_window_mode          = "FLEXIBLE"
  maximum_window_in_minutes = try(each.value.reload_pipeline_max_window_in_minutes, var.reload_pipeline_max_window_in_minutes)

  arn      = "arn:aws:states:${local.region}:${local.account_id}:stateMachine:${local.project}-reload-pipeline${try(each.value.batch_only, var.batch_only) ? "-batch" : ""}-${each.value.domain_type}-${each.key}-${var.environment}"
  role_arn = "arn:aws:iam::${local.account_id}:role/${local.project}-step-function-execution-role"

  input = jsonencode({
    StateMachineArn = "arn:aws:states:${local.region}:${local.account_id}:stateMachine:${local.project}-reload-pipeline${try(each.value.batch_only, var.batch_only) ? "-batch" : ""}-${each.value.domain_type}-${each.key}-${var.environment}"
    Input           = ""
  })
}

# Trigger Postgres Tickle Lambda (Many Instances)
# checkov:skip=CKV_TF_1: Commit hash not enforced for legacy module
module "postgres_tickle_lambda_trigger" {
  source = "git::https://github.com/modular-data/datahub-tf-service-modules.git//modules/eventbridge_trigger?ref=main"

  for_each = {
    for k, v in var.domains : k => v
    if try(v.create_postgres_tickle_schedule, var.create_postgres_tickle_schedule)
  }

  create_eventbridge_schedule = try(each.value.create_postgres_tickle_schedule, var.create_postgres_tickle_schedule)
  enable_eventbridge_schedule = try(each.value.enable_postgres_tickle_schedule, var.enable_postgres_tickle_schedule)
  eventbridge_trigger_name    = "${local.project}-postgres-tickle-trigger-${each.value.domain_type}-${each.key}-${var.environment}"
  schedule_expression         = try(each.value.postgres_tickle_schedule_expression, var.postgres_tickle_schedule_expression)
  description                 = "Triggers the Postgres Tickle Lambda Based on a Given Schedule"

  arn      = "arn:aws:lambda:${local.region}:${local.account_id}:function:${local.project}-postgres-tickle-function"
  role_arn = "arn:aws:iam::${local.account_id}:role/${local.project}-lambda-function-invocation-role"

  input = jsonencode({ secretId = data.aws_secretsmanager_secret.this[each.key].name })

}

# Lambda shared by all File Transfer In based domains
module "landing_zone_antivirus_check_lambda" {
  source = "git::https://github.com/modular-data/datahub-tf-service-modules.git//modules/domains/antivirus-check-lambda?ref=main"

  enable                 = var.setup_file_transfer_in_lambdas
  name                   = "${local.project}-landing-zone-antivirus-check"
  ecr_repository_url     = data.aws_ecr_repository.file_transfer_in_clamav_scanner.repository_url
  image_version          = "latest"
  output_bucket_name     = data.aws_s3_bucket.landing_processing.id
  quarantine_bucket_name = data.aws_s3_bucket.quarantine.id

  # This lambda needs to read from the Landing Zone S3 bucket, write to the Landing
  # Processing Zone and notify Step Functions of task success or failure
  policies = [
    local.kms_read_access_policy_arn,
    local.s3_read_write_policy_arn,
    local.all_state_machine_policy_arn
  ]

  memory_size                    = var.landing_zone_antivirus_check_lambda_memory_size
  timeout                        = var.landing_zone_antivirus_check_lambda_timeout_in_seconds
  ephemeral_storage_size         = var.landing_zone_antivirus_check_lambda_ephemeral_storage_size
  reserved_concurrent_executions = var.landing_zone_antivirus_check_lambda_reserved_concurrent_executions
  log_retention_in_days          = var.landing_zone_antivirus_check_lambda_log_retention_in_days

  subnet_ids = [
    data.aws_subnet.data_subnets_a.id,
    data.aws_subnet.data_subnets_b.id,
    data.aws_subnet.data_subnets_c.id
  ]

  security_group_ids = [
    data.aws_security_group.generic_lambda.id
  ]
}

module "landing_zone_processing_lambda" {
  source = "git::https://github.com/modular-data/datahub-tf-service-modules.git//modules/domains/landing-zone-processing-lambda?ref=main"

  enable = var.setup_file_transfer_in_lambdas
  name   = "${local.project}-landing-zone-processing"

  lambda_code_s3_bucket        = var.artifact_s3_bucket
  lambda_code_s3_key           = var.landing_zone_processing_lambda_jar_s3_key
  output_bucket_name           = data.aws_s3_bucket.raw.id
  schema_registry_bucket_name  = data.aws_s3_bucket.schema_registry.id
  violations_bucket_name       = data.aws_s3_bucket.violations.id
  violations_path              = var.landing_zone_processing_lambda_violations_path
  lambda_timeout_in_seconds    = var.landing_zone_processing_lambda_timeout_in_seconds
  memory_size_mb               = var.landing_zone_processing_lambda_memory_mb
  lambda_log_retention_in_days = var.landing_zone_processing_lambda_log_retention_in_days
  lambda_tracing               = var.landing_zone_processing_lambda_tracing

  csv_charset                       = var.landing_zone_processing_lambda_csv_charset
  number_of_csv_header_rows_to_skip = var.landing_zone_processing_skip_header ? 1 : 0
  log_csv                           = var.landing_zone_processing_log_csv

  # This lambda needs to read from the Landing Processing Zone S3 bucket, write to the
  # Raw Zone and notify Step Functions of task success or failure
  policies = [
    local.kms_read_access_policy_arn,
    local.s3_read_write_policy_arn,
    local.all_state_machine_policy_arn
  ]

  subnet_ids = [
    data.aws_subnet.data_subnets_a.id,
    data.aws_subnet.data_subnets_b.id,
    data.aws_subnet.data_subnets_c.id
  ]

  security_group_ids = [
    data.aws_security_group.generic_lambda.id
  ]
}

module "athena_federated_query_connector_postgresql" {
  source = "git::https://github.com/ministryofjustice/modernisation-platform-environments.git//terraform/environments/digital-prison-reporting/modules/athena_federated_query_connectors?ref=main"

  for_each = local.dps_full_connection_strings
  #checkov:skip=CKV_AWS_25
  #checkov:skip=CKV_AWS_23
  #checkov:skip=CKV_AWS_277
  #checkov:skip=CKV_AWS_260
  #checkov:skip=CKV_AWS_24
  #checkov:skip=CKV_AWS_117
  #checkov:skip=CKV_AWS_363
  #checkov:skip=CKV_AWS_63:Ensure no IAM policies documents allow "*" as a statement's actions
  #checkov:skip=CKV_AWS_62:Ensure IAM policies that allow full "*-*" administrative privileges are not created
  #checkov:skip=CKV_AWS_61:Ensure AWS IAM policy does not allow assume role permission across all service
  #checkov:skip=CKV_AWS_60:Ensure IAM role allows only specific services or principals to assume it
  #checkov:skip=CKV_AWS_274:Disallow IAM roles, users, and groups from using the AWS AdministratorAccess policy

  name                                  = "${local.project}-${replace(each.key, "_", "-")}-federated-query"
  connector_jar_bucket_key              = "third-party/athena-postgresql/athena-postgresql-2025.23.1.jar"
  connector_jar_bucket_name             = var.artifact_s3_bucket
  spill_bucket_name                     = var.working_s3_bucket
  credentials_secret_arns               = [for s in data.aws_secretsmanager_secret.dps_secret : s.arn]
  project_prefix                        = local.project
  account_id                            = local.account_id
  region                                = local.region
  vpc_id                                = data.aws_vpc.shared.id
  subnet_id                             = data.aws_subnet.private_subnets_a.id
  lambda_memory_allocation_mb           = var.athena_federated_query_lambda_memory_mb
  lambda_timeout_seconds                = var.athena_federated_query_lambda_timeout_in_seconds
  lambda_reserved_concurrent_executions = var.athena_federated_query_lambda_reserved_concurrent_executions
  lambda_handler                        = var.athena_postgresql_federated_query_lambda_handler
  athena_connector_type                 = "postgresql"

  # A map that links catalog names to database connection strings
  connection_strings = {
    (each.key) = each.value
  }
}



# POSTGRESQL ATHENA DATA CATALOGS
# --------------------------------

# Adds an Athena data source / catalog for each DPS service
resource "aws_athena_data_catalog" "dps_data_catalog" {
  for_each    = module.athena_federated_query_connector_postgresql
  name        = each.key
  description = "${each.key} Athena data catalog"
  type        = "LAMBDA"

  parameters = {
    "function" = each.value.lambda_function_arn
  }
}

module "athena_federated_query_connector_redshift" {
  source = "git::https://github.com/ministryofjustice/modernisation-platform-environments.git//terraform/environments/digital-prison-reporting/modules/athena_federated_query_connectors?ref=main"

  #checkov:skip=CKV_AWS_25
  #checkov:skip=CKV_AWS_23
  #checkov:skip=CKV_AWS_277
  #checkov:skip=CKV_AWS_260
  #checkov:skip=CKV_AWS_24
  #checkov:skip=CKV_AWS_117
  #checkov:skip=CKV_AWS_363
  #checkov:skip=CKV_AWS_63:Ensure no IAM policies documents allow "*" as a statement's actions
  #checkov:skip=CKV_AWS_62:Ensure IAM policies that allow full "*-*" administrative privileges are not created
  #checkov:skip=CKV_AWS_61:Ensure AWS IAM policy does not allow assume role permission across all service
  #checkov:skip=CKV_AWS_60:Ensure IAM role allows only specific services or principals to assume it
  #checkov:skip=CKV_AWS_274:Disallow IAM roles, users, and groups from using the AWS AdministratorAccess policy

  name                                  = "${local.project}-athena-federated-query-redshift"
  connector_jar_bucket_key              = "third-party/athena-redshift/athena-redshift-2025.28.1.jar"
  connector_jar_bucket_name             = var.artifact_s3_bucket
  spill_bucket_name                     = var.working_s3_bucket
  credentials_secret_arns               = [data.aws_secretsmanager_secret.redshift.arn]
  project_prefix                        = local.project
  account_id                            = local.account_id
  region                                = local.region
  vpc_id                                = data.aws_vpc.shared.id
  subnet_id                             = data.aws_subnet.private_subnets_a.id
  lambda_memory_allocation_mb           = var.athena_federated_query_lambda_memory_mb
  lambda_timeout_seconds                = var.athena_federated_query_lambda_timeout_in_seconds
  lambda_reserved_concurrent_executions = var.athena_federated_query_lambda_reserved_concurrent_executions
  lambda_handler                        = var.athena_redshift_federated_query_lambda_handler
  athena_connector_type                 = "redshift"

  # A map that links catalog names to database connection strings
  connection_strings = local.redshift_datamart_connection_string
}

# REDSHIFT DATAMART ATHENA DATA CATALOGS
# --------------------------------

# Adds an Athena data source / catalog for Redshift
resource "aws_athena_data_catalog" "redshift_datamart_data_catalog" {
  name        = "redshift_datamart"
  description = "Redshift Datamart Athena data catalog"
  type        = "LAMBDA"

  parameters = {
    "function" = module.athena_federated_query_connector_redshift.lambda_function_arn
  }
}
