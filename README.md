# Digital Prison Reporting Data Ingestion Pipelines

[![repo standards badge](https://img.shields.io/endpoint?labelColor=231f20&color=005ea5&style=for-the-badge&label=MoJ%20Compliant&url=https%3A%2F%2Foperations-engineering-reports.cloud-platform.service.justice.gov.uk%2Fapi%2Fv1%2Fcompliant_public_repositories%2Fendpoint%2Fmodernisation-platform-terraform-module-template&logo=data:image/png;base64,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)](https://operations-engineering-reports.cloud-platform.service.justice.gov.uk/public-report/modernisation-platform-terraform-module-template)

## Overview 
This repository contains a collection of data ingestion pipelines by source, as terraform bundles. Each bundle consists of:
- An ingestion pipeline (DMS Task)
- Batch Load Job (Step Function)
- Ongoing Replication Job (Glue Job)
In future this bundle will also include
- ELK/Grafana Monitoring Dashboard
- Pager Duty Alerting Component

## Configuring a Service Bundle
To configure a service bundle, first choose whether the service bundle is an **Oracle Bundle** or a **Postgres Bundle**. These have different configuration profiles.
- Create a directory under mappings with the name of your service. This must be use only lowercase characters and a hyphen (eg `my-service`)
- Copy the `replication-settings.json` and `table-mappings.json.tpl` files from the `/mappings/template`
- Edit these files to match your service requirements. In most cases, you only need to tweak 1 or 2 replication settings. In all cases you will need to refer to the tables you are ingesting in the service
- Add a `Terraform Variable` profile in the appropriate `config/environments`

### Configuring a Replication
TBD

### Ingestion Table Selection
For NOMIS, we are only ingesting tables that we require. You therefore need to list all the tables we are ingesting in the `table-mappings.json.tpl` file.
See the template, and add each table name by copying the template

```hcl
        # ====================================
        # Copy one entry for each table
        # Set the rule id to the next seq no
        # Give it a rule name (by convention
        # this is the schema.table name)
        # Set the source schema and table
        # ====================================
        {
            "rule-type": "selection",
            "rule-id": "51645000N",
            "rule-name": "<schema>.<table>",
            "object-locator": {
                "schema-name": "<SCHEMA>",
                "table-name": "<TABLE>"
            },
            "rule-action": "include",
            "filters": []
        }
        ...
```

### Ingestion Table Name Transformation
All incoming table names are likely to be in generic schemas (`OMS_OWNER` for NOMIS tables) and (`public` for Postgres Service Tables).
You need to change the name of the incoming schema so that ingested data does not overwrite data from another service.
In the `<environment>.tfvars` file, under your service name, add the following values

```hcl
domains = {
    <service> = {
        ...
        rename_source_schema        = "OMS_OWNER"
        rename_output_space         = "nomis"
        ...
    }
}
```

### Create an Environment Entry

1. Create an environment entry under `domains` in the appropriate environment.
2. Name it after your service
3. Set the following values
```hcl
    <service-name> = {
        setup_dms_instance          = true
        setup_rep_task              = true
        name                        = "dms-nomis-oracle-s3-<service>"
        source_engine               = "oracle"
        dms_source_name             = "oracle"
        dms_target_name             = "s3"
        short_name                  = "nomis"
        migration_type              = "full-load-and-cdc"
        rep_inst_ver                = "3.4.7"
        rep_inst_class              = "dms.t3.medium"
        replication_task_settings   = "mappings/<service>/replication-settings.json"
        table_mappings              = "mappings/<service>/table-mappings.json.tpl"
        rename_source_schema        = "<schema>"
        rename_output_space         = "<target>"
        vpc_role_dependency         = "aws_iam_role.dmsvpcrole"
        cloudwatch_role_dependency  = "aws_iam_role.dms_cloudwatch_logs_role"

        availability_zones          = {
            0 = "eu-west-2a"
        }

        extra_attributes            = "supportResetlog=TRUE"
    }
```
4. The values you need to configure are:

| Name           | Details                                                      |
|----------------|--------------------------------------------------------------|
| `service-name` | The name of your service - e.g. activities                   |
| `service`      | The service slug - e.g. activities                           |
| `schema`       | The source schema (OMS_OWNER for NOMIS, public for Postgres) |
| `target`       | The target schema (nomis for NOMIS, service slug for DPS)    |


<!--- BEGIN_TF_DOCS --->


<!--- END_TF_DOCS --->

## Looking for issues?
If you're looking to raise an issue with this module, please create a new issue in the [Modernisation Platform repository](https://github.com/ministryofjustice/modernisation-platform/issues).

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.10 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_athena_federated_query_connector_postgresql"></a> [athena\_federated\_query\_connector\_postgresql](#module\_athena\_federated\_query\_connector\_postgresql) | git::https://github.com/ministryofjustice/modernisation-platform-environments.git//terraform/environments/digital-prison-reporting/modules/athena_federated_query_connectors | main |
| <a name="module_athena_federated_query_connector_redshift"></a> [athena\_federated\_query\_connector\_redshift](#module\_athena\_federated\_query\_connector\_redshift) | git::https://github.com/ministryofjustice/modernisation-platform-environments.git//terraform/environments/digital-prison-reporting/modules/athena_federated_query_connectors | main |
| <a name="module_cdc-start-pipeline"></a> [cdc-start-pipeline](#module\_cdc-start-pipeline) | git::https://github.com/ministryofjustice/digital-prison-reporting-domain-modules.git//modules/domains/start-cdc-pipeline | main |
| <a name="module_cdc-stop-pipeline"></a> [cdc-stop-pipeline](#module\_cdc-stop-pipeline) | git::https://github.com/ministryofjustice/digital-prison-reporting-domain-modules.git//modules/domains/stop-cdc-pipeline | main |
| <a name="module_dms-cdc-task"></a> [dms-cdc-task](#module\_dms-cdc-task) | git::https://github.com/ministryofjustice/digital-prison-reporting-domain-modules.git//modules/domains/dms-task | main |
| <a name="module_dms-instance"></a> [dms-instance](#module\_dms-instance) | git::https://github.com/ministryofjustice/digital-prison-reporting-domain-modules.git//modules/domains/dms-instance | main |
| <a name="module_dms-task"></a> [dms-task](#module\_dms-task) | git::https://github.com/ministryofjustice/digital-prison-reporting-domain-modules.git//modules/domains/dms-task | main |
| <a name="module_ingestion-jobs"></a> [ingestion-jobs](#module\_ingestion-jobs) | git::https://github.com/ministryofjustice/digital-prison-reporting-domain-modules.git//modules/domains/ingestion-jobs | main |
| <a name="module_ingestion-pipeline"></a> [ingestion-pipeline](#module\_ingestion-pipeline) | git::https://github.com/ministryofjustice/digital-prison-reporting-domain-modules.git//modules/domains/ingestion-pipeline | main |
| <a name="module_ingestion-pipeline-triggers"></a> [ingestion-pipeline-triggers](#module\_ingestion-pipeline-triggers) | git::https://github.com/ministryofjustice/digital-prison-reporting-domain-modules.git//modules/eventbridge_trigger | main |
| <a name="module_lambda-setup"></a> [lambda-setup](#module\_lambda-setup) | git::https://github.com/ministryofjustice/digital-prison-reporting-domain-modules.git//modules/domains/pipeline-lambda | main |
| <a name="module_landing_zone_antivirus_check_lambda"></a> [landing\_zone\_antivirus\_check\_lambda](#module\_landing\_zone\_antivirus\_check\_lambda) | git::https://github.com/ministryofjustice/digital-prison-reporting-domain-modules.git//modules/domains/antivirus-check-lambda | main |
| <a name="module_landing_zone_processing_lambda"></a> [landing\_zone\_processing\_lambda](#module\_landing\_zone\_processing\_lambda) | git::https://github.com/ministryofjustice/digital-prison-reporting-domain-modules.git//modules/domains/landing-zone-processing-lambda | main |
| <a name="module_maintenance-pipeline"></a> [maintenance-pipeline](#module\_maintenance-pipeline) | git::https://github.com/ministryofjustice/digital-prison-reporting-domain-modules.git//modules/domains/maintenance-pipeline | main |
| <a name="module_maintenance-pipeline-triggers"></a> [maintenance-pipeline-triggers](#module\_maintenance-pipeline-triggers) | git::https://github.com/ministryofjustice/digital-prison-reporting-domain-modules.git//modules/eventbridge_trigger | main |
| <a name="module_pipeline-start-triggers"></a> [pipeline-start-triggers](#module\_pipeline-start-triggers) | git::https://github.com/ministryofjustice/digital-prison-reporting-domain-modules.git//modules/eventbridge_trigger | main |
| <a name="module_pipeline-stop-triggers"></a> [pipeline-stop-triggers](#module\_pipeline-stop-triggers) | git::https://github.com/ministryofjustice/digital-prison-reporting-domain-modules.git//modules/eventbridge_trigger | main |
| <a name="module_postgres-tickle-lambda"></a> [postgres-tickle-lambda](#module\_postgres-tickle-lambda) | git::https://github.com/ministryofjustice/digital-prison-reporting-domain-modules.git//modules/domains/postgres-tickle-lambda | main |
| <a name="module_postgres_tickle_lambda_trigger"></a> [postgres\_tickle\_lambda\_trigger](#module\_postgres\_tickle\_lambda\_trigger) | git::https://github.com/ministryofjustice/digital-prison-reporting-domain-modules.git//modules/eventbridge_trigger | main |
| <a name="module_reconciliation-jobs"></a> [reconciliation-jobs](#module\_reconciliation-jobs) | git::https://github.com/ministryofjustice/digital-prison-reporting-domain-modules.git//modules/domains/reconciliation-job | main |
| <a name="module_reload-pipeline"></a> [reload-pipeline](#module\_reload-pipeline) | git::https://github.com/ministryofjustice/digital-prison-reporting-domain-modules.git//modules/domains/reload-pipeline | main |
| <a name="module_reload-pipeline-triggers"></a> [reload-pipeline-triggers](#module\_reload-pipeline-triggers) | git::https://github.com/ministryofjustice/digital-prison-reporting-domain-modules.git//modules/eventbridge_trigger | main |
| <a name="module_replay-pipeline"></a> [replay-pipeline](#module\_replay-pipeline) | git::https://github.com/ministryofjustice/digital-prison-reporting-domain-modules.git//modules/domains/replay-pipeline | main |
| <a name="module_setup-dms-endpoints"></a> [setup-dms-endpoints](#module\_setup-dms-endpoints) | git::https://github.com/ministryofjustice/digital-prison-reporting-domain-modules.git//modules/domains/dms-endpoints | main |

## Resources

| Name | Type |
|------|------|
| [aws_athena_data_catalog.dps_data_catalog](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_data_catalog) | resource |
| [aws_athena_data_catalog.redshift_datamart_data_catalog](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_data_catalog) | resource |
| [aws_s3_object.glue_job_shared_custom_log4j_properties](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_ecr_repository.file_transfer_in_clamav_scanner](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecr_repository) | data source |
| [aws_glue_connection.glue_dps_connection](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/glue_connection) | data source |
| [aws_glue_connection.glue_nomis_connection](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/glue_connection) | data source |
| [aws_glue_connection.glue_operational_datastore_connection](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/glue_connection) | data source |
| [aws_kms_key.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_s3_bucket.artifact-store](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |
| [aws_s3_bucket.curated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |
| [aws_s3_bucket.domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |
| [aws_s3_bucket.glue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |
| [aws_s3_bucket.glue_jobs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |
| [aws_s3_bucket.landing](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |
| [aws_s3_bucket.landing_processing](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |
| [aws_s3_bucket.quarantine](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |
| [aws_s3_bucket.raw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |
| [aws_s3_bucket.raw_archive](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |
| [aws_s3_bucket.schema_registry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |
| [aws_s3_bucket.structured](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |
| [aws_s3_bucket.temp_reload](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |
| [aws_s3_bucket.violations](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |
| [aws_secretsmanager_secret.dwh_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |
| [aws_secretsmanager_secret.dps_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |
| [aws_secretsmanager_secret.nomis_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |
| [aws_secretsmanager_secret.operational_db_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |
| [aws_secretsmanager_secret.redshift](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |
| [aws_secretsmanager_secret.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |
| [aws_secretsmanager_secret_version.redshift](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |
| [aws_secretsmanager_secret_version.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |
| [aws_security_group.generic_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_subnet.data_subnets_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnet.data_subnets_b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnet.data_subnets_c](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnet.private_subnets_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_vpc.shared](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_major_version_upgrade"></a> [allow\_major\_version\_upgrade](#input\_allow\_major\_version\_upgrade) | Indicates that major version upgrades are allowed | `bool` | `true` | no |
| <a name="input_artifact_s3_bucket"></a> [artifact\_s3\_bucket](#input\_artifact\_s3\_bucket) | S3 Artifacts Bucket ID (stores code artifacts, such as jars) | `string` | `""` | no |
| <a name="input_athena_federated_query_lambda_memory_mb"></a> [athena\_federated\_query\_lambda\_memory\_mb](#input\_athena\_federated\_query\_lambda\_memory\_mb) | Amount of memory in MB the Connector Lambda Function can use at runtime. | `number` | `550` | no |
| <a name="input_athena_federated_query_lambda_reserved_concurrent_executions"></a> [athena\_federated\_query\_lambda\_reserved\_concurrent\_executions](#input\_athena\_federated\_query\_lambda\_reserved\_concurrent\_executions) | Amount of reserved concurrent executions for the Connector lambda function. A value of 0 disables the lambda from being triggered and -1 removes any concurrency limitations | `number` | n/a | yes |
| <a name="input_athena_federated_query_lambda_timeout_in_seconds"></a> [athena\_federated\_query\_lambda\_timeout\_in\_seconds](#input\_athena\_federated\_query\_lambda\_timeout\_in\_seconds) | Limit of time the Connector lambda has to run in seconds. | `number` | `900` | no |
| <a name="input_athena_postgresql_federated_query_lambda_handler"></a> [athena\_postgresql\_federated\_query\_lambda\_handler](#input\_athena\_postgresql\_federated\_query\_lambda\_handler) | The handler which will handle the Athena PostgreSQL Connector Lambda invocation. | `string` | n/a | yes |
| <a name="input_athena_redshift_federated_query_lambda_handler"></a> [athena\_redshift\_federated\_query\_lambda\_handler](#input\_athena\_redshift\_federated\_query\_lambda\_handler) | The handler which will handle the Athena Redshift Connector Lambda invocation. | `string` | n/a | yes |
| <a name="input_batch_only"></a> [batch\_only](#input\_batch\_only) | Determines if the pipeline is batch only, True or False? | `bool` | `false` | no |
| <a name="input_cdc_start_pipeline_cron_schedule_expression"></a> [cdc\_start\_pipeline\_cron\_schedule\_expression](#input\_cdc\_start\_pipeline\_cron\_schedule\_expression) | (Optional) the schedule expression on which to execute the start CDC pipeline | `string` | `null` | no |
| <a name="input_cdc_start_pipeline_max_window_in_minutes"></a> [cdc\_start\_pipeline\_max\_window\_in\_minutes](#input\_cdc\_start\_pipeline\_max\_window\_in\_minutes) | The duration in minutes within which the trigger to run the pipeline will be executed after the scheduled start time | `number` | `10` | no |
| <a name="input_cdc_stop_pipeline_cron_schedule_expression"></a> [cdc\_stop\_pipeline\_cron\_schedule\_expression](#input\_cdc\_stop\_pipeline\_cron\_schedule\_expression) | (Optional) the schedule expression on which to execute the stop CDC pipeline | `string` | `null` | no |
| <a name="input_cdc_stop_pipeline_max_window_in_minutes"></a> [cdc\_stop\_pipeline\_max\_window\_in\_minutes](#input\_cdc\_stop\_pipeline\_max\_window\_in\_minutes) | The duration in minutes within which the trigger to stop the pipeline will be executed after the scheduled stop time | `number` | `10` | no |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | CIDR for the  VPC | `list(string)` | `null` | no |
| <a name="input_compaction_curated_num_workers"></a> [compaction\_curated\_num\_workers](#input\_compaction\_curated\_num\_workers) | (Optional) Number of workers to use for the compaction job in curated zone. Must be >= 2 | `number` | `2` | no |
| <a name="input_compaction_curated_worker_type"></a> [compaction\_curated\_worker\_type](#input\_compaction\_curated\_worker\_type) | (Optional) Worker type to use for the compaction job in curated zone | `string` | `"G.1X"` | no |
| <a name="input_compaction_structured_num_workers"></a> [compaction\_structured\_num\_workers](#input\_compaction\_structured\_num\_workers) | (Optional) Number of workers to use for the compaction job in structured zone. Must be >= 2 | `number` | `2` | no |
| <a name="input_compaction_structured_worker_type"></a> [compaction\_structured\_worker\_type](#input\_compaction\_structured\_worker\_type) | (Optional) Worker type to use for the compaction job in structured zone | `string` | `"G.1X"` | no |
| <a name="input_create_ingestion_pipeline_schedule"></a> [create\_ingestion\_pipeline\_schedule](#input\_create\_ingestion\_pipeline\_schedule) | (Optional) Create the schedule for the ingestion pipeline. True or False ? | `bool` | `false` | no |
| <a name="input_create_maintenance_pipeline_schedule"></a> [create\_maintenance\_pipeline\_schedule](#input\_create\_maintenance\_pipeline\_schedule) | (Optional) Create the schedule for the maintenance pipeline. True or False ? | `bool` | `false` | no |
| <a name="input_create_postgres_tickle_schedule"></a> [create\_postgres\_tickle\_schedule](#input\_create\_postgres\_tickle\_schedule) | (Optional) Create the schedule for the postgres tickle lambda. True or False ? | `bool` | `false` | no |
| <a name="input_create_reconciliation_job_role"></a> [create\_reconciliation\_job\_role](#input\_create\_reconciliation\_job\_role) | Creates the role for the reconciliation job | `bool` | `true` | no |
| <a name="input_create_reload_pipeline_schedule"></a> [create\_reload\_pipeline\_schedule](#input\_create\_reload\_pipeline\_schedule) | (Optional) Create the schedule for the reload pipeline. True or False ? | `bool` | `false` | no |
| <a name="input_create_start_pipeline_schedule"></a> [create\_start\_pipeline\_schedule](#input\_create\_start\_pipeline\_schedule) | (Optional) Create the Schedule for the Start CDC Step Function, True or False ? | `bool` | `false` | no |
| <a name="input_create_stop_pipeline_schedule"></a> [create\_stop\_pipeline\_schedule](#input\_create\_stop\_pipeline\_schedule) | (Optional) Create the Schedule for the Stop CDC Step Function, True or False ? | `bool` | `false` | no |
| <a name="input_dms_log_group_retention_in_days"></a> [dms\_log\_group\_retention\_in\_days](#input\_dms\_log\_group\_retention\_in\_days) | (Optional) The default number of days log events retained in the DMS task log group. | `number` | `14` | no |
| <a name="input_domains"></a> [domains](#input\_domains) | Map of DOMAINS. | `map(any)` | `{}` | no |
| <a name="input_dps_source_engine"></a> [dps\_source\_engine](#input\_dps\_source\_engine) | n/a | `string` | `""` | no |
| <a name="input_enable_archive_backfill"></a> [enable\_archive\_backfill](#input\_enable\_archive\_backfill) | Boolean flag to backfill the archive before computing the reload diff during the reload process | `bool` | `false` | no |
| <a name="input_enable_cdc_start_pipeline_schedule"></a> [enable\_cdc\_start\_pipeline\_schedule](#input\_enable\_cdc\_start\_pipeline\_schedule) | Enables the schedule to start the CDC pipeline | `bool` | `false` | no |
| <a name="input_enable_cdc_stop_pipeline_schedule"></a> [enable\_cdc\_stop\_pipeline\_schedule](#input\_enable\_cdc\_stop\_pipeline\_schedule) | Enables the schedule to stop the CDC pipeline | `bool` | `false` | no |
| <a name="input_enable_ingestion_pipeline_schedule"></a> [enable\_ingestion\_pipeline\_schedule](#input\_enable\_ingestion\_pipeline\_schedule) | Enables the schedule on the ingestion pipeline | `bool` | `false` | no |
| <a name="input_enable_maintenance_pipeline_schedule"></a> [enable\_maintenance\_pipeline\_schedule](#input\_enable\_maintenance\_pipeline\_schedule) | Enables the schedule on the maintenance pipeline | `bool` | `false` | no |
| <a name="input_enable_postgres_tickle_schedule"></a> [enable\_postgres\_tickle\_schedule](#input\_enable\_postgres\_tickle\_schedule) | Enables the schedule on the postgres tickle lambda | `bool` | `false` | no |
| <a name="input_enable_reload_pipeline_schedule"></a> [enable\_reload\_pipeline\_schedule](#input\_enable\_reload\_pipeline\_schedule) | Enables the schedule on the reload pipeline | `bool` | `false` | no |
| <a name="input_enable_spark_ui"></a> [enable\_spark\_ui](#input\_enable\_spark\_ui) | UI Enabled by default, override with False | `string` | `"true"` | no |
| <a name="input_endpoints"></a> [endpoints](#input\_endpoints) | Map of Endpoints. | `map(any)` | `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Name of Environment | `string` | n/a | yes |
| <a name="input_extra_attributes"></a> [extra\_attributes](#input\_extra\_attributes) | n/a | `string` | `""` | no |
| <a name="input_glue_archive_backfill_job_log_level"></a> [glue\_archive\_backfill\_job\_log\_level](#input\_glue\_archive\_backfill\_job\_log\_level) | n/a | `string` | `"INFO"` | no |
| <a name="input_glue_archive_backfill_job_max_concurrent"></a> [glue\_archive\_backfill\_job\_max\_concurrent](#input\_glue\_archive\_backfill\_job\_max\_concurrent) | n/a | `number` | `1` | no |
| <a name="input_glue_archive_backfill_job_num_workers"></a> [glue\_archive\_backfill\_job\_num\_workers](#input\_glue\_archive\_backfill\_job\_num\_workers) | n/a | `number` | `2` | no |
| <a name="input_glue_archive_backfill_job_worker_type"></a> [glue\_archive\_backfill\_job\_worker\_type](#input\_glue\_archive\_backfill\_job\_worker\_type) | Create Archive Backfill Job | `string` | `"G.1X"` | no |
| <a name="input_glue_archive_job_log_level"></a> [glue\_archive\_job\_log\_level](#input\_glue\_archive\_job\_log\_level) | n/a | `string` | `"INFO"` | no |
| <a name="input_glue_archive_job_num_workers"></a> [glue\_archive\_job\_num\_workers](#input\_glue\_archive\_job\_num\_workers) | n/a | `number` | `2` | no |
| <a name="input_glue_archive_job_worker_type"></a> [glue\_archive\_job\_worker\_type](#input\_glue\_archive\_job\_worker\_type) | Archive | `string` | `"G.1X"` | no |
| <a name="input_glue_archive_max_concurrent"></a> [glue\_archive\_max\_concurrent](#input\_glue\_archive\_max\_concurrent) | n/a | `number` | `1` | no |
| <a name="input_glue_batch_job_log_level"></a> [glue\_batch\_job\_log\_level](#input\_glue\_batch\_job\_log\_level) | n/a | `string` | `"INFO"` | no |
| <a name="input_glue_batch_job_num_workers"></a> [glue\_batch\_job\_num\_workers](#input\_glue\_batch\_job\_num\_workers) | n/a | `number` | `2` | no |
| <a name="input_glue_batch_job_retry_max_attempts"></a> [glue\_batch\_job\_retry\_max\_attempts](#input\_glue\_batch\_job\_retry\_max\_attempts) | n/a | `number` | `10` | no |
| <a name="input_glue_batch_job_retry_max_wait_millis"></a> [glue\_batch\_job\_retry\_max\_wait\_millis](#input\_glue\_batch\_job\_retry\_max\_wait\_millis) | n/a | `number` | `10000` | no |
| <a name="input_glue_batch_job_retry_min_wait_millis"></a> [glue\_batch\_job\_retry\_min\_wait\_millis](#input\_glue\_batch\_job\_retry\_min\_wait\_millis) | n/a | `number` | `100` | no |
| <a name="input_glue_batch_job_worker_type"></a> [glue\_batch\_job\_worker\_type](#input\_glue\_batch\_job\_worker\_type) | Batch | `string` | `"G.1X"` | no |
| <a name="input_glue_batch_max_concurrent"></a> [glue\_batch\_max\_concurrent](#input\_glue\_batch\_max\_concurrent) | n/a | `number` | `1` | no |
| <a name="input_glue_cdc_cache_expiry_minutes"></a> [glue\_cdc\_cache\_expiry\_minutes](#input\_glue\_cdc\_cache\_expiry\_minutes) | n/a | `number` | `60` | no |
| <a name="input_glue_cdc_job_disable_auto_broadcast_join_threshold"></a> [glue\_cdc\_job\_disable\_auto\_broadcast\_join\_threshold](#input\_glue\_cdc\_job\_disable\_auto\_broadcast\_join\_threshold) | n/a | `bool` | `false` | no |
| <a name="input_glue_cdc_job_log_level"></a> [glue\_cdc\_job\_log\_level](#input\_glue\_cdc\_job\_log\_level) | n/a | `string` | `"INFO"` | no |
| <a name="input_glue_cdc_job_max_files_per_trigger"></a> [glue\_cdc\_job\_max\_files\_per\_trigger](#input\_glue\_cdc\_job\_max\_files\_per\_trigger) | n/a | `number` | `1000` | no |
| <a name="input_glue_cdc_job_max_records_per_file"></a> [glue\_cdc\_job\_max\_records\_per\_file](#input\_glue\_cdc\_job\_max\_records\_per\_file) | The maximum number of records per output file produced by the CDC job. Can be used to avoid overly large output files. | `number` | `0` | no |
| <a name="input_glue_cdc_job_name"></a> [glue\_cdc\_job\_name](#input\_glue\_cdc\_job\_name) | Name of the Glue CDC Job | `string` | `""` | no |
| <a name="input_glue_cdc_job_num_workers"></a> [glue\_cdc\_job\_num\_workers](#input\_glue\_cdc\_job\_num\_workers) | n/a | `number` | `2` | no |
| <a name="input_glue_cdc_job_retry_max_attempts"></a> [glue\_cdc\_job\_retry\_max\_attempts](#input\_glue\_cdc\_job\_retry\_max\_attempts) | n/a | `number` | `10` | no |
| <a name="input_glue_cdc_job_retry_max_wait_millis"></a> [glue\_cdc\_job\_retry\_max\_wait\_millis](#input\_glue\_cdc\_job\_retry\_max\_wait\_millis) | n/a | `number` | `10000` | no |
| <a name="input_glue_cdc_job_retry_min_wait_millis"></a> [glue\_cdc\_job\_retry\_min\_wait\_millis](#input\_glue\_cdc\_job\_retry\_min\_wait\_millis) | n/a | `number` | `100` | no |
| <a name="input_glue_cdc_job_spark_broadcast_timeout_seconds"></a> [glue\_cdc\_job\_spark\_broadcast\_timeout\_seconds](#input\_glue\_cdc\_job\_spark\_broadcast\_timeout\_seconds) | n/a | `number` | `300` | no |
| <a name="input_glue_cdc_job_worker_type"></a> [glue\_cdc\_job\_worker\_type](#input\_glue\_cdc\_job\_worker\_type) | n/a | `string` | `"G.1X"` | no |
| <a name="input_glue_cdc_maintenance_window"></a> [glue\_cdc\_maintenance\_window](#input\_glue\_cdc\_maintenance\_window) | (Optional) The maintenance window during which the glue job will be restarted | `string` | `"Sun:2"` | no |
| <a name="input_glue_cdc_max_cache_size"></a> [glue\_cdc\_max\_cache\_size](#input\_glue\_cdc\_max\_cache\_size) | n/a | `number` | `1000` | no |
| <a name="input_glue_cdc_max_concurrent"></a> [glue\_cdc\_max\_concurrent](#input\_glue\_cdc\_max\_concurrent) | n/a | `number` | `1` | no |
| <a name="input_glue_create_reload_diff_job_log_level"></a> [glue\_create\_reload\_diff\_job\_log\_level](#input\_glue\_create\_reload\_diff\_job\_log\_level) | n/a | `string` | `"INFO"` | no |
| <a name="input_glue_create_reload_diff_job_max_concurrent"></a> [glue\_create\_reload\_diff\_job\_max\_concurrent](#input\_glue\_create\_reload\_diff\_job\_max\_concurrent) | n/a | `number` | `1` | no |
| <a name="input_glue_create_reload_diff_job_num_workers"></a> [glue\_create\_reload\_diff\_job\_num\_workers](#input\_glue\_create\_reload\_diff\_job\_num\_workers) | n/a | `number` | `2` | no |
| <a name="input_glue_create_reload_diff_job_worker_type"></a> [glue\_create\_reload\_diff\_job\_worker\_type](#input\_glue\_create\_reload\_diff\_job\_worker\_type) | Create Reload Diffs Job | `string` | `"G.1X"` | no |
| <a name="input_glue_log_group_retention_in_days"></a> [glue\_log\_group\_retention\_in\_days](#input\_glue\_log\_group\_retention\_in\_days) | n/a | `number` | `7` | no |
| <a name="input_glue_raw_file_retention_amount"></a> [glue\_raw\_file\_retention\_amount](#input\_glue\_raw\_file\_retention\_amount) | n/a | `number` | `2` | no |
| <a name="input_glue_raw_file_retention_unit"></a> [glue\_raw\_file\_retention\_unit](#input\_glue\_raw\_file\_retention\_unit) | n/a | `string` | `"days"` | no |
| <a name="input_glue_reconciliation_job_changedatacounts_tolerance_absolute"></a> [glue\_reconciliation\_job\_changedatacounts\_tolerance\_absolute](#input\_glue\_reconciliation\_job\_changedatacounts\_tolerance\_absolute) | The absolute tolerance to use for allowing non-exact count matches in the change data counts reconciliation. | `number` | `0` | no |
| <a name="input_glue_reconciliation_job_changedatacounts_tolerance_relative_percentage"></a> [glue\_reconciliation\_job\_changedatacounts\_tolerance\_relative\_percentage](#input\_glue\_reconciliation\_job\_changedatacounts\_tolerance\_relative\_percentage) | The relative percentage tolerance to use for allowing non-exact count matches in the change data counts reconciliation. | `number` | `0` | no |
| <a name="input_glue_reconciliation_job_create_sec_conf"></a> [glue\_reconciliation\_job\_create\_sec\_conf](#input\_glue\_reconciliation\_job\_create\_sec\_conf) | n/a | `bool` | `true` | no |
| <a name="input_glue_reconciliation_job_currentstatecounts_tolerance_absolute"></a> [glue\_reconciliation\_job\_currentstatecounts\_tolerance\_absolute](#input\_glue\_reconciliation\_job\_currentstatecounts\_tolerance\_absolute) | The absolute tolerance to use for allowing non-exact count matches in the current state counts reconciliation. | `number` | `0` | no |
| <a name="input_glue_reconciliation_job_currentstatecounts_tolerance_relative_percentage"></a> [glue\_reconciliation\_job\_currentstatecounts\_tolerance\_relative\_percentage](#input\_glue\_reconciliation\_job\_currentstatecounts\_tolerance\_relative\_percentage) | The relative percentage tolerance to use for allowing non-exact count matches in the current state counts reconciliation. | `number` | `0` | no |
| <a name="input_glue_reconciliation_job_log_level"></a> [glue\_reconciliation\_job\_log\_level](#input\_glue\_reconciliation\_job\_log\_level) | n/a | `string` | `"INFO"` | no |
| <a name="input_glue_reconciliation_job_max_concurrent"></a> [glue\_reconciliation\_job\_max\_concurrent](#input\_glue\_reconciliation\_job\_max\_concurrent) | n/a | `number` | `1` | no |
| <a name="input_glue_reconciliation_job_metrics_namespace"></a> [glue\_reconciliation\_job\_metrics\_namespace](#input\_glue\_reconciliation\_job\_metrics\_namespace) | The Cloudwatch Metrics namespace to use for the Reconciliation Job's custom metrics. | `string` | n/a | yes |
| <a name="input_glue_reconciliation_job_num_workers"></a> [glue\_reconciliation\_job\_num\_workers](#input\_glue\_reconciliation\_job\_num\_workers) | n/a | `number` | `2` | no |
| <a name="input_glue_reconciliation_job_schedule"></a> [glue\_reconciliation\_job\_schedule](#input\_glue\_reconciliation\_job\_schedule) | The cron schedule (or the empty string for disabled). | `string` | `""` | no |
| <a name="input_glue_reconciliation_job_worker_type"></a> [glue\_reconciliation\_job\_worker\_type](#input\_glue\_reconciliation\_job\_worker\_type) | n/a | `string` | `"G.1X"` | no |
| <a name="input_glue_s3_max_attempts"></a> [glue\_s3\_max\_attempts](#input\_glue\_s3\_max\_attempts) | n/a | `number` | `10` | no |
| <a name="input_glue_s3_retry_max_wait_millis"></a> [glue\_s3\_retry\_max\_wait\_millis](#input\_glue\_s3\_retry\_max\_wait\_millis) | n/a | `number` | `10000` | no |
| <a name="input_glue_s3_retry_min_wait_millis"></a> [glue\_s3\_retry\_min\_wait\_millis](#input\_glue\_s3\_retry\_min\_wait\_millis) | n/a | `number` | `1000` | no |
| <a name="input_glue_unprocessed_raw_files_check_job_log_level"></a> [glue\_unprocessed\_raw\_files\_check\_job\_log\_level](#input\_glue\_unprocessed\_raw\_files\_check\_job\_log\_level) | n/a | `string` | `"INFO"` | no |
| <a name="input_glue_unprocessed_raw_files_check_job_num_workers"></a> [glue\_unprocessed\_raw\_files\_check\_job\_num\_workers](#input\_glue\_unprocessed\_raw\_files\_check\_job\_num\_workers) | n/a | `number` | `2` | no |
| <a name="input_glue_unprocessed_raw_files_check_job_worker_type"></a> [glue\_unprocessed\_raw\_files\_check\_job\_worker\_type](#input\_glue\_unprocessed\_raw\_files\_check\_job\_worker\_type) | Unprocessed raw Files Check Job | `string` | `"G.1X"` | no |
| <a name="input_glue_unprocessed_raw_files_check_max_concurrent"></a> [glue\_unprocessed\_raw\_files\_check\_max\_concurrent](#input\_glue\_unprocessed\_raw\_files\_check\_max\_concurrent) | n/a | `number` | `1` | no |
| <a name="input_ingestion_pipeline_cron_schedule_expression"></a> [ingestion\_pipeline\_cron\_schedule\_expression](#input\_ingestion\_pipeline\_cron\_schedule\_expression) | (Optional) the schedule expression on which to execute the ingestion pipeline | `string` | `null` | no |
| <a name="input_ingestion_pipeline_max_window_in_minutes"></a> [ingestion\_pipeline\_max\_window\_in\_minutes](#input\_ingestion\_pipeline\_max\_window\_in\_minutes) | The duration in minutes within which the trigger to run the ingestion pipeline will be executed after the scheduled start time | `number` | `30` | no |
| <a name="input_instances"></a> [instances](#input\_instances) | Map of DOMAINS. | `map(any)` | `{}` | no |
| <a name="input_jar_version"></a> [jar\_version](#input\_jar\_version) | n/a | `any` | n/a | yes |
| <a name="input_lambda_log_retention_in_days"></a> [lambda\_log\_retention\_in\_days](#input\_lambda\_log\_retention\_in\_days) | Lambda log retention in number of days. | `number` | `7` | no |
| <a name="input_lambda_security_group_ids"></a> [lambda\_security\_group\_ids](#input\_lambda\_security\_group\_ids) | Lambda Security Group ID's | `list(string)` | `[]` | no |
| <a name="input_lambda_subnet_ids"></a> [lambda\_subnet\_ids](#input\_lambda\_subnet\_ids) | Lambda Subnet ID's | `list(string)` | `[]` | no |
| <a name="input_landing_zone_antivirus_check_lambda_ephemeral_storage_size"></a> [landing\_zone\_antivirus\_check\_lambda\_ephemeral\_storage\_size](#input\_landing\_zone\_antivirus\_check\_lambda\_ephemeral\_storage\_size) | Disk ephemeral storage for the Landing Zone Antivirus Check Lambda in MB.Can be increased up to 10240MB if required. | `number` | `512` | no |
| <a name="input_landing_zone_antivirus_check_lambda_log_retention_in_days"></a> [landing\_zone\_antivirus\_check\_lambda\_log\_retention\_in\_days](#input\_landing\_zone\_antivirus\_check\_lambda\_log\_retention\_in\_days) | Log retention in days for the Landing Zone Antivirus Check Lambda | `number` | `7` | no |
| <a name="input_landing_zone_antivirus_check_lambda_memory_size"></a> [landing\_zone\_antivirus\_check\_lambda\_memory\_size](#input\_landing\_zone\_antivirus\_check\_lambda\_memory\_size) | Memory for the Landing Zone Antivirus Check Lambda in MB | `number` | `2048` | no |
| <a name="input_landing_zone_antivirus_check_lambda_reserved_concurrent_executions"></a> [landing\_zone\_antivirus\_check\_lambda\_reserved\_concurrent\_executions](#input\_landing\_zone\_antivirus\_check\_lambda\_reserved\_concurrent\_executions) | Maximum number of concurrent executions for the Landing Zone Antivirus Check Lambda (or -1 for unlimited)) | `number` | `10` | no |
| <a name="input_landing_zone_antivirus_check_lambda_timeout_in_seconds"></a> [landing\_zone\_antivirus\_check\_lambda\_timeout\_in\_seconds](#input\_landing\_zone\_antivirus\_check\_lambda\_timeout\_in\_seconds) | Timeout for the Landing Zone Antivirus Check Lambda in seconds | `number` | `900` | no |
| <a name="input_landing_zone_processing_lambda_csv_charset"></a> [landing\_zone\_processing\_lambda\_csv\_charset](#input\_landing\_zone\_processing\_lambda\_csv\_charset) | The CSV character set to use | `string` | `"UTF-8"` | no |
| <a name="input_landing_zone_processing_lambda_jar_s3_key"></a> [landing\_zone\_processing\_lambda\_jar\_s3\_key](#input\_landing\_zone\_processing\_lambda\_jar\_s3\_key) | The S3 key of the Landing Zone Processing Lambda jar | `string` | n/a | yes |
| <a name="input_landing_zone_processing_lambda_log_retention_in_days"></a> [landing\_zone\_processing\_lambda\_log\_retention\_in\_days](#input\_landing\_zone\_processing\_lambda\_log\_retention\_in\_days) | Log retention in days for the Landing Zone Processing Check Lambda | `number` | `7` | no |
| <a name="input_landing_zone_processing_lambda_memory_mb"></a> [landing\_zone\_processing\_lambda\_memory\_mb](#input\_landing\_zone\_processing\_lambda\_memory\_mb) | Lambda timeout in seconds. | `number` | `512` | no |
| <a name="input_landing_zone_processing_lambda_timeout_in_seconds"></a> [landing\_zone\_processing\_lambda\_timeout\_in\_seconds](#input\_landing\_zone\_processing\_lambda\_timeout\_in\_seconds) | Landing zone processing Lambda timeout in seconds. | `number` | `900` | no |
| <a name="input_landing_zone_processing_lambda_tracing"></a> [landing\_zone\_processing\_lambda\_tracing](#input\_landing\_zone\_processing\_lambda\_tracing) | Lambda Tracing | `string` | `"Active"` | no |
| <a name="input_landing_zone_processing_lambda_violations_path"></a> [landing\_zone\_processing\_lambda\_violations\_path](#input\_landing\_zone\_processing\_lambda\_violations\_path) | The path within the bucket to use when moving files classed as violations into the violations bucket | `string` | `"landing"` | no |
| <a name="input_landing_zone_processing_log_csv"></a> [landing\_zone\_processing\_log\_csv](#input\_landing\_zone\_processing\_log\_csv) | Whether to log all lines of the CSV file during landing zone processing | `bool` | `false` | no |
| <a name="input_landing_zone_processing_skip_header"></a> [landing\_zone\_processing\_skip\_header](#input\_landing\_zone\_processing\_skip\_header) | Whether to skip the first line of the CSV file | `bool` | `false` | no |
| <a name="input_maintenance_pipeline_cron_schedule_expression"></a> [maintenance\_pipeline\_cron\_schedule\_expression](#input\_maintenance\_pipeline\_cron\_schedule\_expression) | (Optional) the schedule expression on which to execute the maintenance pipeline | `string` | `null` | no |
| <a name="input_maintenance_pipeline_max_window_in_minutes"></a> [maintenance\_pipeline\_max\_window\_in\_minutes](#input\_maintenance\_pipeline\_max\_window\_in\_minutes) | The duration in minutes within which the trigger to run the maintenance pipeline will be executed after the scheduled start time | `number` | `30` | no |
| <a name="input_nomis_dms_source_name"></a> [nomis\_dms\_source\_name](#input\_nomis\_dms\_source\_name) | DMS Endpoints | `string` | `""` | no |
| <a name="input_nomis_dms_target_name"></a> [nomis\_dms\_target\_name](#input\_nomis\_dms\_target\_name) | n/a | `string` | `""` | no |
| <a name="input_nomis_short_name"></a> [nomis\_short\_name](#input\_nomis\_short\_name) | n/a | `string` | `""` | no |
| <a name="input_nomis_source_engine"></a> [nomis\_source\_engine](#input\_nomis\_source\_engine) | n/a | `string` | `""` | no |
| <a name="input_postgres_tickle_lambda_jar_s3_key"></a> [postgres\_tickle\_lambda\_jar\_s3\_key](#input\_postgres\_tickle\_lambda\_jar\_s3\_key) | Postgres Tickle Lambda Jar S3 Bucket KEY | `string` | n/a | yes |
| <a name="input_postgres_tickle_lambda_timeout_in_seconds"></a> [postgres\_tickle\_lambda\_timeout\_in\_seconds](#input\_postgres\_tickle\_lambda\_timeout\_in\_seconds) | Lambda timeout in seconds. | `number` | `60` | no |
| <a name="input_postgres_tickle_schedule_expression"></a> [postgres\_tickle\_schedule\_expression](#input\_postgres\_tickle\_schedule\_expression) | (Optional) the schedule expression on which to execute the postgres tickle lambda | `string` | `"rate(10 minutes)"` | no |
| <a name="input_processed_files_check_max_attempts"></a> [processed\_files\_check\_max\_attempts](#input\_processed\_files\_check\_max\_attempts) | Maximum number of attempts to check if all files have been processed | `number` | `3` | no |
| <a name="input_processed_files_check_wait_interval_seconds"></a> [processed\_files\_check\_wait\_interval\_seconds](#input\_processed\_files\_check\_wait\_interval\_seconds) | Amount of seconds between checks to s3 if all files have been processed | `number` | `420` | no |
| <a name="input_reload_pipeline_cron_schedule_expression"></a> [reload\_pipeline\_cron\_schedule\_expression](#input\_reload\_pipeline\_cron\_schedule\_expression) | (Optional) the schedule expression on which to execute the reload pipeline | `string` | `null` | no |
| <a name="input_reload_pipeline_max_window_in_minutes"></a> [reload\_pipeline\_max\_window\_in\_minutes](#input\_reload\_pipeline\_max\_window\_in\_minutes) | The duration in minutes within which the trigger to run the reload pipeline will be executed after the scheduled start time | `number` | `30` | no |
| <a name="input_replication_instance_class"></a> [replication\_instance\_class](#input\_replication\_instance\_class) | Instance class of replication instance | `string` | `"dms.t3.micro"` | no |
| <a name="input_replication_instance_storage"></a> [replication\_instance\_storage](#input\_replication\_instance\_storage) | Storage size in GB for the replication instance | `number` | `10` | no |
| <a name="input_reporting_lambda_code_s3_key"></a> [reporting\_lambda\_code\_s3\_key](#input\_reporting\_lambda\_code\_s3\_key) | S3 File Transfer Lambda Code Bucket KEY | `string` | `""` | no |
| <a name="input_retention_curated_num_workers"></a> [retention\_curated\_num\_workers](#input\_retention\_curated\_num\_workers) | (Optional) Number of workers to use for the retention job in curated zone. Must be >= 2 | `number` | `2` | no |
| <a name="input_retention_curated_worker_type"></a> [retention\_curated\_worker\_type](#input\_retention\_curated\_worker\_type) | (Optional) Worker type to use for the retention job in curated zone | `string` | `"G.1X"` | no |
| <a name="input_retention_structured_num_workers"></a> [retention\_structured\_num\_workers](#input\_retention\_structured\_num\_workers) | (Optional) Number of workers to use for the retention job in structured zone. Must be >= 2 | `number` | `2` | no |
| <a name="input_retention_structured_worker_type"></a> [retention\_structured\_worker\_type](#input\_retention\_structured\_worker\_type) | (Optional) Worker type to use for the retention job in structured zone | `string` | `"G.1X"` | no |
| <a name="input_script_version"></a> [script\_version](#input\_script\_version) | n/a | `any` | n/a | yes |
| <a name="input_setup_dms_endpoints"></a> [setup\_dms\_endpoints](#input\_setup\_dms\_endpoints) | n/a | `bool` | `false` | no |
| <a name="input_setup_dms_iam"></a> [setup\_dms\_iam](#input\_setup\_dms\_iam) | Enable DMS IAM, True or False | `bool` | `false` | no |
| <a name="input_setup_dms_instance"></a> [setup\_dms\_instance](#input\_setup\_dms\_instance) | Enable DMS Instance, True or False | `bool` | `false` | no |
| <a name="input_setup_dms_nomis_endpoint"></a> [setup\_dms\_nomis\_endpoint](#input\_setup\_dms\_nomis\_endpoint) | n/a | `bool` | `false` | no |
| <a name="input_setup_dms_s3_endpoint"></a> [setup\_dms\_s3\_endpoint](#input\_setup\_dms\_s3\_endpoint) | n/a | `bool` | `false` | no |
| <a name="input_setup_file_transfer_in_lambdas"></a> [setup\_file\_transfer\_in\_lambdas](#input\_setup\_file\_transfer\_in\_lambdas) | Whether to set up File Transfer In pipelines | `bool` | `false` | no |
| <a name="input_setup_ingestion_jobs"></a> [setup\_ingestion\_jobs](#input\_setup\_ingestion\_jobs) | Whether to set up Ingestion jobs or not | `bool` | `false` | no |
| <a name="input_setup_ingestion_pipeline"></a> [setup\_ingestion\_pipeline](#input\_setup\_ingestion\_pipeline) | Enable Step Function, True or False ? | `bool` | `false` | no |
| <a name="input_setup_maintenance_pipeline"></a> [setup\_maintenance\_pipeline](#input\_setup\_maintenance\_pipeline) | (Optional) Setup the maintenance pipeline. True or False ? | `bool` | `false` | no |
| <a name="input_setup_postgres_tickle_lambda"></a> [setup\_postgres\_tickle\_lambda](#input\_setup\_postgres\_tickle\_lambda) | Whether to enable the Postgres tickle lambda | `bool` | `true` | no |
| <a name="input_setup_reconciliation_job"></a> [setup\_reconciliation\_job](#input\_setup\_reconciliation\_job) | Enable Reconciliation Job, True or False ? | `bool` | `false` | no |
| <a name="input_setup_reload_pipeline"></a> [setup\_reload\_pipeline](#input\_setup\_reload\_pipeline) | Enable Reload Step Function, True or False ? | `bool` | `false` | no |
| <a name="input_setup_rep_task"></a> [setup\_rep\_task](#input\_setup\_rep\_task) | n/a | `bool` | `false` | no |
| <a name="input_setup_replay_pipeline"></a> [setup\_replay\_pipeline](#input\_setup\_replay\_pipeline) | Enable Replay Step Function, True or False ? | `bool` | `false` | no |
| <a name="input_setup_start_cdc_pipeline"></a> [setup\_start\_cdc\_pipeline](#input\_setup\_start\_cdc\_pipeline) | (Optional) Setup the Pipeline to Start the CDC Step Function, True or False ? | `bool` | `false` | no |
| <a name="input_setup_step_function_notification_lambda"></a> [setup\_step\_function\_notification\_lambda](#input\_setup\_step\_function\_notification\_lambda) | Enable Step Function Notification Lambda, True or False ? | `bool` | `false` | no |
| <a name="input_setup_stop_cdc_pipeline"></a> [setup\_stop\_cdc\_pipeline](#input\_setup\_stop\_cdc\_pipeline) | (Optional) Setup The Pipeline to Stop the CDC Step Function, True or False ? | `bool` | `false` | no |
| <a name="input_split_dms_task"></a> [split\_dms\_task](#input\_split\_dms\_task) | (Optional) Boolean flag to determine if the DMS task should be split. When true task is split to 'full-load' and 'cdc'. When false the task is 'full-load-and-cdc' | `bool` | `false` | no |
| <a name="input_step_function_notification_lambda"></a> [step\_function\_notification\_lambda](#input\_step\_function\_notification\_lambda) | Name for Notification Lambda Name | `string` | `""` | no |
| <a name="input_step_function_notification_lambda_handler"></a> [step\_function\_notification\_lambda\_handler](#input\_step\_function\_notification\_lambda\_handler) | Notification Lambda Handler | `string` | `"uk.gov.justice.digital.lambda.StepFunctionDMSNotificationLambda::handleRequest"` | no |
| <a name="input_step_function_notification_lambda_policies"></a> [step\_function\_notification\_lambda\_policies](#input\_step\_function\_notification\_lambda\_policies) | An List of Notification Lambda Policies | `list(string)` | `[]` | no |
| <a name="input_step_function_notification_lambda_runtime"></a> [step\_function\_notification\_lambda\_runtime](#input\_step\_function\_notification\_lambda\_runtime) | Lambda Runtime | `string` | `"java11"` | no |
| <a name="input_step_function_notification_lambda_sg_name"></a> [step\_function\_notification\_lambda\_sg\_name](#input\_step\_function\_notification\_lambda\_sg\_name) | Name for Notification Lambda Trigger Security Group Name | `string` | `""` | no |
| <a name="input_step_function_notification_lambda_tracing"></a> [step\_function\_notification\_lambda\_tracing](#input\_step\_function\_notification\_lambda\_tracing) | Lambda Tracing | `string` | `"Active"` | no |
| <a name="input_step_function_notification_lambda_trigger"></a> [step\_function\_notification\_lambda\_trigger](#input\_step\_function\_notification\_lambda\_trigger) | Name for Notification Lambda Trigger Name | `string` | `""` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | An List of VPC subnet IDs to use in the subnet group | `list(string)` | `[]` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID for DWH Project | `string` | `""` | no |
| <a name="input_working_s3_bucket"></a> [working\_s3\_bucket](#input\_working\_s3\_bucket) | S3 Working Bucket ID (used as an Athena spill bucket) | `string` | `""` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
# datahub-domains-pipeline
