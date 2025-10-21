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
  nomis-common = {
    setup                        = true
    replication_instance_class   = "dms.t3.large"
    replication_instance_version = "3.5.4"
    replication_instance_storage = 12
  }
domains = {
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
}
