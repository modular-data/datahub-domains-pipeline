variable "environment" {
  type        = string
  description = "Name of Environment"
}

variable "batch_only" {
  description = "Determines if the pipeline is batch only, True or False?"
  type        = bool
  default     = false
}

variable "enable_archive_backfill" {
  description = "Boolean flag to backfill the archive before computing the reload diff during the reload process"
  type        = bool
  default     = false
}

variable "endpoints" {
  description = "Map of Endpoints."
  type        = map(any)
  default     = {}
}

variable "domains" {
  description = "Map of DOMAINS."
  type        = map(any)
  default     = {}
}

variable "instances" {
  description = "Map of DOMAINS."
  type        = map(any)
  default     = {}
}

variable "subnets" {
  description = "An List of VPC subnet IDs to use in the subnet group"
  type        = list(string)
  default     = []
}

variable "cidr" {
  description = "CIDR for the  VPC"
  type        = list(string)
  default     = null
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for DWH Project"
  default     = ""
}

variable "subnet_ids" {
  description = "List of subnet IDs for the VPC (should include subnets in different AZs)"
  type        = list(string)
  default     = []
}

variable "data_subnet_ids" {
  description = "List of data subnet IDs (typically for data layer resources)"
  type        = list(string)
  default     = []
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs (typically for private resources)"
  type        = list(string)
  default     = []
}

# Lambdas

variable "artifact_s3_bucket" {
  description = "S3 Artifacts Bucket ID (stores code artifacts, such as jars)"
  type        = string
  default     = ""
}

variable "working_s3_bucket" {
  description = "S3 Working Bucket ID (used as an Athena spill bucket)"
  type        = string
  default     = ""
}

variable "reporting_lambda_code_s3_key" {
  description = "S3 File Transfer Lambda Code Bucket KEY"
  type        = string
  default     = ""
}

variable "lambda_log_retention_in_days" {
  description = "Lambda log retention in number of days."
  type        = number
  default     = 7
}
# Postgres Tickle Lambda

variable "setup_postgres_tickle_lambda" {
  type        = bool
  default     = true
  description = "Whether to enable the Postgres tickle lambda"
}

variable "postgres_tickle_lambda_jar_s3_key" {
  description = "Postgres Tickle Lambda Jar S3 Bucket KEY"
  type        = string
}

variable "postgres_tickle_lambda_timeout_in_seconds" {
  description = "Lambda timeout in seconds."
  type        = number
  default     = 60
}

variable "athena_federated_query_lambda_memory_mb" {
  description = "Amount of memory in MB the Connector Lambda Function can use at runtime."
  type        = number
  default     = 550
}

variable "athena_federated_query_lambda_timeout_in_seconds" {
  description = "Limit of time the Connector lambda has to run in seconds."
  type        = number
  default     = 900 # 15 minutes
}

variable "athena_federated_query_lambda_reserved_concurrent_executions" {
  type        = number
  description = "Amount of reserved concurrent executions for the Connector lambda function. A value of 0 disables the lambda from being triggered and -1 removes any concurrency limitations"
}

variable "athena_postgresql_federated_query_lambda_handler" {
  type        = string
  description = "The handler which will handle the Athena PostgreSQL Connector Lambda invocation."
}

variable "athena_redshift_federated_query_lambda_handler" {
  type        = string
  description = "The handler which will handle the Athena Redshift Connector Lambda invocation."
}

# Step Function Lambdas

variable "setup_step_function_notification_lambda" {
  description = "Enable Step Function Notification Lambda, True or False ?"
  type        = bool
  default     = false
}

variable "step_function_notification_lambda" {
  description = "Name for Notification Lambda Name"
  type        = string
  default     = ""
}

variable "step_function_notification_lambda_handler" {
  description = "Notification Lambda Handler"
  type        = string
  default     = "uk.gov.justice.digital.lambda.StepFunctionDMSNotificationLambda::handleRequest"
}

variable "step_function_notification_lambda_runtime" {
  description = "Lambda Runtime"
  type        = string
  default     = "java11"
}

