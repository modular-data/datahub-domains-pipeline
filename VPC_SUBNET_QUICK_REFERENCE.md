# VPC & Subnet Configuration - Quick Reference

## Current Development Configuration

```
VPC ID:           vpc-0dba1e33a98b66fea
Region:           eu-west-1
Subnets:          3 (across 3 AZs)

Subnet Details:
├── Subnet A (eu-west-1a): subnet-01ec4a4e34cf000c1
├── Subnet B (eu-west-1b): subnet-016203c27632ab6ee
└── Subnet C (eu-west-1c): subnet-03b7cbf7a1f1bcacd
```

---

## Configuration Files

### `variables.tf`
Defines three new variables:
- `subnet_ids` - General subnets
- `data_subnet_ids` - Data layer subnets (optional)
- `private_subnet_ids` - Private resource subnets (optional)

### `data.tf`
Updated data sources:
- `data.aws_vpc.shared` - Now uses `var.vpc_id` directly
- `data.aws_subnet.data_subnets_*` - Now uses `var.data_subnet_ids`
- `data.aws_subnet.private_subnets_*` - Now uses `var.private_subnet_ids`

### `config/development.tfvars`
Contains the actual VPC and subnet IDs for development environment.

---

## How to Change VPC/Subnets

### Option 1: Edit development.tfvars (Recommended)

```hcl
# config/development.tfvars

vpc_id = "vpc-NEW-ID-HERE"

subnet_ids = [
  "subnet-NEW-ID-1",  # eu-west-1a
  "subnet-NEW-ID-2",  # eu-west-1b
  "subnet-NEW-ID-3"   # eu-west-1c
]

data_subnet_ids = [
  "subnet-NEW-ID-1",
  "subnet-NEW-ID-2",
  "subnet-NEW-ID-3"
]

private_subnet_ids = [
  "subnet-NEW-ID-1",
  "subnet-NEW-ID-2",
  "subnet-NEW-ID-3"
]
```

### Option 2: Command Line Override

```bash
terraform apply \
  -var="vpc_id=vpc-NEW-ID" \
  -var="subnet_ids=[\"subnet-1\",\"subnet-2\",\"subnet-3\"]" \
  -var-file="config/development.tfvars"
```

---

## Terraform Commands

### Plan Changes
```bash
terraform plan -var-file="config/development.tfvars"
```

### Apply Changes
```bash
terraform apply -var-file="config/development.tfvars"
```

### Validate Configuration
```bash
terraform validate
```

### Show Current State
```bash
terraform show
```

---

## Fallback Logic

If you don't specify `data_subnet_ids` or `private_subnet_ids`, they automatically fall back to `subnet_ids`:

```
data_subnet_ids not set?  → Use subnet_ids
private_subnet_ids not set? → Use subnet_ids
```

This means you can use the same subnets for all purposes if needed.

---

## Troubleshooting

### Error: "VPC not found"
- Check that `vpc_id` is correct
- Verify the VPC exists in your AWS account
- Ensure you're in the correct AWS region

### Error: "Subnet not found"
- Check that subnet IDs are correct
- Verify subnets exist in the specified VPC
- Ensure subnets are in the correct region

### Error: "Subnet not in VPC"
- Verify all subnet IDs belong to the specified VPC
- Check AWS console to confirm subnet-to-VPC mapping

---

## Files Modified

| File | Changes |
|------|---------|
| `variables.tf` | Added 3 new variables |
| `data.tf` | Updated VPC and subnet data sources |
| `config/development.tfvars` | Added VPC and subnet configuration |

---

## Related Resources

- AWS VPC Documentation: https://docs.aws.amazon.com/vpc/
- Terraform AWS Provider: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
- Terraform Variables: https://www.terraform.io/language/values/variables


