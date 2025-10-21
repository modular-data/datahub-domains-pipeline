environment = "development" 

# Lambda
setup_step_function_notification_lambda                      = true
step_function_notification_lambda                            = "dwh-pipeline-notification"
artifact_s3_bucket                                           = "dwh-artifact-store-development"
working_s3_bucket                                            = "dwh-working-development"
reporting_lambda_code_s3_key                                 = "build-artifacts/digital-prison-reporting-lambdas/jars/digital-prison-reporting-lambdas-vLatest-all.jar"
postgres_tickle_lambda_jar_s3_key                            = "build-artifacts/hmpps-dwh-postgres-tickle-lambda/jars/hmpps-dwh-postgres-tickle-lambda-vLatest-all.jar"
step_function_notification_lambda_handler                    = "uk.gov.justice.digital.lambda.StepFunctionDMSNotificationLambda::handleRequest"
step_function_notification_lambda_runtime                    = "java11"
step_function_notification_lambda_tracing                    = "Active"
step_function_notification_lambda_trigger                    = "dwh-pipeline-notification-development"
step_function_notification_lambda_sg_name                    = "dwh-generic-lambda-sg"
lambda_log_retention_in_days                                 = 3
athena_federated_query_lambda_memory_mb                      = 550
athena_federated_query_lambda_timeout_in_seconds             = 900
athena_federated_query_lambda_reserved_concurrent_executions = 20
athena_postgresql_federated_query_lambda_handler             = "com.amazonaws.athena.connectors.postgresql.PostGreSqlMuxCompositeHandler"
athena_redshift_federated_query_lambda_handler               = "com.amazonaws.athena.connectors.redshift.RedshiftMuxCompositeHandler"

# DMS Endpoints
nomis_source_engine      = "oracle"
dps_source_engine        = "postgres"

# DMS Instance
dms_log_group_retention_in_days = 3

# Glue Jobs, Global Parameters
enable_spark_ui   = "true" # Override with enable_spark_ui_override per Domain

# Ingestion JOB
setup_ingestion_jobs                    = true
script_version                          = "digital-prison-reporting-jobs-vLatest.scala"
jar_version                             = "digital-prison-reporting-jobs-vLatest-all.jar" # Override Version with Domain Special Variable, jar_version_override (Per Domain)
glue_cdc_job_worker_type                = "G.025X"
glue_cdc_job_num_workers                = 2
glue_cdc_max_concurrent                 = 1
glue_cdc_job_retry_max_attempts         = 10
glue_cdc_job_retry_min_wait_millis      = 100
glue_cdc_job_retry_max_wait_millis      = 10000
glue_cdc_job_log_level                  = "INFO"
glue_cdc_job_max_records_per_file       = 700000
glue_batch_job_worker_type              = "G.1X"
glue_batch_job_num_workers              = 2
glue_batch_max_concurrent               = 64
glue_batch_job_retry_max_attempts       = 10
glue_batch_job_retry_min_wait_millis    = 100
glue_batch_job_retry_max_wait_millis    = 10000
glue_batch_job_log_level                = "INFO"
glue_log_group_retention_in_days       = 3

# Reconciliation Job
setup_reconciliation_job                  = true
glue_reconciliation_job_worker_type       = "G.1X"
glue_reconciliation_job_num_workers       = 2
glue_reconciliation_job_max_concurrent    = 1
glue_reconciliation_job_create_sec_conf   = true
glue_reconciliation_job_log_level         = "INFO"
# Empty string means the job is not scheduled:
glue_reconciliation_job_schedule          = ""
glue_reconciliation_job_metrics_namespace = "DWHDataReconciliationCustom"
# Tolerances
glue_reconciliation_job_changedatacounts_tolerance_relative_percentage   = 0.0
glue_reconciliation_job_changedatacounts_tolerance_absolute              = 0
glue_reconciliation_job_currentstatecounts_tolerance_relative_percentage = 0.0
glue_reconciliation_job_currentstatecounts_tolerance_absolute            = 0

# File Transfer In

setup_file_transfer_in_lambdas                         = true
landing_zone_antivirus_check_lambda_timeout_in_seconds = 300 # 5 minutes
landing_zone_processing_lambda_jar_s3_key              = "build-artifacts/hmpps-datahub-landing-zone-processing-lambda/jars/hmpps-datahub-landing-zone-processing-lambda-vLatest-all.jar"
landing_zone_processing_lambda_timeout_in_seconds      = 300 # 5 minutes
landing_zone_processing_lambda_memory_mb               = 512
landing_zone_processing_lambda_csv_charset             = "UTF-8"
landing_zone_processing_skip_header                    = true
landing_zone_processing_lambda_violations_path         = "landing"


# Ingestion Pipeline
setup_ingestion_pipeline               = true
# Reload Pipeline
setup_reload_pipeline                  = true
# Replay Pipeline
setup_replay_pipeline                  = true

instances = {
  # Nomis Instance
  nomis-common = {
    setup                        = true
    replication_instance_class   = "dms.t3.large"
    replication_instance_version = "3.5.4"
    replication_instance_storage = 12
  }

  nomis-large-1 = {
    setup                        = true
    replication_instance_class   = "dms.t3.large"
    replication_instance_version = "3.5.4"
  }

  nomis-large-2 = {
    setup                        = true
    replication_instance_class   = "dms.t3.large"
    replication_instance_version = "3.5.4"
  }

  # DPS Instance
  dps-test-db = {
    setup                        = true
    replication_instance_class   = "dms.t3.large"
    replication_instance_version = "3.6.1"
  }

  dps-testing = {
    setup                        = true
    replication_instance_class   = "dms.t3.large"
    replication_instance_version = "3.6.1"
  }

  dps-testing2 = {
    setup                        = true
    replication_instance_class   = "dms.t3.large"
    replication_instance_version = "3.6.1"
  }

  dps-activities = {
    setup                        = true
    replication_instance_class   = "dms.t3.large"
    replication_instance_version = "3.6.1"
  }

  dps-case-notes = {
    setup                        = true
    replication_instance_class   = "dms.t3.large"
    replication_instance_version = "3.6.1"
  }

  dps-basm = {
    setup                        = true
    replication_instance_class   = "dms.t3.large"
    replication_instance_version = "3.6.1"
  }

  # DPS Incident Reporting
  dps-inc-reporting = {
    setup                        = true
    replication_instance_class   = "dms.t3.large"
    replication_instance_version = "3.6.1"
  }

  # DPS Challenge, Support and Intervention Plans
  dps-csip = {
    setup                        = true
    replication_instance_class   = "dms.t3.large"
    replication_instance_version = "3.6.1"
  }

  dps-alerts = {
    setup                        = true
    replication_instance_class   = "dms.t3.large"
    replication_instance_version = "3.6.1"
  }

  dps-locations = {
    setup                        = true
    replication_instance_class   = "dms.t3.large"
    replication_instance_version = "3.6.1"
  }

  # DPS Health and Medication API
  dps-health-and-me = {
    setup                        = true
    replication_instance_class   = "dms.t3.small"
    replication_instance_version = "3.6.1"
  }

  # DPS Match Jobs and Manage Applications
  dps-mj-and-ma = {
    setup                        = true
    replication_instance_class   = "dms.t3.small"
    replication_instance_version = "3.6.1"
  }

  # DPS Calculate Release Dates
  dps-calc-rel-date = {
    setup                        = true
    replication_instance_class   = "dms.t3.large"
    replication_instance_version = "3.6.1"
  }

  # DPS Prison Register
  dps-prison-reg = {
    setup                        = true
    replication_instance_class   = "dms.t3.large"
    replication_instance_version = "3.6.1"
  }

  # DPS Personal Relationships
  dps-personal-rela = {
    setup                        = true
    replication_instance_class   = "dms.t3.large"
    replication_instance_version = "3.6.1"
  }

  # DPS Organisations
  dps-organisations = {
    setup                        = true
    replication_instance_class   = "dms.t3.large"
    replication_instance_version = "3.6.1"
  }

  # DPS Allocations
  dps-allocations = {
    setup                        = true
    replication_instance_class   = "dms.t3.large"
    replication_instance_version = "3.6.1"
  }

  # DPS Manage POM Cases
  dps-manage-pom = {
    setup                        = true
    replication_instance_class   = "dms.t3.large"
    replication_instance_version = "3.6.1"
  }

  # DPS Support for Additional Needs
  dps-san = {
    setup                        = true
    replication_instance_class   = "dms.t3.large"
    replication_instance_version = "3.6.1"
  }
}