variable "step_function_notification_lambda_policies" {
  description = "An List of Notification Lambda Policies"
  type        = list(string)
  default     = []
}

variable "step_function_notification_lambda_tracing" {
  description = "Lambda Tracing"
  type        = string
  default     = "Active"
}

variable "step_function_notification_lambda_trigger" {
  description = "Name for Notification Lambda Trigger Name"
  type        = string
  default     = ""
}

variable "step_function_notification_lambda_sg_name" {
  description = "Name for Notification Lambda Trigger Security Group Name"
  type        = string
  default     = ""
}

variable "lambda_subnet_ids" {
  description = "Lambda Subnet ID's"
  type        = list(string)
  default     = []
}

variable "lambda_security_group_ids" {
  description = "Lambda Security Group ID's"
  type        = list(string)
  default     = []
}

# File Transfer In

variable "setup_file_transfer_in_lambdas" {
  description = "Whether to set up File Transfer In pipelines"
  type        = bool
  default     = false
}

variable "landing_zone_processing_lambda_jar_s3_key" {
  description = "The S3 key of the Landing Zone Processing Lambda jar"
  type        = string
}

variable "landing_zone_antivirus_check_lambda_memory_size" {
  description = "Memory for the Landing Zone Antivirus Check Lambda in MB"
  type        = number
  default     = 2048
}

variable "landing_zone_antivirus_check_lambda_timeout_in_seconds" {
  description = "Timeout for the Landing Zone Antivirus Check Lambda in seconds"
  type        = number
  default     = 900 # 15 minutes
}

variable "landing_zone_antivirus_check_lambda_ephemeral_storage_size" {
  description = "Disk ephemeral storage for the Landing Zone Antivirus Check Lambda in MB.Can be increased up to 10240MB if required."
  type        = number
  default     = 512
}

variable "landing_zone_antivirus_check_lambda_reserved_concurrent_executions" {
  description = "Maximum number of concurrent executions for the Landing Zone Antivirus Check Lambda (or -1 for unlimited))"
  type        = number
  default     = 10
}

variable "landing_zone_antivirus_check_lambda_log_retention_in_days" {
  description = "Log retention in days for the Landing Zone Antivirus Check Lambda"
  type        = number
  default     = 7
}

variable "landing_zone_processing_lambda_tracing" {
  description = "Lambda Tracing"
  type        = string
  default     = "Active"
}

variable "landing_zone_processing_lambda_timeout_in_seconds" {
  description = "Landing zone processing Lambda timeout in seconds."
  type        = number
  default     = 900 # 15 minutes
}

variable "landing_zone_processing_lambda_memory_mb" {
  description = "Lambda timeout in seconds."
  type        = number
  default     = 512
}

variable "landing_zone_processing_lambda_log_retention_in_days" {
  description = "Log retention in days for the Landing Zone Processing Check Lambda"
  type        = number
  default     = 7
}

variable "landing_zone_processing_lambda_csv_charset" {
  description = "The CSV character set to use"
  type        = string
  default     = "UTF-8"
}

variable "landing_zone_processing_skip_header" {
  description = "Whether to skip the first line of the CSV file"
  type        = bool
  default     = false
}

variable "landing_zone_processing_log_csv" {
  description = "Whether to log all lines of the CSV file during landing zone processing"
  type        = bool
  default     = false
}

variable "landing_zone_processing_lambda_violations_path" {
  description = "The path within the bucket to use when moving files classed as violations into the violations bucket"
  type        = string
  default     = "landing"
}

# DMS Endpoints
variable "nomis_dms_source_name" {
  type    = string
  default = ""
}

variable "nomis_source_engine" {
  type    = string
  default = ""
}

variable "dps_source_engine" {
  type    = string
  default = ""
}

variable "nomis_dms_target_name" {
  type    = string
  default = ""
}

variable "nomis_short_name" {
  type    = string
  default = ""
}


variable "extra_attributes" {
  type    = string
  default = ""
}

variable "setup_rep_task" {
  type    = bool
  default = false
}

variable "setup_ingestion_jobs" {
  description = "Whether to set up Ingestion jobs or not"
  type        = bool
  default     = false
}

