# FastAPI AWS Infrastructure with Terraform

This Terraform configuration provisions minimal AWS infrastructure to deploy the FastAPI application using a single EC2 instance.

## Architecture Overview

**Super Minimal Setup:**
- **Single EC2 Instance** in the default VPC (ap-south-1 region)
- **Ubuntu 22.04 LTS** as the operating system
- **Security Group** named "fast-api" allowing SSH and HTTP/FastAPI access
- **Default key pair** for SSH access
- **No RDS** - use local SQLite or external database service
- **No Load Balancer** - direct EC2 access
- **No Custom VPC** - uses AWS default VPC

```
┌─────────────────────────────────────────────┐
│       Default VPC (ap-south-1)             │
│  ┌─────────────────────────────────────────┐ │
│  │           Default Subnet                │ │
│  │  ┌─────────────────────────────────────┐│ │
│  │  │          EC2 Instance               ││ │
│  │  │       (Ubuntu 22.04 LTS)            ││ │
│  │  │  ┌─────────────────────────────────┐││ │
│  │  │  │        FastAPI App              │││ │
│  │  │  │      (Port 8000)                │││ │
│  │  │  │   + Local SQLite DB             │││ │
│  │  │  └─────────────────────────────────┘││ │
│  │  └─────────────────────────────────────┘│ │
│  └─────────────────────────────────────────┘ │
└─────────────────────────────────────────────┘
        ↑
    Direct Access
  (Public IP:8000)
  SSH: ubuntu@IP
```

## Prerequisites

1. **AWS CLI** configured with appropriate credentials
2. **Terraform** >= 1.0 installed
3. **AWS Account** with necessary permissions
4. **EC2 Key Pair** (optional, for SSH access)

> 📋 **Need help with AWS credentials?** See [AWS_CREDENTIALS.md](AWS_CREDENTIALS.md) for detailed setup instructions.

## Quick Start

### 1. Configure Variables

Copy and customize the example variables file:
```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your specific values:
```

Edit the file with your preferences:
```hcl
aws_region = "us-east-1"
environment = "dev"
project_name = "fastapi-app"

# Optional: EC2 key pair for SSH access
key_pair_name = "your-key-pair-name"

# Optional: Allowed CIDR blocks (restrict in production)
allowed_cidr_blocks = ["0.0.0.0/0"]
```

### 2. Initialize and Deploy

```bash
# Initialize Terraform
terraform init

# Plan the deployment
terraform plan

# Apply the configuration
terraform apply

# When prompted, type 'yes' to confirm
```

### 3. Access Your Application

After deployment, get the outputs:
```bash
# Get all outputs
terraform output

# Get specific values
terraform output instance_public_ip
terraform output application_url
terraform output ssh_connection
```

## Configuration Files

| File | Purpose |
|------|---------|
| `main.tf` | Provider configuration and version constraints |
| `variables.tf` | Input variables definition |
| `outputs.tf` | Output values after deployment |
| `ec2-simple.tf` | EC2 instance and security group configuration |
| `AWS_CREDENTIALS.md` | AWS credentials setup guide |

## Variables

### Optional Variables
- `aws_region` - AWS region (default: ap-south-1)
- `environment` - Environment name (default: dev)
- `project_name` - Project name (default: fastapi-app)
- `instance_type` - EC2 instance type (default: t3.micro)
- `key_pair_name` - EC2 key pair for SSH access (default: "default")
- `allowed_cidr_blocks` - CIDR blocks for access (default: 0.0.0.0/0)

## Security Features

### Minimal Security
- **Security Group**: Allows SSH (if key configured), HTTP (80), and FastAPI (8000)
- **IMDSv2**: Enforced on EC2 instance
- **Encrypted Storage**: EBS root volume is encrypted

### Access Control
- **Direct Access**: Application accessible via public IP
- **SSH Access**: Optional and configurable
- **Simple Health Check**: Basic HTML page served on port 8000

## Deployment Process

The EC2 instance will be created as a **clean Ubuntu 22.04 LTS** server, ready for configuration management with Ansible:

1. Ubuntu 22.04 LTS base system
2. SSH access enabled with "default" key pair
3. Security group "fast-api" with HTTP/SSH access
4. Ready for Ansible playbook execution
5. No pre-installed applications (minimal approach)

## Application Deployment

After infrastructure is provisioned, use Ansible for configuration management:

```bash
# SSH to the instance
ssh -i default.pem ubuntu@<instance-public-ip>

# Manual deployment (temporary approach):
sudo apt update && sudo apt upgrade -y
sudo apt install -y docker.io docker-compose git
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -a -G docker ubuntu

# Deploy your application
git clone <your-repo-url> /app
cd /app
docker-compose up -d
```

**Recommended: Use Ansible for automated configuration**
- Install and configure Docker
- Deploy application code
- Set up monitoring and logging
- Configure security settings

## Outputs

After successful deployment, you'll get:
- `application_url` - Main application URL (http://IP:8000)
- `application_docs` - API documentation URL (http://IP:8000/docs)
- `instance_public_ip` - EC2 instance public IP
- `ssh_connection` - SSH command (if key pair configured)

## Cost Optimization

### Super Minimal Setup
- Uses `t3.micro` instance (Free Tier eligible)
- No RDS costs - use SQLite or external DB service
- No Load Balancer costs
- No NAT Gateway costs

## Cleanup

To destroy the infrastructure:
```bash
terraform destroy
# When prompted, type 'yes' to confirm
```

## Troubleshooting

### Common Issues

1. **Application Not Accessible**
   - Check security group allows port 8000
   - Verify instance is running
   - Check user-data script logs: `/var/log/cloud-init-output.log`

2. **SSH Access Issues**
   - Ensure key pair name is correct
   - Verify security group allows port 22
   - Check CIDR blocks configuration

### Useful Commands

```bash
# Check Terraform state
terraform show

# View specific resource
terraform state show aws_instance.app_server

# Get instance logs (using AWS CLI)
aws ec2 get-console-output --instance-id $(terraform output -raw instance_id)

# SSH to instance
ssh -i default.pem ubuntu@$(terraform output -raw instance_public_ip)
```

## Database Options

Since this setup doesn't include RDS, consider these options:

1. **SQLite** (simplest) - File-based database on EC2
2. **External Service** - Use managed services like PlanetScale, Supabase
3. **Docker PostgreSQL** - Run PostgreSQL container on the same instance
4. **Add RDS Later** - Extend Terraform config when needed

## Next Steps

1. **Database**: Choose and configure database solution
2. **Ansible**: Create playbooks for server configuration
3. **SSL/TLS**: Add SSL certificate and configure HTTPS  
4. **Domain**: Point custom domain to instance IP
5. **Monitoring**: Add CloudWatch monitoring
6. **Backups**: Implement backup strategy for data
7. **CI/CD**: Set up automated deployment pipeline

## Extending the Setup

This minimal setup can be extended:

```hcl
# Add RDS database
resource "aws_db_instance" "main" {
  # ... RDS configuration
}

# Add Application Load Balancer  
resource "aws_lb" "main" {
  # ... ALB configuration
}

# Add custom VPC
resource "aws_vpc" "main" {
  # ... VPC configuration
}
```
