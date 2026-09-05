# P5-CE-RDS-Database-Layer

## Overview

This project provisions a production-ready, private MySQL database on AWS using Terraform. It is the fifth project in a Cloud Engineering portfolio series, building on top of a multi-AZ VPC foundation to deliver a fully managed relational database layer with secure credential handling and no internet exposure.

The infrastructure follows the same patterns used in real-world production deployments: the database sits inside private subnets with no public IP, credentials are generated randomly and stored in AWS Secrets Manager so they never appear in code or version control, and the networking is designed to be extended to Multi-AZ failover by flipping a single variable.

This is not a tutorial setup. The configuration choices here reflect what a senior engineer would deliver to a client who needs a database that is secure, auditable, and ready to scale.

## Architecture

![Architecture Diagram](assets/architecture.jpg)

The database lives entirely within private subnets and is never directly reachable from the internet. All traffic to the RDS instance must originate from within the VPC CIDR range. Credentials are injected at deploy time by Terraform from Secrets Manager and are never stored in any configuration file.

## Key Features

* Private RDS MySQL 8.0 instance on db.t3.micro, AWS Free Tier eligible
* Cryptographically random 16-character database password generated at deploy time
* Password stored as a structured JSON secret in AWS Secrets Manager, never in code
* Storage encrypted at rest using AES-256 via AWS-managed keys
* DB Subnet Group spanning two Availability Zones, ready for Multi-AZ promotion
* Security Group restricts MySQL access to port 3306 from within the VPC CIDR only
* Automated daily backups with a 7-day retention window
* Multi-AZ toggle controlled by a single variable for easy environment promotion
* Local values centralise naming and tagging so changes happen in one place
* All resources tagged consistently using provider-level default tags

## File Structure

```
P5-CE-RDS-Database-Layer/
|
+-- providers.tf                  AWS and Random provider config with default tags
+-- locals.tf                     Centralised naming prefix, environment, and common tags
+-- variables.tf                  All configurable inputs with sensible defaults
+-- vpc.tf                        VPC, public and private subnets, IGW, route tables
+-- security.tf                   Security group restricting inbound to port 3306 from VPC only
+-- db_subnet_group.tf            DB Subnet Group spanning two private subnets across AZs
+-- secrets.tf                    Random password generation and Secrets Manager storage
+-- rds.tf                        RDS MySQL instance with backup, encryption, and tagging
+-- outputs.tf                    Prints RDS endpoint, port, secret ARN, and DB name
+-- terraform.tfvars.example      Template showing all configurable variables
+-- .gitignore                    Excludes state files, provider cache, and tfvars
|
+-- assets/
    +-- architecture.jpg          Full infrastructure architecture diagram
    +-- terraform-apply-output.png    Terraform apply terminal output
    +-- rds-console-available.png     AWS Console confirming RDS status
```

## Prerequisites

* Terraform v1.5 or later installed and available on your PATH
* AWS CLI v2 installed and configured with sufficient IAM permissions
* An AWS account with RDS, VPC, Secrets Manager, and IAM services available in us-east-1
* Git installed locally

Verify your environment before deploying:

```bash
terraform --version
aws sts get-caller-identity
```

## Deployment

Clone the repository and navigate into the project folder:

```bash
git clone https://github.com/adeliusa486/P5-CE-RDS-Database-Layer.git
cd P5-CE-RDS-Database-Layer
```

Copy the example variables file and adjust values if needed:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Initialize Terraform to download the required providers:

```bash
terraform init
```

Review the execution plan before applying anything to your AWS account:

```bash
terraform plan
```

Deploy the infrastructure. RDS provisioning takes approximately 6 to 10 minutes because AWS allocates storage, installs the database engine, and runs first-boot configuration automatically:

```bash
terraform apply
```

When the apply completes, Terraform prints the connection details to your terminal:

```
db_name      = "p5appdb"
rds_endpoint = "p5-production-mysql.xxxxxxxx.us-east-1.rds.amazonaws.com:3306"
rds_port     = 3306
secret_arn   = "arn:aws:secretsmanager:us-east-1:xxxxxxxxxxxx:secret:p5/production/db-credentials"
```

The RDS endpoint is what your application uses to connect. The secret ARN is what your application uses to retrieve credentials from Secrets Manager at runtime without ever handling the password directly.

## Proof of Deployment

Terraform apply completed successfully with 13 resources added:

![Terraform Apply Output](assets/terraform-apply-output.png)

RDS instance confirmed available in the AWS Console:

![RDS Console](assets/rds-console-available.png)

## Cleanup

This infrastructure incurs charges while running. To destroy all resources and stop billing, run:

```bash
terraform destroy
```

Terraform deprovisions every resource in the correct dependency order. The RDS instance deletion takes approximately 3 to 5 minutes. Type yes when prompted to confirm.

If you ever enable deletion_protection on the RDS instance for a real production deployment, set it back to false before running destroy or the command will fail.

## Configuration Reference

All variables are defined in variables.tf with defaults. Override them in terraform.tfvars using the template provided.

| Variable | Default | Description |
|---|---|---|
| vpc_cidr | 10.0.0.0/16 | IP range for the entire VPC |
| db_name | p5appdb | Initial database name created inside RDS |
| db_username | dbadmin | Master username for the RDS instance |
| db_instance_class | db.t3.micro | RDS instance size |
| db_engine_version | 8.0 | MySQL version |
| db_allocated_storage | 20 | Storage in GB |
| multi_az | false | Enable Multi-AZ failover for high availability |