endpoints = {
  # Nomis Binary Reader Endpoint
  nomis = {
    setup                     = true,
    name_suffix               = "",
    setup_dms_iam             = true,
    setup_dms_source_endpoint = true,
    setup_dms_s3_endpoint     = true,
    dms_source_name           = "oracle",
    source_engine             = {
      type             = "oracle",
      extra_attributes = "supportResetlog=FALSE;archivedLogDestId=1;extraArchivedLogDestIds=[2];useBFile=Y;useLogminerReader=N",
      ssl_mode         = "none"
    }
    dms_target_name           = "s3",
    # short_name                = "nomis",
  }

  # Nomis LogMiner Endpoint
  clustered-tables = {
    setup                     = true,
    name_suffix               = "",
    setup_dms_iam             = true,
    setup_dms_source_endpoint = true,
    setup_dms_s3_endpoint     = true,
    dms_source_name           = "oracle",
    source_engine             = {
      type             = "oracle",
      extra_attributes = "supportResetlog=TRUE;useBFile=N;useLogminerReader=Y",
      ssl_mode         = "none"
    }
    dms_target_name           = "s3",
  }

  # DPS
  dps-test-db = {
    setup                     = true,
    name_suffix               = "",
    setup_dms_iam             = true,
    setup_dms_source_endpoint = true,
    setup_dms_s3_endpoint     = true,
    dms_source_name           = "pgres",
    source_engine             = {
      type              = "postgres",
      extra_attributes  = "",
      ssl_mode          = "require"
      heartbeat_enabled = true
    }
    dms_target_name           = "s3",
  }

  dps-testing = {
    setup                     = true,
    name_suffix               = "",
    setup_dms_iam             = true,
    setup_dms_source_endpoint = true,
    setup_dms_s3_endpoint     = true,
    dms_source_name           = "pgres",
    source_engine             = {
      type              = "postgres",
      extra_attributes  = "PluginName=test_decoding;slotName=dwh_replication_slot",
      ssl_mode          = "require"
      heartbeat_enabled = false
    }
    dms_target_name           = "s3",
  }

  dps-testing2 = {
    setup                     = true,
    name_suffix               = "",
    setup_dms_iam             = true,
    setup_dms_source_endpoint = true,
    setup_dms_s3_endpoint     = true,
    dms_source_name           = "pgres",
    source_engine             = {
      type              = "postgres",
      extra_attributes  = "",
      ssl_mode          = "require"
      heartbeat_enabled = true
    }
    dms_target_name           = "s3",
  }

  dps-activities = {
    setup                     = true,
    name_suffix               = "",
    setup_dms_iam             = true,
    setup_dms_source_endpoint = true,
    setup_dms_s3_endpoint     = true,
    dms_source_name           = "pgres",
    source_engine             = {
      type              = "postgres",
      extra_attributes  = "PluginName=test_decoding;slotName=dwh_replication_slot",
      ssl_mode          = "require"
      heartbeat_enabled = false
    }
    dms_target_name           = "s3",
  }

  dps-case-notes = {
    setup                     = true,
    name_suffix               = "",
    setup_dms_iam             = true,
    setup_dms_source_endpoint = true,
    setup_dms_s3_endpoint     = true,
    dms_source_name           = "pgres",
    source_engine             = {
      type              = "postgres",
      extra_attributes  = "",
      ssl_mode          = "require",
      heartbeat_enabled = true
    }
    dms_target_name           = "s3",
  }

  dps-basm = {
    setup                     = true,
    name_suffix               = "",
    setup_dms_iam             = true,
    setup_dms_source_endpoint = true,
    setup_dms_s3_endpoint     = true,
    dms_source_name           = "pgres",
    source_engine             = {
      type              = "postgres",
      extra_attributes  = "",
      ssl_mode          = "none"
      heartbeat_enabled = true
    }
    dms_target_name           = "s3",
  }

  # DPS Incident Reporting
  dps-inc-reporting = {
    setup                     = true,
    name_suffix               = "",
    setup_dms_iam             = true,
    setup_dms_source_endpoint = true,
    setup_dms_s3_endpoint     = true,
    dms_source_name           = "pgres",
    source_engine             = {
      type              = "postgres",
      extra_attributes  = "PluginName=test_decoding;slotName=dwh_replication_slot",
      ssl_mode          = "require"
      heartbeat_enabled = false
    }
    dms_target_name           = "s3",
  }

  # DPS Challenge, Support and Intervention Plans
  dps-csip = {
    setup                     = true,
    name_suffix               = "",
    setup_dms_iam             = true,
    setup_dms_source_endpoint = true,
    setup_dms_s3_endpoint     = true,
    dms_source_name           = "pgres",
    source_engine             = {
      type              = "postgres",
      extra_attributes  = "",
      ssl_mode          = "require"
      heartbeat_enabled = false
    }
    dms_target_name           = "s3",
  }

  dps-alerts = {
    setup                     = true,
    name_suffix               = "",
    setup_dms_iam             = true,
    setup_dms_source_endpoint = true,
    setup_dms_s3_endpoint     = true,
    dms_source_name           = "pgres",
    source_engine             = {
      type              = "postgres",
      extra_attributes  = "",
      ssl_mode          = "require"
      heartbeat_enabled = true
    }
    dms_target_name           = "s3",
  }

  dps-locations = {
    setup                     = true,
    name_suffix               = "",
    setup_dms_iam             = true,
    setup_dms_source_endpoint = true,
    setup_dms_s3_endpoint     = true,
    dms_source_name           = "pgres",
    source_engine             = {
      type              = "postgres",
      extra_attributes  = "",
      ssl_mode          = "require"
      heartbeat_enabled = true
    }
    dms_target_name           = "s3",
  }

  # DPS Health and Medication API
  dps-health-and-me = {
    setup                     = true,
    name_suffix               = "",
    setup_dms_iam             = true,
    setup_dms_source_endpoint = true,
    setup_dms_s3_endpoint     = true,
    dms_source_name           = "pgres",
    source_engine             = {
      type              = "postgres",
      extra_attributes  = "",
      ssl_mode          = "require"
      heartbeat_enabled = true
    }
    dms_target_name           = "s3",
  }

  # DPS Match Jobs and Manage Applications
  dps-mj-and-ma = {
    setup                     = true,
    name_suffix               = "",
    setup_dms_iam             = true,
    setup_dms_source_endpoint = true,
    setup_dms_s3_endpoint     = true,
    dms_source_name           = "pgres",
    source_engine             = {
      type              = "postgres",
      extra_attributes  = "",
      ssl_mode          = "require"
      heartbeat_enabled = true
    }
    dms_target_name           = "s3",
  }

  # DPS Calculate Release Dates
  dps-calc-rel-date = {
    setup                     = true,
    name_suffix               = "",
    setup_dms_iam             = true,
    setup_dms_source_endpoint = true,
    setup_dms_s3_endpoint     = true,
    dms_source_name           = "pgres",
    source_engine             = {
      type              = "postgres",
      extra_attributes  = "",
      ssl_mode          = "require"
      heartbeat_enabled = false
    }
    dms_target_name           = "s3",
  }

  # DPS Prison Register
  dps-prison-reg = {
    setup                     = true,
    name_suffix               = "",
    setup_dms_iam             = true,
    setup_dms_source_endpoint = true,
    setup_dms_s3_endpoint     = true,
    dms_source_name           = "pgres",
    source_engine             = {
      type              = "postgres",
      extra_attributes  = "",
      ssl_mode          = "require"
      heartbeat_enabled = true
    }
    dms_target_name           = "s3",
  }

  # DPS Personal Relationships
  dps-personal-rela = {
    setup                     = true,
    name_suffix               = "",
    setup_dms_iam             = true,
    setup_dms_source_endpoint = true,
    setup_dms_s3_endpoint     = true,
    dms_source_name           = "pgres",
    source_engine             = {
      type              = "postgres",
      extra_attributes  = "",
      ssl_mode          = "require"
      heartbeat_enabled = true
    }
    dms_target_name           = "s3",
  }

  # DPS Organisations
  dps-organisations = {
    setup                     = true,
    name_suffix               = "",
    setup_dms_iam             = true,
    setup_dms_source_endpoint = true,
    setup_dms_s3_endpoint     = true,
    dms_source_name           = "pgres",
    source_engine             = {
      type              = "postgres",
      extra_attributes  = "",
      ssl_mode          = "require"
      heartbeat_enabled = false
    }
    dms_target_name           = "s3",
  }

  # DPS Allocations
  dps-allocations = {
    setup                     = true,
    name_suffix               = "",
    setup_dms_iam             = true,
    setup_dms_source_endpoint = true,
    setup_dms_s3_endpoint     = true,
    dms_source_name           = "pgres",
    source_engine             = {
      type              = "postgres",
      extra_attributes  = "",
      ssl_mode          = "require"
      heartbeat_enabled = false
    }
    dms_target_name           = "s3",
  }

  # Manage POM Cases
  dps-manage-pom = {
    setup                     = true,
    name_suffix               = "",
    setup_dms_iam             = true,
    setup_dms_source_endpoint = true,
    setup_dms_s3_endpoint     = true,
    dms_source_name           = "pgres",
    source_engine             = {
      type              = "postgres",
      extra_attributes  = "PluginName=test_decoding;slotName=dwh_replication_slot",
      ssl_mode          = "require"
      heartbeat_enabled = false
    }
    dms_target_name           = "s3",
  }

  # DPS Support for Additional Needs
  dps-san = {
    setup                     = true,
    name_suffix               = "",
    setup_dms_iam             = true,
    setup_dms_source_endpoint = true,
    setup_dms_s3_endpoint     = true,
    dms_source_name           = "pgres",
    source_engine             = {
      type              = "postgres",
      extra_attributes  = "PluginName=test_decoding;slotName=dwh_replication_slot",
      ssl_mode          = "require"
      heartbeat_enabled = false
    }
    dms_target_name           = "s3",
  }
}

