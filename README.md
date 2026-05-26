
<img width="1619" height="971" alt="ChatGPT Image May 26, 2026, 06_22_36 PM" src="https://github.com/user-attachments/assets/029563b3-5c60-4d01-b57e-11b0d9e701d7" />




# AWS Multi-Environment Infrastructure Terraform Module

This repository contains a modular Terraform configuration to deploy multi-environment (Dev, Stg, Prod) infrastructure on AWS. It uses a reusable local module (`infra-app`) to define and provision standard resources for each environment.

---

## Architecture Overview

The configuration provisions the following resources for each environment:

1. **EC2 Instances**:
   - Deploys a configurable number of EC2 instances with specified AMI and instance types.
   - Attaches a root block device with volume sizes dynamic based on the environment:
     - **Production (`prod`)**: 20 GB GP3 volume.
     - **Other environments (`dev`, `stg`)**: 10 GB GP3 volume.
   - Associates a public IP address.
2. **Security Group**:
   - Restricts and controls traffic to the EC2 instances.
   - Allows inbound **SSH (port 22)** and **HTTP (port 80)** from all IP addresses (`0.0.0.0/0`).
   - Allows all outbound traffic.
3. **AWS Key Pair**:
   - Deploys an SSH key pair (`ec2-key`) referencing a local public key file (`ec2-key.pub`).
4. **DynamoDB Table**:
   - Creates a DynamoDB table with `PAY_PER_REQUEST` billing mode.
   - Configured with a dynamic name based on the environment and a customizable partition key (`hash_key`).
5. **Default VPC**:
   - Uses the default AWS VPC in the target region.

---

## Directory Structure

```text
terraform-module/
├── ec2-key                    # Private key (sensitive - keep secure)
├── ec2-key.pub                # Public key used for AWS EC2 instance SSH access
├── main.tf                    # Main entry point initiating Dev, Stg, and Prod environments
├── provider.tf                # AWS provider configurations (empty/inherited)
├── terraform.tf               # Terraform settings and version constraints (empty)
└── infra-app/                 # Reusable Module Directory
    ├── dynamodb.tf            # DynamoDB Table definition
    ├── ec2.tf                 # EC2 Instance, Key Pair, and Security Group definitions
    ├── s3.tf                  # Placeholder for S3 configurations (currently empty)
    └── variable.tf            # Submodule variable declarations
```

---

## Module Variables (`infra-app`)

The `infra-app` module accepts the following inputs:

| Name | Description | Type | Required |
| :--- | :--- | :--- | :--- |
| `env` | The target deployment environment (e.g., `dev`, `stg`, `prod`) | `string` | **Yes** |
| `bucket_name` | Name for the S3 bucket (placeholder) | `string` | **Yes** |
| `instance_count` | Number of EC2 instances to provision | `number` | **Yes** |
| `instance_type` | EC2 instance type (e.g., `t3.micro`, `t3.small`) | `string` | **Yes** |
| `ec2_ami_id` | AMI ID for the EC2 instances | `string` | **Yes** |
| `hash_key` | Hash key (partition key) name for the DynamoDB table | `string` | **Yes** |

---

## Configured Environments

The root [`main.tf`](file:///home/vithal/Anti/terraform-module/main.tf) defines three environments:

### 1. Dev Environment (`dev-infra`)
- **Instance Count**: 1
- **Instance Type**: `t3.micro`
- **Root Volume**: 10 GB
- **DynamoDB Table**: `dev-infra-app-table`

### 2. Staging Environment (`stg-infra`)
- **Instance Count**: 1
- **Instance Type**: `t3.small`
- **Root Volume**: 10 GB
- **DynamoDB Table**: `stg-infra-app-table`

### 3. Production Environment (`prod-infra`)
- **Instance Count**: 2
- **Instance Type**: `t3.micro`
- **Root Volume**: 20 GB
- **DynamoDB Table**: `prod-infra-app-table`

---

## Prerequisites

1. Install [Terraform](https://www.terraform.io/downloads) (version `>= 1.0`).
2. Install the [AWS CLI](https://aws.amazon.com/cli/) and configure it with your AWS credentials:
   ```bash
   aws configure
   ```
3. Generate or ensure SSH keys (`ec2-key` and `ec2-key.pub`) exist in the project root. If they don't, you can generate them using:
   ```bash
   ssh-keygen -f ec2-key
   ```

---

## Usage

Follow these steps to deploy the infrastructure:

### 1. Initialize Terraform
Initialize the working directory to download the required AWS provider plugins and register the local modules:
```bash
terraform init
```

### 2. Validate Configuration
Validate that the syntax and configuration are correct:
```bash
terraform validate
```

### 3. Plan Deployment
Preview the resource changes Terraform plans to make:
```bash
terraform plan
```

### 4. Apply Configuration
Deploy the resources to AWS (requires confirmation unless `--auto-approve` is passed):
```bash
terraform apply
```

### 5. Destroy Infrastructure
To clean up and tear down all created AWS resources:
```bash
terraform destroy
```
