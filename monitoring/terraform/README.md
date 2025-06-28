# Monitoring Infrastructure

This Terraform configuration creates AWS infrastructure for the monitoring stack.

## Resources Created

- **EC2 Instance**: t3.medium Ubuntu 22.04 server
- **Security Group**: Allows access to monitoring ports (3000, 9090, 3100) and SSH
- **Root Volume**: 20GB encrypted GP3 storage

## Deployment

1. **Configure variables**:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your values
   ```

2. **Deploy infrastructure**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

3. **Get connection details**:
   ```bash
   terraform output
   ```

## Outputs

- `monitoring_server_ip`: Public IP address
- `grafana_url`: Direct link to Grafana dashboard
- `prometheus_url`: Direct link to Prometheus
- `ssh_command`: SSH command to connect to server

## Variables

- `project_name`: Project identifier (default: fastapi-monitoring)
- `environment`: Environment tag (default: dev)
- `instance_type`: EC2 instance size (default: t3.medium)
- `key_pair_name`: AWS key pair for SSH access
- `allowed_cidr_blocks`: IP ranges allowed to access services

## Cleanup

```bash
terraform destroy
```