domains = {
  # PRISONER
  prisoner = {
    domain_type                 = "nomis"

    # DMS
    setup_rep_task              = true
    batch_only                  = true
    replication_instance_suffix = "common"
    name                        = "dwh-dms-nomis-oracle-s3-prisoner"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/prisoner/replication-settings.json"
    table_mappings              = "mappings/prisoner/table-mappings.json.tpl"
    rename_source_schema        = "OMS_OWNER"
    rename_output_space         = "nomis"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

    # Glue Jobs
    # CDC
    setup_cdc_job                       = false
    glue_cdc_create_role                = false
    glue_cdc_create_sec_conf            = false
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = false
    glue_archive_create_role            = false
    glue_archive_create_sec_conf        = false
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = false
    glue_unprocessed_raw_files_check_create_role     = false
    glue_unprocessed_raw_files_check_create_sec_conf = false
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # Ingestion Pipeline Trigger
    create_ingestion_pipeline_schedule          = true
    enable_ingestion_pipeline_schedule          = true
    ingestion_pipeline_cron_schedule_expression = "cron(30 16 ? * 7#1 *)"
  }

  # REFERENCE
  reference = {
    domain_type                 = "nomis"

    # DMS
    setup_rep_task              = true
    batch_only                  = true
    replication_instance_suffix = "common"
    name                        = "dwh-dms-nomis-oracle-s3-reference"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/reference/replication-settings.json"
    table_mappings              = "mappings/reference/table-mappings.json.tpl"
    rename_source_schema        = "OMS_OWNER"
    rename_output_space         = "nomis"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

    # Glue Jobs
    # CDC
    setup_cdc_job                       = false
    glue_cdc_create_role                = false
    glue_cdc_create_sec_conf            = false
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = false
    glue_archive_create_role            = false
    glue_archive_create_sec_conf        = false
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = false
    glue_unprocessed_raw_files_check_create_role     = false
    glue_unprocessed_raw_files_check_create_sec_conf = false
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # Ingestion Pipeline Trigger
    create_ingestion_pipeline_schedule          = true
    enable_ingestion_pipeline_schedule          = true
    ingestion_pipeline_cron_schedule_expression = "cron(0 7 ? * 7#1 *)"
  }

  # ESTABLISHMENTS
  establishments = {
    domain_type                 = "nomis"

    # DMS
    setup_rep_task              = true
    batch_only                  = true
    replication_instance_suffix = "common"
    name                        = "dwh-dms-nomis-oracle-s3-establishments"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/establishments/replication-settings.json"
    table_mappings              = "mappings/establishments/table-mappings.json.tpl"
    rename_source_schema        = "OMS_OWNER"
    rename_output_space         = "nomis"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

    # Glue Jobs
    # CDC
    setup_cdc_job                       = false
    glue_cdc_create_role                = false
    glue_cdc_create_sec_conf            = false
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = false
    glue_archive_create_role            = false
    glue_archive_create_sec_conf        = false
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = false
    glue_unprocessed_raw_files_check_create_role     = false
    glue_unprocessed_raw_files_check_create_sec_conf = false
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # Ingestion Pipeline Trigger
    create_ingestion_pipeline_schedule          = true
    enable_ingestion_pipeline_schedule          = true
    ingestion_pipeline_cron_schedule_expression = "cron(0 19 ? * 7#1 *)"
  }

  # SENTENCE
  sentence = {
    domain_type                 = "nomis"

    # DMS
    setup_rep_task              = true
    batch_only                  = true
    replication_instance_suffix = "common"
    name                        = "dwh-dms-nomis-oracle-s3-sentence"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/sentence/replication-settings.json"
    table_mappings              = "mappings/sentence/table-mappings.json.tpl"
    rename_source_schema        = "OMS_OWNER"
    rename_output_space         = "nomis"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

    # Glue Jobs
    # CDC
    setup_cdc_job                       = false
    glue_cdc_create_role                = false
    glue_cdc_create_sec_conf            = false
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = false
    glue_archive_create_role            = false
    glue_archive_create_sec_conf        = false
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = false
    glue_unprocessed_raw_files_check_create_role     = false
    glue_unprocessed_raw_files_check_create_sec_conf = false
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # Ingestion Pipeline Trigger
    create_ingestion_pipeline_schedule          = true
    enable_ingestion_pipeline_schedule          = true
    ingestion_pipeline_cron_schedule_expression = "cron(0 6 ? * 5#1 *)"
  }

  # VISITS
  visits = {
    domain_type                 = "nomis"

    # DMS
    setup_rep_task              = true
    batch_only                  = true
    replication_instance_suffix = "common"
    name                        = "dwh-dms-nomis-oracle-s3-visits"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/visits/replication-settings.json"
    table_mappings              = "mappings/visits/table-mappings.json.tpl"
    rename_source_schema        = "OMS_OWNER"
    rename_output_space         = "nomis"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

    # Glue Jobs
    # CDC
    setup_cdc_job                       = false
    glue_cdc_create_role                = false
    glue_cdc_create_sec_conf            = false
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = false
    glue_archive_create_role            = false
    glue_archive_create_sec_conf        = false
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = false
    glue_unprocessed_raw_files_check_create_role     = false
    glue_unprocessed_raw_files_check_create_sec_conf = false
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # Ingestion Pipeline Trigger
    create_ingestion_pipeline_schedule          = true
    enable_ingestion_pipeline_schedule          = true
    ingestion_pipeline_cron_schedule_expression = "cron(30 4 ? * 3#1 *)"
  }

  # MOVEMENTS
  movements = {
    domain_type                 = "nomis"

    # DMS
    setup_rep_task              = true
    batch_only                  = true
    replication_instance_suffix = "common"
    name                        = "dwh-dms-nomis-oracle-s3-movements"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/movements/replication-settings.json"
    table_mappings              = "mappings/movements/table-mappings.json.tpl"
    rename_source_schema        = "OMS_OWNER"
    rename_output_space         = "nomis"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

    # Glue Jobs
    # CDC
    setup_cdc_job                       = false
    glue_cdc_create_role                = false
    glue_cdc_create_sec_conf            = false
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = false
    glue_archive_create_role            = false
    glue_archive_create_sec_conf        = false
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = false
    glue_unprocessed_raw_files_check_create_role     = false
    glue_unprocessed_raw_files_check_create_sec_conf = false
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # Ingestion Pipeline Trigger
    create_ingestion_pipeline_schedule          = true
    enable_ingestion_pipeline_schedule          = true
    ingestion_pipeline_cron_schedule_expression = "cron(0 6 ? * 7#1 *)"
  }

  # ADJUDICATIONS
  adjudications = {
    domain_type                 = "nomis"

    # DMS
    setup_rep_task              = true
    batch_only                  = true
    replication_instance_suffix = "common"
    name                        = "dwh-dms-nomis-oracle-s3-adjudications"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/adjudications/replication-settings.json"
    table_mappings              = "mappings/adjudications/table-mappings.json.tpl"
    rename_source_schema        = "OMS_OWNER"
    rename_output_space         = "nomis"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

    # Glue Jobs
    # CDC
    setup_cdc_job                       = false
    glue_cdc_create_role                = false
    glue_cdc_create_sec_conf            = false
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = false
    glue_archive_create_role            = false
    glue_archive_create_sec_conf        = false
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = false
    glue_unprocessed_raw_files_check_create_role     = false
    glue_unprocessed_raw_files_check_create_sec_conf = false
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # Ingestion Pipeline Trigger
    create_ingestion_pipeline_schedule          = true
    enable_ingestion_pipeline_schedule          = true
    ingestion_pipeline_cron_schedule_expression = "cron(0 6 ? * 3#1 *)"
  }

  # ACTIVITIES-SCHEDULES
  activity-sch = {
    domain_type                 = "nomis"

    # DMS
    setup_rep_task              = true
    batch_only                  = true
    replication_instance_suffix = "common"
    name                        = "dwh-dms-nomis-oracle-s3-activity-sch"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/activity-sch/replication-settings.json"
    table_mappings              = "mappings/activity-sch/table-mappings.json.tpl"
    rename_source_schema        = "OMS_OWNER"
    rename_output_space         = "nomis"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

    # Glue Jobs
    # CDC
    setup_cdc_job                       = false
    glue_cdc_create_role                = false
    glue_cdc_create_sec_conf            = false
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = false
    glue_archive_create_role            = false
    glue_archive_create_sec_conf        = false
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = false
    glue_unprocessed_raw_files_check_create_role     = false
    glue_unprocessed_raw_files_check_create_sec_conf = false
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # Ingestion Pipeline Trigger
    create_ingestion_pipeline_schedule          = true
    enable_ingestion_pipeline_schedule          = true
    ingestion_pipeline_cron_schedule_expression = "cron(30 4 ? * 4#1 *)"
  }

  # PRISONER-PROFILE (16)
  prisoner-profile = {
    domain_type                 = "nomis"

    # DMS
    setup_rep_task              = true
    batch_only                  = true
    replication_instance_suffix = "common"
    name                        = "dwh-dms-nomis-oracle-s3-prisoner-profile"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/prisoner-profile/replication-settings.json"
    table_mappings              = "mappings/prisoner-profile/table-mappings.json.tpl"
    rename_source_schema        = "OMS_OWNER"
    rename_output_space         = "nomis"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

    # Glue Jobs
    # CDC
    setup_cdc_job                       = false
    glue_cdc_create_role                = false
    glue_cdc_create_sec_conf            = false
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = false
    glue_archive_create_role            = false
    glue_archive_create_sec_conf        = false
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = false
    glue_unprocessed_raw_files_check_create_role     = false
    glue_unprocessed_raw_files_check_create_sec_conf = false
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # Ingestion Pipeline Trigger
    create_ingestion_pipeline_schedule          = true
    enable_ingestion_pipeline_schedule          = true
    ingestion_pipeline_cron_schedule_expression = "cron(0 7 ? * 3#1 *)"
  }


  # COURSE-ATTENDANCE (10)
  course-attendance = {
    domain_type                 = "nomis"

    # DMS
    setup_rep_task              = true
    batch_only                  = true
    replication_instance_suffix = "large-1"
    name                        = "dwh-dms-nomis-oracle-s3-course-attendance"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/course-attendance/replication-settings.json"
    table_mappings              = "mappings/course-attendance/table-mappings.json.tpl"
    rename_source_schema        = "OMS_OWNER"
    rename_output_space         = "nomis"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

    # Glue Jobs
    # CDC
    setup_cdc_job                       = false
    glue_cdc_create_role                = false
    glue_cdc_create_sec_conf            = false
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    glue_batch_job_worker_type_override = "G.2X"
    # Overrides
    glue_batch_job_num_workers_override = 16
    # Archive
    setup_archive_job                   = false
    glue_archive_create_role            = false
    glue_archive_create_sec_conf        = false
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = false
    glue_unprocessed_raw_files_check_create_role     = false
    glue_unprocessed_raw_files_check_create_sec_conf = false
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.2X"
    glue_create_reload_diff_job_num_workers_override = 9
    ingestion_compaction_structured_num_workers = 10
    reload_compaction_structured_num_workers    = 10
    replay_compaction_structured_num_workers    = 10
    ingestion_compaction_curated_num_workers    = 10
    reload_compaction_curated_num_workers       = 10
    replay_compaction_curated_num_workers       = 10
    # Ingestion Pipeline Trigger
    create_ingestion_pipeline_schedule          = true
    enable_ingestion_pipeline_schedule          = true
    ingestion_pipeline_cron_schedule_expression = "cron(30 16 ? * 6#1 *)"
  }

  # PROGRAM-PROFILES
  program-profiles = {
    domain_type                 = "nomis"

    # DMS
    setup_rep_task              = true
    batch_only                  = true
    replication_instance_suffix = "common"
    name                        = "dwh-dms-nomis-oracle-s3-program-profiles"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/program-profiles/replication-settings.json"
    table_mappings              = "mappings/program-profiles/table-mappings.json.tpl"
    rename_source_schema        = "OMS_OWNER"
    rename_output_space         = "nomis"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

    # Glue Jobs
    # CDC
    setup_cdc_job                       = false
    glue_cdc_create_role                = false
    glue_cdc_create_sec_conf            = false
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = false
    glue_archive_create_role            = false
    glue_archive_create_sec_conf        = false
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = false
    glue_unprocessed_raw_files_check_create_role     = false
    glue_unprocessed_raw_files_check_create_sec_conf = false
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # Ingestion Pipeline Trigger
    create_ingestion_pipeline_schedule          = true
    enable_ingestion_pipeline_schedule          = true
    ingestion_pipeline_cron_schedule_expression = "cron(30 4 ? * 6#1 *)"
  }


  # INCIDENTS (9)
  incidents = {
    domain_type                 = "nomis"

    # DMS
    setup_rep_task              = true
    batch_only                  = true
    replication_instance_suffix = "common"
    name                        = "dwh-dms-nomis-oracle-s3-incidents"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/incidents/replication-settings.json"
    table_mappings              = "mappings/incidents/table-mappings.json.tpl"
    rename_source_schema        = "OMS_OWNER"
    rename_output_space         = "nomis"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

    # Glue Jobs
    # CDC
    setup_cdc_job                       = false
    glue_cdc_create_role                = false
    glue_cdc_create_sec_conf            = false
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = false
    glue_archive_create_role            = false
    glue_archive_create_sec_conf        = false
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = false
    glue_unprocessed_raw_files_check_create_role     = false
    glue_unprocessed_raw_files_check_create_sec_conf = false
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # Ingestion Pipeline Trigger
    create_ingestion_pipeline_schedule          = true
    enable_ingestion_pipeline_schedule          = true
    ingestion_pipeline_cron_schedule_expression = "cron(0 18 ? * 7#1 *)"
  }

  # PERSON (6)
  person = {
    domain_type                 = "nomis"

    # DMS
    setup_rep_task              = true
    batch_only                  = true
    replication_instance_suffix = "common"
    name                        = "dwh-dms-nomis-oracle-s3-person"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/person/replication-settings.json"
    table_mappings              = "mappings/person/table-mappings.json.tpl"
    rename_source_schema        = "OMS_OWNER"
    rename_output_space         = "nomis"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

    # Glue Jobs
    # CDC
    setup_cdc_job                       = false
    glue_cdc_create_role                = false
    glue_cdc_create_sec_conf            = false
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = false
    glue_archive_create_role            = false
    glue_archive_create_sec_conf        = false
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = false
    glue_unprocessed_raw_files_check_create_role     = false
    glue_unprocessed_raw_files_check_create_sec_conf = false
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # Ingestion Pipeline Trigger
    create_ingestion_pipeline_schedule          = true
    enable_ingestion_pipeline_schedule          = true
    ingestion_pipeline_cron_schedule_expression = "cron(30 4 ? * 7#1 *)"
  }

  # PRISONER-ADDRESS (16)
    prisoner-address = {
    domain_type                 = "nomis"

      # DMS
      setup_rep_task              = true
      batch_only                  = true
      replication_instance_suffix = "common"
      name                        = "dwh-dms-nomis-oracle-s3-prisoner-address"
      migration_type              = "full-load-and-cdc"
      replication_task_settings   = "mappings/prisoner-address/replication-settings.json"
      table_mappings              = "mappings/prisoner-address/table-mappings.json.tpl"
      rename_source_schema        = "OMS_OWNER"
      rename_output_space         = "nomis"
      vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
      cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

      # Glue Jobs
      # CDC
      setup_cdc_job                       = false
      glue_cdc_create_role                = false
      glue_cdc_create_sec_conf            = false
      # Batch
      setup_batch_job                     = true
      glue_batch_create_role              = true
      glue_batch_create_sec_conf          = true
      # Overrides
      glue_batch_job_num_workers_override = 2
      # Archive
      setup_archive_job                   = false
      glue_archive_create_role            = false
      glue_archive_create_sec_conf        = false
      # Unprocessed Raw Files Check Job
      setup_unprocessed_raw_files_check_job            = false
      glue_unprocessed_raw_files_check_create_role     = false
      glue_unprocessed_raw_files_check_create_sec_conf = false
      # Create Reload Diff Job
      setup_create_reload_diff_job                     = true
      glue_create_reload_diff_job_role                 = true
      glue_create_reload_diff_job_create_sec_conf      = true
      glue_create_reload_diff_job_worker_type          = "G.1X"
      glue_create_reload_diff_job_num_workers_override = 2
      # Ingestion Pipeline Trigger
      create_ingestion_pipeline_schedule          = true
      enable_ingestion_pipeline_schedule          = true
      ingestion_pipeline_cron_schedule_expression = "cron(30 16 ? * 5#1 *)"
    }

  # PRISONER-ED (16)
  prisoner-ed = {
    domain_type                 = "nomis"

    # DMS
    setup_rep_task              = true
    batch_only                  = true
    replication_instance_suffix = "common"
    name                        = "dwh-dms-nomis-oracle-s3-prisoner-ed"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/prisoner-ed/replication-settings.json"
    table_mappings              = "mappings/prisoner-ed/table-mappings.json.tpl"
    rename_source_schema        = "OMS_OWNER"
    rename_output_space         = "nomis"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

    # Glue Jobs
    # CDC
    setup_cdc_job                       = false
    glue_cdc_create_role                = false
    glue_cdc_create_sec_conf            = false
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = false
    glue_archive_create_role            = false
    glue_archive_create_sec_conf        = false
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = false
    glue_unprocessed_raw_files_check_create_role     = false
    glue_unprocessed_raw_files_check_create_sec_conf = false
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # Ingestion Pipeline Trigger
    create_ingestion_pipeline_schedule          = true
    enable_ingestion_pipeline_schedule          = true
    ingestion_pipeline_cron_schedule_expression = "cron(0 18 ? * 4#1 *)"
  }

  # CASE-NOTES
  case-notes = {
    domain_type                 = "nomis"

    # DMS
    setup_rep_task              = true
    batch_only                  = true
    replication_instance_suffix = "common"
    name                        = "dwh-dms-nomis-oracle-s3-case-notes"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/case-notes/replication-settings.json"
    table_mappings              = "mappings/case-notes/table-mappings.json.tpl"
    rename_source_schema        = "OMS_OWNER"
    rename_output_space         = "nomis"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

    # Glue Jobs
    # CDC
    setup_cdc_job                       = false
    glue_cdc_create_role                = false
    glue_cdc_create_sec_conf            = false
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = false
    glue_archive_create_role            = false
    glue_archive_create_sec_conf        = false
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = false
    glue_unprocessed_raw_files_check_create_role     = false
    glue_unprocessed_raw_files_check_create_sec_conf = false
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # Ingestion Pipeline Trigger
    create_ingestion_pipeline_schedule          = true
    enable_ingestion_pipeline_schedule          = true
    ingestion_pipeline_cron_schedule_expression = "cron(30 4 ? * 5#1 *)"
  }

  # CASELOADS
  caseloads = {
    domain_type                 = "nomis"

    # DMS
    setup_rep_task              = true
    batch_only                  = true
    replication_instance_suffix = "common"
    name                        = "dwh-dms-nomis-oracle-s3-caseloads"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/caseloads/replication-settings.json"
    table_mappings              = "mappings/caseloads/table-mappings.json.tpl"
    rename_source_schema        = "OMS_OWNER"
    rename_output_space         = "nomis"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

    # Glue Jobs
    # CDC
    setup_cdc_job                       = false
    glue_cdc_create_role                = false
    glue_cdc_create_sec_conf            = false
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = false
    glue_archive_create_role            = false
    glue_archive_create_sec_conf        = false
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = false
    glue_unprocessed_raw_files_check_create_role     = false
    glue_unprocessed_raw_files_check_create_sec_conf = false
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # Ingestion Pipeline Trigger
    create_ingestion_pipeline_schedule          = true
    enable_ingestion_pipeline_schedule          = true
    ingestion_pipeline_cron_schedule_expression = "cron(0 18 ? * 3#1 *)"
  }

  # CASES
  cases = {
    domain_type                 = "nomis"

    # DMS
    setup_rep_task              = true
    batch_only                  = true
    replication_instance_suffix = "common"
    name                        = "dwh-dms-nomis-oracle-s3-cases"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/cases/replication-settings.json"
    table_mappings              = "mappings/cases/table-mappings.json.tpl"
    rename_source_schema        = "OMS_OWNER"
    rename_output_space         = "nomis"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

    # Glue Jobs
    # CDC
    setup_cdc_job                       = false
    glue_cdc_create_role                = false
    glue_cdc_create_sec_conf            = false
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = false
    glue_archive_create_role            = false
    glue_archive_create_sec_conf        = false
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = false
    glue_unprocessed_raw_files_check_create_role     = false
    glue_unprocessed_raw_files_check_create_sec_conf = false
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # Ingestion Pipeline Trigger
    create_ingestion_pipeline_schedule          = true
    enable_ingestion_pipeline_schedule          = true
    ingestion_pipeline_cron_schedule_expression = "cron(0 19 ? * 4#1 *)"
  }

  # FINANCE-TXNS
  finance-txns = {
    domain_type                 = "nomis"

    # DMS
    setup_rep_task              = true
    batch_only                  = true
    replication_instance_suffix = "large-2"
    name                        = "dwh-dms-nomis-oracle-s3-finance-txns"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/finance-txns/replication-settings.json"
    table_mappings              = "mappings/finance-txns/table-mappings.json.tpl"
    rename_source_schema        = "OMS_OWNER"
    rename_output_space         = "nomis"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

    # Glue Jobs
    # CDC
    setup_cdc_job                       = false
    glue_cdc_create_role                = false
    glue_cdc_create_sec_conf            = false
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    glue_batch_job_worker_type_override = "G.2X"
    # Overrides
    glue_batch_job_num_workers_override = 16
    # Archive
    setup_archive_job                   = false
    glue_archive_create_role            = false
    glue_archive_create_sec_conf        = false
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = false
    glue_unprocessed_raw_files_check_create_role     = false
    glue_unprocessed_raw_files_check_create_sec_conf = false
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.2X"
    glue_create_reload_diff_job_num_workers_override = 9

    ingestion_compaction_structured_num_workers = 10
    reload_compaction_structured_num_workers    = 10
    replay_compaction_structured_num_workers    = 10
    ingestion_compaction_curated_num_workers    = 10
    reload_compaction_curated_num_workers       = 10
    replay_compaction_curated_num_workers       = 10
    # Ingestion Pipeline Trigger
    create_ingestion_pipeline_schedule          = true
    enable_ingestion_pipeline_schedule          = true
    ingestion_pipeline_cron_schedule_expression = "cron(30 16 ? * 2#1 *)"
  }

  # ADJUSTMENT-TXNS
  adjustment-txns = {
    domain_type                 = "nomis"

    # DMS
    setup_rep_task              = true
    batch_only                  = true
    replication_instance_suffix = "common"
    name                        = "dwh-dms-nomis-oracle-s3-adjustment-txns"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/adjustment-txns/replication-settings.json"
    table_mappings              = "mappings/adjustment-txns/table-mappings.json.tpl"
    rename_source_schema        = "OMS_OWNER"
    rename_output_space         = "nomis"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

    # Glue Jobs
    # CDC
    setup_cdc_job                       = false
    glue_cdc_create_role                = false
    glue_cdc_create_sec_conf            = false
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = false
    glue_archive_create_role            = false
    glue_archive_create_sec_conf        = false
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = false
    glue_unprocessed_raw_files_check_create_role     = false
    glue_unprocessed_raw_files_check_create_sec_conf = false
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # Ingestion Pipeline Trigger
    create_ingestion_pipeline_schedule          = true
    enable_ingestion_pipeline_schedule          = true
    ingestion_pipeline_cron_schedule_expression = "cron(30 4 ? * 2#1 *)"
  }

  # GANGS
  gangs = {
    domain_type                 = "nomis"

    # DMS
    setup_rep_task              = true
    batch_only                  = true
    replication_instance_suffix = "common"
    name                        = "dwh-dms-nomis-oracle-s3-gangs"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/gangs/replication-settings.json"
    table_mappings              = "mappings/gangs/table-mappings.json.tpl"
    rename_source_schema        = "OMS_OWNER"
    rename_output_space         = "nomis"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

    # Glue Jobs
    # CDC
    setup_cdc_job                       = false
    glue_cdc_create_role                = false
    glue_cdc_create_sec_conf            = false
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = false
    glue_archive_create_role            = false
    glue_archive_create_sec_conf        = false
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = false
    glue_unprocessed_raw_files_check_create_role     = false
    glue_unprocessed_raw_files_check_create_sec_conf = false
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # Ingestion Pipeline Trigger
    create_ingestion_pipeline_schedule          = true
    enable_ingestion_pipeline_schedule          = true
    ingestion_pipeline_cron_schedule_expression = "cron(0 18 ? * 5#1 *)"
  }

  # HDC
  hdc = {
    domain_type                 = "nomis"

    # DMS
    setup_rep_task              = true
    batch_only                  = true
    replication_instance_suffix = "common"
    name                        = "dwh-dms-nomis-oracle-s3-hdc"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/hdc/replication-settings.json"
    table_mappings              = "mappings/hdc/table-mappings.json.tpl"
    rename_source_schema        = "OMS_OWNER"
    rename_output_space         = "nomis"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

    # Glue Jobs
    # CDC
    setup_cdc_job                       = false
    glue_cdc_create_role                = false
    glue_cdc_create_sec_conf            = false
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = false
    glue_archive_create_role            = false
    glue_archive_create_sec_conf        = false
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = false
    glue_unprocessed_raw_files_check_create_role     = false
    glue_unprocessed_raw_files_check_create_sec_conf = false
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # Ingestion Pipeline Trigger
    create_ingestion_pipeline_schedule          = true
    enable_ingestion_pipeline_schedule          = true
    ingestion_pipeline_cron_schedule_expression = "cron(0 6 ? * 4#1 *)"
  }

  # NON-ASSOCIATIONS
  non-associations = {
    domain_type                 = "nomis"

    # DMS
    setup_rep_task              = true
    batch_only                  = true
    replication_instance_suffix = "common"
    name                        = "dwh-dms-nomis-oracle-s3-non-associations"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/non-associations/replication-settings.json"
    table_mappings              = "mappings/non-associations/table-mappings.json.tpl"
    rename_source_schema        = "OMS_OWNER"
    rename_output_space         = "nomis"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

    # Glue Jobs
    # CDC
    setup_cdc_job                       = false
    glue_cdc_create_role                = false
    glue_cdc_create_sec_conf            = false
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = false
    glue_archive_create_role            = false
    glue_archive_create_sec_conf        = false
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = false
    glue_unprocessed_raw_files_check_create_role     = false
    glue_unprocessed_raw_files_check_create_sec_conf = false
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # Ingestion Pipeline Trigger
    create_ingestion_pipeline_schedule          = true
    enable_ingestion_pipeline_schedule          = true
    ingestion_pipeline_cron_schedule_expression = "cron(30 16 ? * 3#1 *)"
  }

  # ORDERS
  orders = {
    domain_type                 = "nomis"

    # DMS
    setup_rep_task              = true
    batch_only                  = true
    replication_instance_suffix = "common"
    name                        = "dwh-dms-nomis-oracle-s3-orders"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/orders/replication-settings.json"
    table_mappings              = "mappings/orders/table-mappings.json.tpl"
    rename_source_schema        = "OMS_OWNER"
    rename_output_space         = "nomis"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

    # Glue Jobs
    # CDC
    setup_cdc_job                       = false
    glue_cdc_create_role                = false
    glue_cdc_create_sec_conf            = false
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = false
    glue_archive_create_role            = false
    glue_archive_create_sec_conf        = false
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = false
    glue_unprocessed_raw_files_check_create_role     = false
    glue_unprocessed_raw_files_check_create_sec_conf = false
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # Ingestion Pipeline Trigger
    create_ingestion_pipeline_schedule          = true
    enable_ingestion_pipeline_schedule          = true
    ingestion_pipeline_cron_schedule_expression = "cron(0 7 ? * 4#1 *)"
  }

  # PRISONER-HEALTH
  prisoner-health = {
    domain_type                 = "nomis"

    # DMS
    setup_rep_task              = true
    batch_only                  = true
    replication_instance_suffix = "common"
    name                        = "dwh-dms-nomis-oracle-s3-prisoner-health"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/prisoner-health/replication-settings.json"
    table_mappings              = "mappings/prisoner-health/table-mappings.json.tpl"
    rename_source_schema        = "OMS_OWNER"
    rename_output_space         = "nomis"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

    # Glue Jobs
    # CDC
    setup_cdc_job                       = false
    glue_cdc_create_role                = false
    glue_cdc_create_sec_conf            = false
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = false
    glue_archive_create_role            = false
    glue_archive_create_sec_conf        = false
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = false
    glue_unprocessed_raw_files_check_create_role     = false
    glue_unprocessed_raw_files_check_create_sec_conf = false
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # Ingestion Pipeline Trigger
    create_ingestion_pipeline_schedule          = true
    enable_ingestion_pipeline_schedule          = true
    ingestion_pipeline_cron_schedule_expression = "cron(0 7 ? * 5#1 *)"
  }

  # QUESTIONNAIRE
  questionnaire = {
    domain_type                 = "nomis"

    # DMS
    setup_rep_task              = true
    batch_only                  = true
    replication_instance_suffix = "common"
    name                        = "dwh-dms-nomis-oracle-s3-questionnaire"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/questionnaire/replication-settings.json"
    table_mappings              = "mappings/questionnaire/table-mappings.json.tpl"
    rename_source_schema        = "OMS_OWNER"
    rename_output_space         = "nomis"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

    # Glue Jobs
    # CDC
    setup_cdc_job                       = false
    glue_cdc_create_role                = false
    glue_cdc_create_sec_conf            = false
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = false
    glue_archive_create_role            = false
    glue_archive_create_sec_conf        = false
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = false
    glue_unprocessed_raw_files_check_create_role     = false
    glue_unprocessed_raw_files_check_create_sec_conf = false
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # Ingestion Pipeline Trigger
    create_ingestion_pipeline_schedule          = true
    enable_ingestion_pipeline_schedule          = true
    ingestion_pipeline_cron_schedule_expression = "cron(0 19 ? * 3#1 *)"
  }

  # SAFETY
  safety = {
    domain_type                 = "nomis"

    # DMS
    setup_rep_task              = true
    batch_only                  = true
    replication_instance_suffix = "common"
    name                        = "dwh-dms-nomis-oracle-s3-safety"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/safety/replication-settings.json"
    table_mappings              = "mappings/safety/table-mappings.json.tpl"
    rename_source_schema        = "OMS_OWNER"
    rename_output_space         = "nomis"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

    # Glue Jobs
    # CDC
    setup_cdc_job                       = false
    glue_cdc_create_role                = false
    glue_cdc_create_sec_conf            = false
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = false
    glue_archive_create_role            = false
    glue_archive_create_sec_conf        = false
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = false
    glue_unprocessed_raw_files_check_create_role     = false
    glue_unprocessed_raw_files_check_create_sec_conf = false
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # Ingestion Pipeline Trigger
    create_ingestion_pipeline_schedule          = true
    enable_ingestion_pipeline_schedule          = true
    ingestion_pipeline_cron_schedule_expression = "cron(0 19 ? * 5#1 *)"
  }

  # TRANSACTIONS
  transactions = {
    domain_type                 = "nomis"

    # DMS
    setup_rep_task              = true
    batch_only                  = true
    replication_instance_suffix = "common"
    name                        = "dwh-dms-nomis-oracle-s3-transactions"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/transactions/replication-settings.json"
    table_mappings              = "mappings/transactions/table-mappings.json.tpl"
    rename_source_schema        = "OMS_OWNER"
    rename_output_space         = "nomis"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

    # Glue Jobs
    # CDC
    setup_cdc_job                       = false
    glue_cdc_create_role                = false
    glue_cdc_create_sec_conf            = false
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = false
    glue_archive_create_role            = false
    glue_archive_create_sec_conf        = false
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = false
    glue_unprocessed_raw_files_check_create_role     = false
    glue_unprocessed_raw_files_check_create_sec_conf = false
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # Ingestion Pipeline Trigger
    create_ingestion_pipeline_schedule          = true
    enable_ingestion_pipeline_schedule          = true
    ingestion_pipeline_cron_schedule_expression = "cron(30 16 ? * 4#1 *)"
  }

  # NOMIS CLUSTERED TABLES
  # These tables belong to an Oracle table cluster and require LogMiner for CDC ingestion
  clustered-tables = {
    domain_type                 = "nomis"

    # DMS
    setup_rep_task              = true
    batch_only                  = true
    replication_instance_suffix = "common"
    name                        = "dwh-dms-nomis-oracle-s3-clustered-tables"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/clustered-tables/replication-settings.json"
    table_mappings              = "mappings/clustered-tables/table-mappings.json.tpl"
    rename_source_schema        = "OMS_OWNER"
    rename_output_space         = "nomis"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

    # Glue Jobs
    # CDC
    setup_cdc_job                       = false
    glue_cdc_create_role                = false
    glue_cdc_create_sec_conf            = false
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = false
    glue_archive_create_role            = false
    glue_archive_create_sec_conf        = false
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = false
    glue_unprocessed_raw_files_check_create_role     = false
    glue_unprocessed_raw_files_check_create_sec_conf = false
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.2X"
    glue_create_reload_diff_job_num_workers_override = 3
    # Ingestion Pipeline Trigger
    create_ingestion_pipeline_schedule          = true
    enable_ingestion_pipeline_schedule          = true
    ingestion_pipeline_cron_schedule_expression = "cron(30 16 ? * 4#1 *)"
  }

  # DPS Service
  # DPS TESTING DOMAIN
  dps-testing = {
    # To remove this domain you will need to detach the DMS
    # security group from the dps-test-db first
    domain_type                 = "dps"

    # DMS
    setup_rep_task              = true
    replication_instance_suffix = "testing"
    name                        = "dwh-dms-dps-testing-pgres-s3-dps"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/dps-testing/replication-settings.json"
    table_mappings              = "mappings/dps-testing/table-mappings.json.tpl"
    rename_source_schema        = "public"
    rename_output_space         = "testing"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"
    # Postgres Tickle
    create_postgres_tickle_schedule = true
    enable_postgres_tickle_schedule = true

    # Glue Jobs
    # CDC
    setup_cdc_job                       = true
    glue_cdc_create_role                = true
    glue_cdc_create_sec_conf            = true
    # Overrides
    glue_cdc_job_worker_type_override   = "G.025X"
    glue_cdc_job_num_workers_override   = 2
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = true
    glue_archive_create_role            = true
    glue_archive_create_sec_conf        = true
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = true
    glue_unprocessed_raw_files_check_create_role     = true
    glue_unprocessed_raw_files_check_create_sec_conf = true
    # Create Archive Backfill Diff Job
    enable_archive_backfill                          = true
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # CDC Pipeline Trigger
    setup_start_cdc_pipeline = true
    setup_stop_cdc_pipeline  = true
    # Maintenance
    setup_maintenance_pipeline = true

    replay_pipeline_processed_files_check_wait_interval_seconds = 900
    replay_pipeline_processed_files_check_max_attempts          = 8
  }

  # DPS TESTING 2 DOMAIN
  dps-testing2 = {
    # To remove this domain you will need to detach the DMS
    # security group from the dps-test-db2 first
    domain_type                 = "dps"

    # DMS
    setup_rep_task              = true
    replication_instance_suffix = "testing2"
    name                        = "dwh-dms-dps-testing2-pgres-s3-dps"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/dps-testing2/replication-settings.json"
    table_mappings              = "mappings/dps-testing2/table-mappings.json.tpl"
    rename_source_schema        = "public"
    rename_output_space         = "testing2"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"
    # Postgres Tickle
    create_postgres_tickle_schedule = true
    enable_postgres_tickle_schedule = true

    # Glue Jobs
    # CDC
    setup_cdc_job                       = true
    glue_cdc_create_role                = true
    glue_cdc_create_sec_conf            = true
    # Overrides
    glue_cdc_job_worker_type_override   = "G.025X"
    glue_cdc_job_num_workers_override   = 2
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = true
    glue_archive_create_role            = true
    glue_archive_create_sec_conf        = true
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = true
    glue_unprocessed_raw_files_check_create_role     = true
    glue_unprocessed_raw_files_check_create_sec_conf = true
    # Create Archive Backfill Diff Job
    enable_archive_backfill                          = true
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # CDC Pipeline Trigger
    setup_start_cdc_pipeline = true
    setup_stop_cdc_pipeline  = true
    # Maintenance
    setup_maintenance_pipeline = true

    replay_pipeline_processed_files_check_wait_interval_seconds = 900
    replay_pipeline_processed_files_check_max_attempts          = 8
  }

  # DPS ACTIVITIES
  dps-activities = {
    domain_type                 = "dps"

    # DMS
    setup_rep_task              = true
    replication_instance_suffix = "activities"
    name                        = "dwh-dms-dps-activities-pgres-s3-dps"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/dps-activities/replication-settings.json"
    table_mappings              = "mappings/dps-activities/table-mappings.json.tpl"
    rename_source_schema        = "public"
    rename_output_space         = "activities"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"
    # Postgres Tickle
    create_postgres_tickle_schedule = true
    enable_postgres_tickle_schedule = true

    # Glue Jobs
    # CDC
    setup_cdc_job                       = true
    glue_cdc_create_role                = true
    glue_cdc_create_sec_conf            = true
    # Overrides
    glue_cdc_job_worker_type_override   = "G.025X"
    glue_cdc_job_num_workers_override   = 2
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = true
    glue_archive_create_role            = true
    glue_archive_create_sec_conf        = true
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = true
    glue_unprocessed_raw_files_check_create_role     = true
    glue_unprocessed_raw_files_check_create_sec_conf = true
    # Create Archive Backfill Diff Job
    enable_archive_backfill                          = true
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # CDC Pipeline Trigger
    setup_start_cdc_pipeline = true
    setup_stop_cdc_pipeline  = true
    # Maintenance
    setup_maintenance_pipeline = true

    replay_pipeline_processed_files_check_wait_interval_seconds = 900
    replay_pipeline_processed_files_check_max_attempts          = 8
  }

  # DPS CASE NOTES
  dps-case-notes = {
    domain_type                 = "dps"

    # DMS
    setup_rep_task              = true
    replication_instance_suffix = "case-notes"
    name                        = "dwh-dms-dps-case-notes-pgres-s3-dps"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/dps-case-notes/replication-settings.json"
    table_mappings              = "mappings/dps-case-notes/table-mappings.json.tpl"
    rename_source_schema        = "public"
    rename_output_space         = "casenotes"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

    # Glue Jobs
    # CDC
    setup_cdc_job                       = true
    glue_cdc_create_role                = true
    glue_cdc_create_sec_conf            = true
    # Overrides
    glue_cdc_job_worker_type_override   = "G.025X"
    glue_cdc_job_num_workers_override   = 2
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = true
    glue_archive_create_role            = true
    glue_archive_create_sec_conf        = true
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = true
    glue_unprocessed_raw_files_check_create_role     = true
    glue_unprocessed_raw_files_check_create_sec_conf = true
    # Create Archive Backfill Diff Job
    enable_archive_backfill                          = true
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # CDC Pipeline Trigger
    setup_start_cdc_pipeline = true
    setup_stop_cdc_pipeline  = true
    # Maintenance
    setup_maintenance_pipeline = true

    replay_pipeline_processed_files_check_wait_interval_seconds = 900
    replay_pipeline_processed_files_check_max_attempts          = 8
  }

  # DPS Book a Secure Move (BaSM)
  dps-basm = {
    domain_type                 = "dps"

    # DMS
    setup_rep_task              = true
    replication_instance_suffix = "basm"
    name                        = "dwh-dms-dps-basm-pgres-s3-dps"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/dps-basm/replication-settings.json"
    table_mappings              = "mappings/dps-basm/table-mappings.json.tpl"
    rename_source_schema        = "public"
    rename_output_space         = "bookasecuremove"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

    # Glue Jobs
    # CDC
    setup_cdc_job                       = true
    glue_cdc_create_role                = true
    glue_cdc_create_sec_conf            = true
    # Overrides
    glue_cdc_job_worker_type_override   = "G.025X"
    glue_cdc_job_num_workers_override   = 2
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = true
    glue_archive_create_role            = true
    glue_archive_create_sec_conf        = true
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = true
    glue_unprocessed_raw_files_check_create_role     = true
    glue_unprocessed_raw_files_check_create_sec_conf = true
    # Create Archive Backfill Diff Job
    enable_archive_backfill                          = true
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # CDC Pipeline Trigger
    setup_start_cdc_pipeline = true
    setup_stop_cdc_pipeline  = true
    # Maintenance
    setup_maintenance_pipeline = true

    replay_pipeline_processed_files_check_wait_interval_seconds = 900
    replay_pipeline_processed_files_check_max_attempts          = 8
  }

  # DPS Incident Reporting
  # The name is truncated because maximum length for domain names in our platform is 17 characters
  dps-inc-reporting = {
    domain_type                 = "dps"

    # DMS
    setup_rep_task              = true
    replication_instance_suffix = "inc-reporting"
    name                        = "dwh-dms-dps-inc-reporting-pgres-s3-dps"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/dps-inc-reporting/replication-settings.json"
    table_mappings              = "mappings/dps-inc-reporting/table-mappings.json.tpl"
    rename_source_schema        = "public"
    rename_output_space         = "incidentreporting"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

    # Glue Jobs
    # CDC
    setup_cdc_job                       = true
    glue_cdc_create_role                = true
    glue_cdc_create_sec_conf            = true
    # Overrides
    glue_cdc_job_worker_type_override   = "G.025X"
    glue_cdc_job_num_workers_override   = 2
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = true
    glue_archive_create_role            = true
    glue_archive_create_sec_conf        = true
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = true
    glue_unprocessed_raw_files_check_create_role     = true
    glue_unprocessed_raw_files_check_create_sec_conf = true
    # Create Archive Backfill Diff Job
    enable_archive_backfill                          = true
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # CDC Pipeline Trigger
    setup_start_cdc_pipeline = true
    setup_stop_cdc_pipeline  = true
    # Maintenance
    setup_maintenance_pipeline = true

    replay_pipeline_processed_files_check_wait_interval_seconds = 900
    replay_pipeline_processed_files_check_max_attempts          = 8
  }

  # DPS Challenge, Support and Intervention Plans
  dps-csip = {
    domain_type                 = "dps"

    # DMS
    setup_rep_task              = true
    replication_instance_suffix = "csip"
    name                        = "dwh-dms-dps-csip-pgres-s3-dps"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/dps-csip/replication-settings.json"
    table_mappings              = "mappings/dps-csip/table-mappings.json.tpl"
    rename_source_schema        = "public"
    rename_output_space         = "csip"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

    # Glue Jobs
    # CDC
    setup_cdc_job                       = true
    glue_cdc_create_role                = true
    glue_cdc_create_sec_conf            = true
    # Overrides
    glue_cdc_job_worker_type_override   = "G.025X"
    glue_cdc_job_num_workers_override   = 2
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = true
    glue_archive_create_role            = true
    glue_archive_create_sec_conf        = true
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = true
    glue_unprocessed_raw_files_check_create_role     = true
    glue_unprocessed_raw_files_check_create_sec_conf = true
    # Create Archive Backfill Diff Job
    enable_archive_backfill                          = true
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # CDC Pipeline Trigger
    setup_start_cdc_pipeline = true
    setup_stop_cdc_pipeline  = true
    # Maintenance
    setup_maintenance_pipeline = true

    replay_pipeline_processed_files_check_wait_interval_seconds = 900
    replay_pipeline_processed_files_check_max_attempts          = 8
  }

  # DPS ALERTS
  dps-alerts = {
    domain_type                 = "dps"

    # DMS
    setup_rep_task              = true
    replication_instance_suffix = "alerts"
    name                        = "dwh-dms-dps-alerts-pgres-s3-dps"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/dps-alerts/replication-settings.json"
    table_mappings              = "mappings/dps-alerts/table-mappings.json.tpl"
    rename_source_schema        = "public"
    rename_output_space         = "alerts"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

    # Glue Jobs
    # CDC
    setup_cdc_job                       = true
    glue_cdc_create_role                = true
    glue_cdc_create_sec_conf            = true
    # Overrides
    glue_cdc_job_worker_type_override   = "G.025X"
    glue_cdc_job_num_workers_override   = 2
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = true
    glue_archive_create_role            = true
    glue_archive_create_sec_conf        = true
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = true
    glue_unprocessed_raw_files_check_create_role     = true
    glue_unprocessed_raw_files_check_create_sec_conf = true
    # Create Archive Backfill Diff Job
    enable_archive_backfill                          = true
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # CDC Pipeline Trigger
    setup_start_cdc_pipeline   = true
    setup_stop_cdc_pipeline    = true
    # Maintenance
    setup_maintenance_pipeline = true

    replay_pipeline_processed_files_check_wait_interval_seconds = 900
    replay_pipeline_processed_files_check_max_attempts          = 8
  }

  # DPS LOCATIONS INSIDE PRISON
  dps-locations = {
    domain_type                 = "dps"

    # DMS
    setup_rep_task              = true
    replication_instance_suffix = "locations"
    name                        = "dwh-dms-dps-locations-pgres-s3-dps"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/dps-locations/replication-settings.json"
    table_mappings              = "mappings/dps-locations/table-mappings.json.tpl"
    rename_source_schema        = "public"
    rename_output_space         = "locationsinsideprison"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

    # Glue Jobs
    # CDC
    setup_cdc_job                       = true
    glue_cdc_create_role                = true
    glue_cdc_create_sec_conf            = true
    # Overrides
    glue_cdc_job_worker_type_override   = "G.1X"
    glue_cdc_job_num_workers_override   = 2
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = true
    glue_archive_create_role            = true
    glue_archive_create_sec_conf        = true
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = true
    glue_unprocessed_raw_files_check_create_role     = true
    glue_unprocessed_raw_files_check_create_sec_conf = true
    # Create Archive Backfill Diff Job
    enable_archive_backfill                          = true
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # CDC Pipeline Trigger
    setup_start_cdc_pipeline   = true
    setup_stop_cdc_pipeline    = true
    # Maintenance
    setup_maintenance_pipeline = true

    replay_pipeline_processed_files_check_wait_interval_seconds = 900
    replay_pipeline_processed_files_check_max_attempts          = 8
    # Stop CDC Pipeline Trigger
    create_stop_pipeline_schedule              = true
    enable_cdc_stop_pipeline_schedule          = true
    cdc_stop_pipeline_cron_schedule_expression = "cron(45 21 ? * * *)"
    # Start CDC Pipeline Trigger
    create_start_pipeline_schedule              = true
    enable_cdc_start_pipeline_schedule          = true
    cdc_start_pipeline_cron_schedule_expression = "cron(15 6 ? * * *)"
  }

  # DPS HEALTH AND MEDICATION API
  dps-health-and-me = {
    domain_type                 = "dps"

    # DMS
    setup_rep_task              = true
    replication_instance_suffix = "health-and-me"
    name                        = "dwh-dms-dps-health-and-me-pgres-s3-dps"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/dps-health-and-me/replication-settings.json"
    table_mappings              = "mappings/dps-health-and-me/table-mappings.json.tpl"
    rename_source_schema        = "public"
    rename_output_space         = "healthandmedicationapi"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

    # Glue Jobs
    # CDC
    setup_cdc_job                       = true
    glue_cdc_create_role                = true
    glue_cdc_create_sec_conf            = true
    # Overrides
    glue_cdc_job_worker_type_override   = "G.025X"
    glue_cdc_job_num_workers_override   = 2
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = true
    glue_archive_create_role            = true
    glue_archive_create_sec_conf        = true
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = true
    glue_unprocessed_raw_files_check_create_role     = true
    glue_unprocessed_raw_files_check_create_sec_conf = true
    # Create Archive Backfill Diff Job
    enable_archive_backfill                          = true
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # CDC Pipeline Trigger
    setup_start_cdc_pipeline   = true
    setup_stop_cdc_pipeline    = true
    # Maintenance
    setup_maintenance_pipeline = true

    replay_pipeline_processed_files_check_wait_interval_seconds = 900
    replay_pipeline_processed_files_check_max_attempts          = 8
    # Stop CDC Pipeline Trigger
    create_stop_pipeline_schedule              = true
    enable_cdc_stop_pipeline_schedule          = true
    cdc_stop_pipeline_cron_schedule_expression = "cron(45 21 ? * * *)"
    # Start CDC Pipeline Trigger
    create_start_pipeline_schedule              = true
    enable_cdc_start_pipeline_schedule          = true
    cdc_start_pipeline_cron_schedule_expression = "cron(15 6 ? * * *)"
  }

  # DPS Match Jobs and Manage Applications
  dps-mj-and-ma = {
    domain_type                 = "dps"

    # DMS
    setup_rep_task              = true
    replication_instance_suffix = "mj-and-ma"
    name                        = "dwh-dms-dps-mj-and-ma-pgres-s3-dps"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/dps-mj-and-ma/replication-settings.json"
    table_mappings              = "mappings/dps-mj-and-ma/table-mappings.json.tpl"
    rename_source_schema        = "public"
    rename_output_space         = "matchjobsandmanageapplications"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

    # Glue Jobs
    # CDC
    setup_cdc_job                       = true
    glue_cdc_create_role                = true
    glue_cdc_create_sec_conf            = true
    # Overrides
    glue_cdc_job_worker_type_override   = "G.025X"
    glue_cdc_job_num_workers_override   = 2
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = true
    glue_archive_create_role            = true
    glue_archive_create_sec_conf        = true
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = true
    glue_unprocessed_raw_files_check_create_role     = true
    glue_unprocessed_raw_files_check_create_sec_conf = true
    # Create Archive Backfill Diff Job
    enable_archive_backfill                          = true
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # CDC Pipeline Trigger
    setup_start_cdc_pipeline   = true
    setup_stop_cdc_pipeline    = true
    # Maintenance
    setup_maintenance_pipeline = true

    replay_pipeline_processed_files_check_wait_interval_seconds = 900
    replay_pipeline_processed_files_check_max_attempts          = 8
    # Stop CDC Pipeline Trigger
    create_stop_pipeline_schedule              = true
    enable_cdc_stop_pipeline_schedule          = true
    cdc_stop_pipeline_cron_schedule_expression = "cron(45 21 ? * * *)"
    # Start CDC Pipeline Trigger
    create_start_pipeline_schedule              = true
    enable_cdc_start_pipeline_schedule          = true
    cdc_start_pipeline_cron_schedule_expression = "cron(15 6 ? * * *)"
  }

  # DPS CALCULATE RELEASE DATES
  dps-calc-rel-date = {
    domain_type                 = "dps"

    # DMS
    setup_rep_task              = true
    replication_instance_suffix = "calc-rel-date"
    name                        = "dwh-dms-dps-calc-rel-date-pgres-s3-dps"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/dps-calc-rel-date/replication-settings.json"
    table_mappings              = "mappings/dps-calc-rel-date/table-mappings.json.tpl"
    rename_source_schema        = "public"
    rename_output_space         = "calculatereleasedates"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

    # Glue Jobs
    # CDC
    setup_cdc_job                       = true
    glue_cdc_create_role                = true
    glue_cdc_create_sec_conf            = true
    # Overrides
    glue_cdc_job_worker_type_override   = "G.025X"
    glue_cdc_job_num_workers_override   = 2
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = true
    glue_archive_create_role            = true
    glue_archive_create_sec_conf        = true
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = true
    glue_unprocessed_raw_files_check_create_role     = true
    glue_unprocessed_raw_files_check_create_sec_conf = true
    # Create Archive Backfill Diff Job
    enable_archive_backfill                          = true
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # CDC Pipeline Trigger
    setup_start_cdc_pipeline   = true
    setup_stop_cdc_pipeline    = true
    # Maintenance
    setup_maintenance_pipeline = true

    replay_pipeline_processed_files_check_wait_interval_seconds = 900
    replay_pipeline_processed_files_check_max_attempts          = 8
  }

  # DPS Prison Register
  dps-prison-reg = {
    domain_type                 = "dps"

    # DMS
    setup_rep_task              = true
    replication_instance_suffix = "prison-reg"
    name                        = "dwh-dms-dps-prison-reg-pgres-s3-dps"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/dps-prison-reg/replication-settings.json"
    table_mappings              = "mappings/dps-prison-reg/table-mappings.json.tpl"
    rename_source_schema        = "public"
    rename_output_space         = "prisonregister"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

    # Glue Jobs
    # CDC
    setup_cdc_job                       = true
    glue_cdc_create_role                = true
    glue_cdc_create_sec_conf            = true
    # Overrides
    glue_cdc_job_worker_type_override   = "G.025X"
    glue_cdc_job_num_workers_override   = 2
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = true
    glue_archive_create_role            = true
    glue_archive_create_sec_conf        = true
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = true
    glue_unprocessed_raw_files_check_create_role     = true
    glue_unprocessed_raw_files_check_create_sec_conf = true
    # Create Archive Backfill Diff Job
    enable_archive_backfill                          = true
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # CDC Pipeline Trigger
    setup_start_cdc_pipeline   = true
    setup_stop_cdc_pipeline    = true
    # Maintenance
    setup_maintenance_pipeline = true

    replay_pipeline_processed_files_check_wait_interval_seconds = 900
    replay_pipeline_processed_files_check_max_attempts          = 8
    # Stop CDC Pipeline Trigger
    create_stop_pipeline_schedule              = true
    enable_cdc_stop_pipeline_schedule          = true
    cdc_stop_pipeline_cron_schedule_expression = "cron(45 21 ? * * *)"
    # Start CDC Pipeline Trigger
    create_start_pipeline_schedule              = true
    enable_cdc_start_pipeline_schedule          = true
    cdc_start_pipeline_cron_schedule_expression = "cron(15 6 ? * * *)"
  }

  # DPS Personal Relationships
  dps-personal-rela = {
    domain_type                 = "dps"

    # DMS
    setup_rep_task              = true
    batch_only                  = true
    replication_instance_suffix = "personal-rela"
    name                        = "dwh-dms-dps-personal-rela-pgres-s3-dps"
    migration_type              = "full-load"
    replication_task_settings   = "mappings/dps-personal-rela/replication-settings.json"
    table_mappings              = "mappings/dps-personal-rela/table-mappings.json.tpl"
    rename_source_schema        = "public"
    rename_output_space         = "personalrelationships"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

    # Glue Jobs
    # CDC
    setup_cdc_job                       = false
    glue_cdc_create_role                = false
    glue_cdc_create_sec_conf            = false
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = false
    glue_archive_create_role            = false
    glue_archive_create_sec_conf        = false
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = false
    glue_unprocessed_raw_files_check_create_role     = false
    glue_unprocessed_raw_files_check_create_sec_conf = false
    # Create Archive Backfill Diff Job
    enable_archive_backfill                          = true
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # Ingestion Pipeline Trigger
    create_ingestion_pipeline_schedule          = true
    enable_ingestion_pipeline_schedule          = false
    ingestion_pipeline_cron_schedule_expression = "cron(30 15 ? * 7#1 *)"
  }

  # DPS Organisations
  dps-organisations = {
    domain_type                 = "dps"

    # DMS
    setup_rep_task              = true
    batch_only                  = true
    replication_instance_suffix = "organisations"
    name                        = "dwh-dms-dps-organisations-pgres-s3-dps"
    migration_type              = "full-load"
    replication_task_settings   = "mappings/dps-organisations/replication-settings.json"
    table_mappings              = "mappings/dps-organisations/table-mappings.json.tpl"
    rename_source_schema        = "public"
    rename_output_space         = "organisations"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

    # Glue Jobs
    # CDC
    setup_cdc_job                       = false
    glue_cdc_create_role                = false
    glue_cdc_create_sec_conf            = false
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = false
    glue_archive_create_role            = false
    glue_archive_create_sec_conf        = false
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = false
    glue_unprocessed_raw_files_check_create_role     = false
    glue_unprocessed_raw_files_check_create_sec_conf = false
    # Create Archive Backfill Diff Job
    enable_archive_backfill                          = true
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # Ingestion Pipeline Trigger
    create_ingestion_pipeline_schedule          = true
    enable_ingestion_pipeline_schedule          = false
    ingestion_pipeline_cron_schedule_expression = "cron(30 16 ? * 7#1 *)"
  }

  # DPS Allocations
  dps-allocations = {
    domain_type                 = "dps"

    # DMS
    setup_rep_task              = true
    replication_instance_suffix = "allocations"
    name                        = "dwh-dms-dps-allocations-pgres-s3-dps"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/dps-allocations/replication-settings.json"
    table_mappings              = "mappings/dps-allocations/table-mappings.json.tpl"
    rename_source_schema        = "public"
    rename_output_space         = "allocations"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

    # Glue Jobs
    # CDC
    setup_cdc_job                       = true
    glue_cdc_create_role                = true
    glue_cdc_create_sec_conf            = true
    # Overrides
    glue_cdc_job_worker_type_override   = "G.1X"
    glue_cdc_job_num_workers_override   = 2
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = true
    glue_archive_create_role            = true
    glue_archive_create_sec_conf        = true
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = true
    glue_unprocessed_raw_files_check_create_role     = true
    glue_unprocessed_raw_files_check_create_sec_conf = true
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # CDC Pipeline Trigger
    setup_start_cdc_pipeline   = true
    setup_stop_cdc_pipeline    = true
    # Maintenance
    setup_maintenance_pipeline = true
    replay_pipeline_processed_files_check_wait_interval_seconds = 900
    replay_pipeline_processed_files_check_max_attempts          = 8
    # Stop CDC Pipeline Trigger
    create_stop_pipeline_schedule              = true
    enable_cdc_stop_pipeline_schedule          = true
    cdc_stop_pipeline_cron_schedule_expression = "cron(45 21 ? * * *)"
    # Start CDC Pipeline Trigger
    create_start_pipeline_schedule              = true
    enable_cdc_start_pipeline_schedule          = true
    cdc_start_pipeline_cron_schedule_expression = "cron(15 6 ? * * *)"
  }

  # Manage POM Cases
  dps-manage-pom = {
    domain_type                 = "dps"

    # DMS
    setup_rep_task              = true
    replication_instance_suffix = "manage-pom"
    name                        = "dwh-dms-dps-manage-pom-pgres-s3-dps"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/dps-manage-pom/replication-settings.json"
    table_mappings              = "mappings/dps-manage-pom/table-mappings.json.tpl"
    rename_source_schema        = "public"
    rename_output_space         = "managepomcases"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

    # Postgres Tickle
    create_postgres_tickle_schedule = true
    enable_postgres_tickle_schedule = true

    # Glue Jobs
    # CDC
    setup_cdc_job                       = true
    glue_cdc_create_role                = true
    glue_cdc_create_sec_conf            = true
    # Overrides
    glue_cdc_job_worker_type_override   = "G.1X"
    glue_cdc_job_num_workers_override   = 2
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = true
    glue_archive_create_role            = true
    glue_archive_create_sec_conf        = true
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = true
    glue_unprocessed_raw_files_check_create_role     = true
    glue_unprocessed_raw_files_check_create_sec_conf = true
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # CDC Pipeline Trigger
    setup_start_cdc_pipeline   = true
    setup_stop_cdc_pipeline    = true
    # Maintenance
    setup_maintenance_pipeline = true
    replay_pipeline_processed_files_check_wait_interval_seconds = 900
    replay_pipeline_processed_files_check_max_attempts          = 8
    # Stop CDC Pipeline Trigger
    create_stop_pipeline_schedule              = true
    enable_cdc_stop_pipeline_schedule          = true
    cdc_stop_pipeline_cron_schedule_expression = "cron(45 21 ? * * *)"
    # Start CDC Pipeline Trigger
    create_start_pipeline_schedule              = true
    enable_cdc_start_pipeline_schedule          = true
    cdc_start_pipeline_cron_schedule_expression = "cron(15 6 ? * * *)"
  }

  # DPS Support for Additional Needs
  dps-san = {
    domain_type                 = "dps"

    # DMS
    setup_rep_task              = true
    replication_instance_suffix = "san"
    name                        = "dwh-dms-dps-san-pgres-s3-dps"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/dps-san/replication-settings.json"
    table_mappings              = "mappings/dps-san/table-mappings.json.tpl"
    rename_source_schema        = "public"
    rename_output_space         = "supportforadditionalneeds"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

    # Postgres Tickle
    create_postgres_tickle_schedule = true
    enable_postgres_tickle_schedule = true

    # Glue Jobs
    # CDC
    setup_cdc_job                       = true
    glue_cdc_create_role                = true
    glue_cdc_create_sec_conf            = true
    # Overrides
    glue_cdc_job_worker_type_override   = "G.1X"
    glue_cdc_job_num_workers_override   = 2
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = true
    glue_archive_create_role            = true
    glue_archive_create_sec_conf        = true
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = true
    glue_unprocessed_raw_files_check_create_role     = true
    glue_unprocessed_raw_files_check_create_sec_conf = true
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # CDC Pipeline Trigger
    setup_start_cdc_pipeline   = true
    setup_stop_cdc_pipeline    = true
    # Maintenance
    setup_maintenance_pipeline = true
    replay_pipeline_processed_files_check_wait_interval_seconds = 900
    replay_pipeline_processed_files_check_max_attempts          = 8
    # Stop CDC Pipeline Trigger
    create_stop_pipeline_schedule              = true
    enable_cdc_stop_pipeline_schedule          = true
    cdc_stop_pipeline_cron_schedule_expression = "cron(45 21 ? * * *)"
    # Start CDC Pipeline Trigger
    create_start_pipeline_schedule              = true
    enable_cdc_start_pipeline_schedule          = true
    cdc_start_pipeline_cron_schedule_expression = "cron(15 6 ? * * *)"
  }

  # DWH TEST DOMAIN
  dps-test-db = {
    # To remove this domain you will need to detach the DMS
    # security group from the test-database first
    domain_type                 = "dps"

    # DMS
    setup_rep_task              = true
    replication_instance_suffix = "test-db"
    name                        = "dwh-dms-dps-test-db-pgres-s3-dps"
    migration_type              = "full-load-and-cdc"
    replication_task_settings   = "mappings/dps-test-db/replication-settings.json"
    table_mappings              = "mappings/dps-test-db/table-mappings.json.tpl"
    rename_source_schema        = "public"
    rename_output_space         = "testing"
    vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
    cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"
    # Postgres Tickle
    create_postgres_tickle_schedule = true
    enable_postgres_tickle_schedule = true

    # Glue Jobs
    # CDC
    setup_cdc_job                       = true
    glue_cdc_create_role                = true
    glue_cdc_create_sec_conf            = true
    # Overrides
    glue_cdc_job_worker_type_override   = "G.025X"
    glue_cdc_job_num_workers_override   = 2
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = true
    glue_archive_create_role            = true
    glue_archive_create_sec_conf        = true
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = true
    glue_unprocessed_raw_files_check_create_role     = true
    glue_unprocessed_raw_files_check_create_sec_conf = true
    # Create Archive Backfill Diff Job
    enable_archive_backfill                          = true
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    glue_create_reload_diff_job_worker_type          = "G.1X"
    glue_create_reload_diff_job_num_workers_override = 2
    # CDC Pipeline Trigger
    setup_start_cdc_pipeline = true
    setup_stop_cdc_pipeline  = true
    # Maintenance
    setup_maintenance_pipeline = true

    replay_pipeline_processed_files_check_wait_interval_seconds = 900
    replay_pipeline_processed_files_check_max_attempts          = 8
  }

  # CSV File Transfer In - Prison Estate
  prison-estate = {
    domain_type                 = "file-transfer-in"
    setup_rep_task              = false
    batch_only                  = true
    rename_output_space         = "prisonestate"

    # Glue Jobs
    # CDC
    setup_cdc_job                       = false
    glue_cdc_create_role                = false
    glue_cdc_create_sec_conf            = false
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = false
    glue_archive_create_role            = false
    glue_archive_create_sec_conf        = false
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = false
    glue_unprocessed_raw_files_check_create_role     = false
    glue_unprocessed_raw_files_check_create_sec_conf = false
    # Create Reload Diff Job
    setup_archive_backfill_job                     = false
    glue_archive_backfill_job_role                 = false
    glue_archive_backfill_job_create_sec_conf      = false
    glue_archive_backfill_job_worker_type          = "G.1X"
    glue_archive_backfill_job_num_workers_override = 2
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    reload_diff_job_checkpoint_use_now_timestamp     = true
    # Reconciliation Job
    setup_reconciliation_job = false
    # Ingestion Pipeline Trigger
    create_ingestion_pipeline_schedule          = false
    enable_ingestion_pipeline_schedule          = false
    # Pipelines
    setup_reload_pipeline                = true
    setup_replay_pipeline                = false
    setup_start_cdc_pipeline             = false
    setup_stop_cdc_pipeline              = false
    setup_maintenance_pipeline           = false
    create_start_pipeline_schedule       = false
    create_stop_pipeline_schedule        = false
    create_maintenance_pipeline_schedule = false
    create_ingestion_pipeline_schedule   = false
    create_reload_pipeline_schedule      = false
  }

  # CSV File Transfer In - Test Data
  # This pipeline is used to generate test data from CSV files created using the synthetic data generator
  # https://github.com/ministryofjustice/hmpps-digital-prison-reporting-synthetic-data
  test-data = {
    domain_type                 = "file-transfer-in"
    setup_rep_task              = false
    batch_only                  = true
    rename_output_space         = "testdata"

    # Glue Jobs
    # CDC
    setup_cdc_job                       = false
    glue_cdc_create_role                = false
    glue_cdc_create_sec_conf            = false
    # Batch
    setup_batch_job                     = true
    glue_batch_create_role              = true
    glue_batch_create_sec_conf          = true
    # Overrides
    glue_batch_job_num_workers_override = 2
    # Archive
    setup_archive_job                   = false
    glue_archive_create_role            = false
    glue_archive_create_sec_conf        = false
    # Unprocessed Raw Files Check Job
    setup_unprocessed_raw_files_check_job            = false
    glue_unprocessed_raw_files_check_create_role     = false
    glue_unprocessed_raw_files_check_create_sec_conf = false
    # Create Reload Diff Job
    setup_archive_backfill_job                     = false
    glue_archive_backfill_job_role                 = false
    glue_archive_backfill_job_create_sec_conf      = false
    glue_archive_backfill_job_worker_type          = "G.1X"
    glue_archive_backfill_job_num_workers_override = 2
    # Create Reload Diff Job
    setup_create_reload_diff_job                     = true
    glue_create_reload_diff_job_role                 = true
    glue_create_reload_diff_job_create_sec_conf      = true
    reload_diff_job_checkpoint_use_now_timestamp     = true
    # Reconciliation Job
    setup_reconciliation_job = false
    # Ingestion Pipeline Trigger
    create_ingestion_pipeline_schedule          = false
    enable_ingestion_pipeline_schedule          = false
    # Pipelines
    setup_reload_pipeline                = true
    setup_replay_pipeline                = false
    setup_start_cdc_pipeline             = false
    setup_stop_cdc_pipeline              = false
    setup_maintenance_pipeline           = false
    create_start_pipeline_schedule       = false
    create_stop_pipeline_schedule        = false
    create_maintenance_pipeline_schedule = false
    create_ingestion_pipeline_schedule   = false
    create_reload_pipeline_schedule      = false
  }
}
