# FastAPI Monitoring Stack

Simple monitoring setup for FastAPI applications using Grafana, Loki, and Prometheus.

## 📊 Stack Components

- **Prometheus**: Metrics collection
- **Grafana**: Visualization dashboards
- **Loki**: Log aggregation
- **Promtail**: Log collection

## 🚀 Deployment

### 1. Deploy AWS Infrastructure with Terraform

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your configuration
terraform init
terraform plan
terraform apply
```

### 2. Deploy Monitoring Stack with Ansible

```bash
cd ansible
# Update inventory file with the IP from terraform output
ansible-playbook -i inventory deploy-monitoring.yml
```

### 3. Access Services

After deployment, get the URLs from terraform output:
```bash
cd terraform
terraform output
```

- **Grafana**: Use the `grafana_url` output (admin/admin)
- **Prometheus**: Use the `prometheus_url` output

## 📁 Directory Structure

```
monitoring/
├── terraform/          # AWS infrastructure
├── ansible/            # Configuration deployment
├── prometheus/         # Metrics configuration
├── grafana/            # Visualization setup
├── loki/               # Log storage
├── promtail/           # Log collection
└── docker-compose.monitoring.yml
```

## � FastAPI Integration

Add to your FastAPI app:

```python
from prometheus_fastapi_instrumentator import Instrumentator

app = FastAPI()
Instrumentator().instrument(app).expose(app)
```

## 📝 Logging

Configure your app to write logs to `/var/log/fastapi/app.log`

## 🔍 Manual Commands

```bash
# Start stack
docker-compose -f docker-compose.monitoring.yml up -d

# Stop stack
docker-compose -f docker-compose.monitoring.yml down

# View logs
docker-compose -f docker-compose.monitoring.yml logs -f
```
