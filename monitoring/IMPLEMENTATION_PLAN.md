# Simple Monitoring Deployment Plan

## 🎯 Overview
Deploy monitoring stack (Grafana, Loki, Prometheus) to AWS using Terraform and Ansible.

## 📋 Deployment Steps

### Step 1: Prepare AWS Infrastructure (15 minutes)
```bash
cd monitoring/terraform
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your AWS key pair name
terraform init
terraform plan
terraform apply
```

### Step 2: Deploy Monitoring Stack (10 minutes)
```bash
cd monitoring/ansible
# Update inventory file with IP from terraform output
ansible-playbook -i inventory deploy-monitoring.yml
```

### Step 3: Configure FastAPI App (10 minutes)
Add to your FastAPI app:
```python
from prometheus_fastapi_instrumentator import Instrumentator

app = FastAPI()
Instrumentator().instrument(app).expose(app)
```

### Step 4: Access Services
- **Grafana**: http://YOUR_SERVER_IP:3000 (admin/admin)
- **Prometheus**: http://YOUR_SERVER_IP:9090

## 📊 What You Get

- **Metrics**: Request rate, response time, error rate
- **Logs**: Application logs in one place
- **Dashboards**: Visual monitoring interface
- **Simple**: No complex alerting or extra features

## 🔧 Manual Commands

If needed, SSH to the server and run:
```bash
cd /opt/monitoring
docker-compose -f docker-compose.monitoring.yml up -d
```

## 📝 Next Steps

1. Add logging to your FastAPI app to write to `/var/log/fastapi/app.log`
2. Create custom Grafana dashboards
3. Set up log rotation
4. Configure backup if needed

This simple setup gives you core monitoring without complexity.