variable "setup_dms_endpoints" {
  type    = bool
  default = false
}

variable "setup_dms_nomis_endpoint" {
  type    = bool
  default = false
}

variable "setup_dms_s3_endpoint" {
  type    = bool
  default = false
}

variable "setup_dms_iam" {
  description = "Enable DMS IAM, True or False"
  type        = bool
  default     = false
}

# Glue JOBS

variable "script_version" {}

variable "jar_version" {}

variable "glue_log_group_retention_in_days" {
  type    = number
  default = 7
}

variable "glue_job_version" {
  type        = string
  default     = "4.0"
  description = "The version of glue to use."
}

variable "glue_cdc_job_worker_type" {
  type    = string
  default = "G.1X"
}

variable "glue_cdc_job_num_workers" {
  type    = number
  default = 2
}

variable "glue_cdc_max_concurrent" {
  type    = number
  default = 1
}

variable "glue_cdc_maintenance_window" {
  type        = string
  default     = "Sun:2"
  description = "(Optional) The maintenance window during which the glue job will be restarted"
}

variable "glue_cdc_job_name" {
  description = "Name of the Glue CDC Job"
  default     = ""
}

variable "processed_files_check_wait_interval_seconds" {
  description = "Amount of seconds between checks to s3 if all files have been processed"
  type        = number
  default     = 420
}

variable "processed_files_check_max_attempts" {
  description = "Maximum number of attempts to check if all files have been processed"
  type        = number
  default     = 3
}

variable "glue_cdc_job_retry_max_attempts" {
  type    = number
  default = 10
}

variable "glue_cdc_job_retry_min_wait_millis" {
  type    = number
  default = 100
}

variable "glue_cdc_job_retry_max_wait_millis" {
  type    = number
  default = 10000
}

variable "glue_cdc_job_spark_broadcast_timeout_seconds" {
  type    = number
  default = 300
}

variable "glue_cdc_job_disable_auto_broadcast_join_threshold" {
  type    = bool
  default = false
}

variable "glue_cdc_job_max_files_per_trigger" {
  type    = number
  default = 1000
}

variable "glue_cdc_job_max_records_per_file" {
  type        = number
  default     = 0
  description = "The maximum number of records per output file produced by the CDC job. Can be used to avoid overly large output files."
}

variable "glue_cdc_job_log_level" {
  type    = string
  default = "INFO"
}

variable "glue_cdc_max_cache_size" {
  type    = number
  default = 1000
}

variable "glue_cdc_cache_expiry_minutes" {
  type    = number
  default = 60
}

# Batch
variable "glue_batch_job_worker_type" {
  type    = string
  default = "G.1X"
}

variable "glue_batch_job_num_workers" {
  type    = number
  default = 2
}

variable "glue_batch_max_concurrent" {
  type    = number
  default = 1
}

variable "glue_batch_job_retry_max_attempts" {
  type    = number
  default = 10
}

variable "glue_batch_job_retry_min_wait_millis" {
  type    = number
  default = 100
}

variable "glue_batch_job_retry_max_wait_millis" {
  type    = number
  default = 10000
}

variable "glue_batch_job_log_level" {
  type    = string
  default = "INFO"
}

# Archive
variable "glue_archive_job_worker_type" {
  type    = string
  default = "G.1X"
}

variable "glue_archive_job_num_workers" {
  type    = number
  default = 2
}

variable "glue_archive_max_concurrent" {
  type    = number
  default = 1
}

variable "glue_archive_job_log_level" {
  type    = string
  default = "INFO"
}

variable "glue_s3_max_attempts" {
  type    = number
  default = 10
}

variable "glue_s3_retry_min_wait_millis" {
  type    = number
  default = 1000
}

variable "glue_s3_retry_max_wait_millis" {
  type    = number
  default = 10000
}

variable "glue_raw_file_retention_amount" {
  type    = number
  default = 2
}

variable "glue_raw_file_retention_unit" {
  type    = string
  default = "days"
}

variable "file_transfer_use_default_parallelism" {
  type    = bool
  default = false
}

