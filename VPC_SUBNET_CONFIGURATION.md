# VPC and Subnet Configuration Update

## Overview

The VPC and subnet configuration has been updated to use **configurable variables** instead of tag-based lookups. This allows you to easily switch between different VPCs and subnets by updating the `development.tfvars` file.

---

## Changes Made

### 1. **variables.tf** - Added New Variables

Three new variables have been added to support VPC and subnet configuration:

```hcl
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
```

### 2. **data.tf** - Updated Data Sources

Changed from **tag-based lookup** to **direct ID reference**:

**Before:**
```hcl
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
```

**After:**
```hcl
data "aws_vpc" "shared" {
  id = var.vpc_id
}

data "aws_subnet" "data_subnets_a" {
  id = length(var.data_subnet_ids) > 0 ? var.data_subnet_ids[0] : var.subnet_ids[0]
}
```

### 3. **config/development.tfvars** - Added VPC Configuration

```hcl
# VPC and Networking
vpc_id = "vpc-0dba1e33a98b66fea"

# Subnets for the new VPC (eu-west-1)
subnet_ids = [
  "subnet-01ec4a4e34cf000c1",  # eu-west-1a
  "subnet-016203c27632ab6ee",  # eu-west-1b
  "subnet-03b7cbf7a1f1bcacd"   # eu-west-1c
]

# Data subnets (if different from general subnets)
data_subnet_ids = [
  "subnet-01ec4a4e34cf000c1",  # eu-west-1a
  "subnet-016203c27632ab6ee",  # eu-west-1b
  "subnet-03b7cbf7a1f1bcacd"   # eu-west-1c
]

# Private subnets (if different from general subnets)
private_subnet_ids = [
  "subnet-01ec4a4e34cf000c1",  # eu-west-1a
  "subnet-016203c27632ab6ee",  # eu-west-1b
  "subnet-03b7cbf7a1f1bcacd"   # eu-west-1c
]
```

---

## Benefits

✅ **Easy Configuration** - Change VPC/subnets by editing `development.tfvars`  
✅ **No Tag Dependencies** - Works with any VPC, regardless of naming conventions  
✅ **Flexible** - Can use different subnets for data vs. private resources  
✅ **Fallback Logic** - If specific subnet lists are empty, falls back to general `subnet_ids`  
✅ **Environment-Specific** - Each environment can have its own configuration file

---

## How to Use

### For Development Environment

The configuration is already set in `config/development.tfvars` with:
- **VPC ID**: `vpc-0dba1e33a98b66fea`
- **Subnets**: 3 subnets across eu-west-1a, eu-west-1b, eu-west-1c

### For Other Environments

Create similar configuration files:
- `config/staging.tfvars`
- `config/production.tfvars`

Example for staging:
```hcl
vpc_id = "vpc-xxxxxxxxxxxxx"
subnet_ids = [
  "subnet-xxxxxxxxx",  # eu-west-1a
  "subnet-yyyyyyyyy",  # eu-west-1b
  "subnet-zzzzzzzzz"   # eu-west-1c
]
```

### Running Terraform

```bash
# Development
terraform apply -var-file="config/development.tfvars"

# Staging
terraform apply -var-file="config/staging.tfvars"

# Production
terraform apply -var-file="config/production.tfvars"
```

---

## Subnet Mapping

The configuration maps subnets to different purposes:

| Variable | Purpose | Default |
|----------|---------|---------|
| `subnet_ids` | General subnets for all resources | Required |
| `data_subnet_ids` | Specific subnets for data layer | Falls back to `subnet_ids` |
| `private_subnet_ids` | Specific subnets for private resources | Falls back to `subnet_ids` |

---

## Current Configuration (Development)

```
VPC: vpc-0dba1e33a98b66fea

Subnets:
├── eu-west-1a: subnet-01ec4a4e34cf000c1
├── eu-west-1b: subnet-016203c27632ab6ee
└── eu-west-1c: subnet-03b7cbf7a1f1bcacd
```

---

## Files Modified

1. ✅ `variables.tf` - Added 3 new variables
2. ✅ `data.tf` - Updated VPC and subnet data sources
3. ✅ `config/development.tfvars` - Added VPC and subnet configuration

---

## Next Steps

1. Run `terraform plan` to verify the changes
2. Review the plan to ensure all resources are correctly mapped to the new VPC/subnets
3. Run `terraform apply` to apply the changes
4. Monitor the deployment for any issues