variable "file_transfer_parallelism" {
  type    = number
  default = 128
}

# Unprocessed raw Files Check Job
variable "glue_unprocessed_raw_files_check_job_worker_type" {
  type    = string
  default = "G.1X"
}

variable "glue_unprocessed_raw_files_check_job_num_workers" {
  type    = number
  default = 2
}

variable "glue_unprocessed_raw_files_check_max_concurrent" {
  type    = number
  default = 1
}

variable "glue_unprocessed_raw_files_check_job_log_level" {
  type    = string
  default = "INFO"
}

# Create Archive Backfill Job
variable "glue_archive_backfill_job_worker_type" {
  type    = string
  default = "G.1X"
}

variable "glue_archive_backfill_job_num_workers" {
  type    = number
  default = 2
}

variable "glue_archive_backfill_job_max_concurrent" {
  type    = number
  default = 1
}

variable "glue_archive_backfill_job_log_level" {
  type    = string
  default = "INFO"
}

# Create Reload Diffs Job
variable "glue_create_reload_diff_job_worker_type" {
  type    = string
  default = "G.1X"
}

variable "glue_create_reload_diff_job_num_workers" {
  type    = number
  default = 2
}

variable "glue_create_reload_diff_job_max_concurrent" {
  type    = number
  default = 1
}

variable "glue_create_reload_diff_job_log_level" {
  type    = string
  default = "INFO"
}

# Reconciliation Job

variable "glue_reconciliation_job_worker_type" {
  type    = string
  default = "G.1X"
}

variable "glue_reconciliation_job_num_workers" {
  type    = number
  default = 2
}

variable "glue_reconciliation_job_max_concurrent" {
  type    = number
  default = 1
}

variable "glue_reconciliation_job_create_sec_conf" {
  type    = bool
  default = true
}

variable "glue_reconciliation_job_log_level" {
  type    = string
  default = "INFO"
}

variable "glue_reconciliation_job_schedule" {
  type        = string
  description = "The cron schedule (or the empty string for disabled)."
  default     = ""
}

variable "glue_reconciliation_job_metrics_namespace" {
  type        = string
  description = "The Cloudwatch Metrics namespace to use for the Reconciliation Job's custom metrics."
}

variable "glue_reconciliation_job_changedatacounts_tolerance_relative_percentage" {
  type        = number
  description = "The relative percentage tolerance to use for allowing non-exact count matches in the change data counts reconciliation."
  default     = 0.0
}

variable "glue_reconciliation_job_changedatacounts_tolerance_absolute" {
  type        = number
  description = "The absolute tolerance to use for allowing non-exact count matches in the change data counts reconciliation."
  default     = 0
}

variable "glue_reconciliation_job_currentstatecounts_tolerance_relative_percentage" {
  type        = number
  description = "The relative percentage tolerance to use for allowing non-exact count matches in the current state counts reconciliation."
  default     = 0.0
}

variable "glue_reconciliation_job_currentstatecounts_tolerance_absolute" {
  type        = number
  description = "The absolute tolerance to use for allowing non-exact count matches in the current state counts reconciliation."
  default     = 0
}

# DMS Instance
variable "allow_major_version_upgrade" {
  description = "Indicates that major version upgrades are allowed"
  type        = bool
  default     = true
}

variable "replication_instance_class" {
  description = "Instance class of replication instance"
  default     = "dms.t3.micro"
}

variable "replication_instance_storage" {
  type        = number
  default     = 10
  description = "Storage size in GB for the replication instance"
}

variable "setup_dms_instance" {
  description = "Enable DMS Instance, True or False"
  type        = bool
  default     = false
}

variable "dms_log_group_retention_in_days" {
  type        = number
  default     = 14
  description = "(Optional) The default number of days log events retained in the DMS task log group."
}

variable "split_dms_task" {
  type        = bool
  default     = false
  description = "(Optional) Boolean flag to determine if the DMS task should be split. When true task is split to 'full-load' and 'cdc'. When false the task is 'full-load-and-cdc'"
}

# Ingestion
variable "setup_ingestion_pipeline" {
  description = "Enable Step Function, True or False ?"
  type        = bool
  default     = false
}

variable "create_ingestion_pipeline_schedule" {
  description = "(Optional) Create the schedule for the ingestion pipeline. True or False ?"
  type        = bool
  default     = false
}

variable "enable_ingestion_pipeline_schedule" {
  description = "Enables the schedule on the ingestion pipeline"
  type        = bool
  default     = false
}

variable "ingestion_pipeline_cron_schedule_expression" {
  description = "(Optional) the schedule expression on which to execute the ingestion pipeline"
  type        = string
  default     = null
}

variable "ingestion_pipeline_max_window_in_minutes" {
  description = "The duration in minutes within which the trigger to run the ingestion pipeline will be executed after the scheduled start time"
  type        = number
  default     = 30
}

# Reconciliation
variable "setup_reconciliation_job" {
  description = "Enable Reconciliation Job, True or False ?"
  type        = bool
  default     = false
}

# Reload
variable "setup_reload_pipeline" {
  description = "Enable Reload Step Function, True or False ?"
  type        = bool
  default     = false
}

variable "create_reload_pipeline_schedule" {
  description = "(Optional) Create the schedule for the reload pipeline. True or False ?"
  type        = bool
  default     = false
}

variable "enable_reload_pipeline_schedule" {
  description = "Enables the schedule on the reload pipeline"
  type        = bool
  default     = false
}

variable "reload_pipeline_cron_schedule_expression" {
  description = "(Optional) the schedule expression on which to execute the reload pipeline"
  type        = string
  default     = null
}

variable "reload_pipeline_max_window_in_minutes" {
  description = "The duration in minutes within which the trigger to run the reload pipeline will be executed after the scheduled start time"
  type        = number
  default     = 30
}

# Replay
variable "setup_replay_pipeline" {
  description = "Enable Replay Step Function, True or False ?"
  type        = bool
  default     = false
}

# Scheduled Ingestion Pipelines
variable "setup_start_cdc_pipeline" {
  description = "(Optional) Setup the Pipeline to Start the CDC Step Function, True or False ?"
  type        = bool
  default     = false
}

variable "setup_stop_cdc_pipeline" {
  description = "(Optional) Setup The Pipeline to Stop the CDC Step Function, True or False ?"
  type        = bool
  default     = false
}

variable "create_start_pipeline_schedule" {
  description = "(Optional) Create the Schedule for the Start CDC Step Function, True or False ?"
  type        = bool
  default     = false
}

variable "create_stop_pipeline_schedule" {
  description = "(Optional) Create the Schedule for the Stop CDC Step Function, True or False ?"
  type        = bool
  default     = false
}

variable "cdc_start_pipeline_cron_schedule_expression" {
  type        = string
  description = "(Optional) the schedule expression on which to execute the start CDC pipeline"
  default     = null
}

variable "cdc_stop_pipeline_cron_schedule_expression" {
  type        = string
  description = "(Optional) the schedule expression on which to execute the stop CDC pipeline"
  default     = null
}

variable "cdc_start_pipeline_max_window_in_minutes" {
  type        = number
  description = "The duration in minutes within which the trigger to run the pipeline will be executed after the scheduled start time"
  default     = 10
}

variable "cdc_stop_pipeline_max_window_in_minutes" {
  type        = number
  description = "The duration in minutes within which the trigger to stop the pipeline will be executed after the scheduled stop time"
  default     = 10
}

# Maintenance Pipelines
variable "setup_maintenance_pipeline" {
  description = "(Optional) Setup the maintenance pipeline. True or False ?"
  type        = bool
  default     = false
}

variable "create_maintenance_pipeline_schedule" {
  description = "(Optional) Create the schedule for the maintenance pipeline. True or False ?"
  type        = bool
  default     = false
}

variable "maintenance_pipeline_cron_schedule_expression" {
  description = "(Optional) the schedule expression on which to execute the maintenance pipeline"
  type        = string
  default     = null
}

variable "maintenance_pipeline_max_window_in_minutes" {
  description = "The duration in minutes within which the trigger to run the maintenance pipeline will be executed after the scheduled start time"
  type        = number
  default     = 30
}

variable "enable_cdc_start_pipeline_schedule" {
  description = "Enables the schedule to start the CDC pipeline"
  type        = bool
  default     = false
}

variable "enable_cdc_stop_pipeline_schedule" {
  description = "Enables the schedule to stop the CDC pipeline"
  type        = bool
  default     = false
}

variable "enable_maintenance_pipeline_schedule" {
  description = "Enables the schedule on the maintenance pipeline"
  type        = bool
  default     = false
}

variable "create_postgres_tickle_schedule" {
  description = "(Optional) Create the schedule for the postgres tickle lambda. True or False ?"
  type        = bool
  default     = false
}

variable "enable_postgres_tickle_schedule" {
  description = "Enables the schedule on the postgres tickle lambda"
  type        = bool
  default     = false
}

variable "postgres_tickle_schedule_expression" {
  description = "(Optional) the schedule expression on which to execute the postgres tickle lambda"
  type        = string
  default     = "rate(10 minutes)"
}

variable "create_reconciliation_job_role" {
  description = "Creates the role for the reconciliation job"
  type        = bool
  default     = true
}

variable "compaction_structured_worker_type" {
  description = "(Optional) Worker type to use for the compaction job in structured zone"
  type        = string
  default     = "G.1X"

  validation {
    condition     = contains(["G.1X", "G.2X", "G.4X", "G.8X"], var.compaction_structured_worker_type)
    error_message = "Worker type can only be one of G.1X, G.2X, G.4X, G.8X"
  }
}

variable "compaction_structured_num_workers" {
  description = "(Optional) Number of workers to use for the compaction job in structured zone. Must be >= 2"
  type        = number
  default     = 2

  validation {
    condition     = var.compaction_structured_num_workers >= 2
    error_message = "Number of workers must be >= 2"
  }
}

variable "compaction_curated_worker_type" {
  description = "(Optional) Worker type to use for the compaction job in curated zone"
  type        = string
  default     = "G.1X"

  validation {
    condition     = contains(["G.1X", "G.2X", "G.4X", "G.8X"], var.compaction_curated_worker_type)
    error_message = "Worker type can only be one of G.1X, G.2X, G.4X, G.8X"
  }
}

variable "compaction_curated_num_workers" {
  description = "(Optional) Number of workers to use for the compaction job in curated zone. Must be >= 2"
  type        = number
  default     = 2

  validation {
    condition     = var.compaction_curated_num_workers >= 2
    error_message = "Number of workers must be >= 2"
  }
}

variable "retention_structured_worker_type" {
  description = "(Optional) Worker type to use for the retention job in structured zone"
  type        = string
  default     = "G.1X"

  validation {
    condition     = contains(["G.1X", "G.2X", "G.4X", "G.8X"], var.retention_structured_worker_type)
    error_message = "Worker type can only be one of G.1X, G.2X, G.4X, G.8X"
  }
}

variable "retention_structured_num_workers" {
  description = "(Optional) Number of workers to use for the retention job in structured zone. Must be >= 2"
  type        = number
  default     = 2

  validation {
    condition     = var.retention_structured_num_workers >= 2
    error_message = "Number of workers must be >= 2"
  }
}

variable "retention_curated_worker_type" {
  description = "(Optional) Worker type to use for the retention job in curated zone"
  type        = string
  default     = "G.1X"

  validation {
    condition     = contains(["G.1X", "G.2X", "G.4X", "G.8X"], var.retention_curated_worker_type)
    error_message = "Worker type can only be one of G.1X, G.2X, G.4X, G.8X"
  }
}

variable "retention_curated_num_workers" {
  description = "(Optional) Number of workers to use for the retention job in curated zone. Must be >= 2"
  type        = number
  default     = 2

  validation {
    condition     = var.retention_curated_num_workers >= 2
    error_message = "Number of workers must be >= 2"
  }
}

variable "enable_spark_ui" {
  type        = string
  default     = "true"
  description = "UI Enabled by default, override with False"
}

