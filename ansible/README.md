# FastAPI Server Configuration with Ansible

Ultra simple Ansible setup to configure EC2 instances for FastAPI with PostgreSQL.

## What This Configures

### System Setup
- System updates (Ubuntu/RedHat)
- Essential packages (git, curl, wget, vim)
- Python 3 + pip
- Docker + Docker Compose
- PostgreSQL database server
- Application user setup

### Database Setup
- PostgreSQL 15 installation
- Database creation: `fastapi_db`
- User creation: `fastapi_user` with password
- Permissions configured

### Application Deployment
- Git repository cloning
- Python dependencies installation
- Environment configuration
- Docker containers (FastAPI + PostgreSQL)
- Systemd service setup

## Prerequisites

1. **EC2 Instance**: Deploy using Terraform from `../terraform/`
2. **Ansible**: Install locally
   ```bash
   pip install ansible
   ```
3. **SSH Access**: Ensure you can SSH to your EC2 instance

## Configuration

### 1. Update Inventory

Edit `inventory/hosts.yml` with your EC2 instance IP:

```yaml
all:
  hosts:
    web_server:
      ansible_host: YOUR_EC2_PUBLIC_IP
      ansible_user: ubuntu
      ansible_ssh_private_key_file: ~/.ssh/your-key.pem
```

### 2. Configure Variables

Edit `inventory/group_vars/all.yml`:

```yaml
# Application
app_name: fastapi-app
app_port: 8000
git_repo: "https://github.com/your-username/your-repo.git"

# Database
db_name: fastapi_db
db_user: fastapi_user
db_password: fastapi_password123  # Change in production
```

## Manual Deployment

### Step 1: Test Connection
```bash
cd ansible
ansible all -i inventory/hosts.yml -m ping
```

### Step 2: Full Deployment
```bash
ansible-playbook -i inventory/hosts.yml playbooks/site.yml
```

### Step 3: Verify Deployment
```bash
# Check if app is running
curl http://YOUR_EC2_PUBLIC_IP:8000

# SSH to instance and check services
ssh -i ~/.ssh/your-key.pem ubuntu@YOUR_EC2_PUBLIC_IP
sudo systemctl status fastapi-app
sudo docker ps
```

## Alternative: Step-by-Step Deployment

### Server Configuration Only
```bash
ansible-playbook -i inventory/hosts.yml playbooks/configure-server.yml
```

### Application Deployment Only
```bash
ansible-playbook -i inventory/hosts.yml playbooks/deploy-app.yml
```

## Database Connection

Your FastAPI app will connect using:
```
DATABASE_URL=postgresql://fastapi_user:fastapi_password123@localhost:5432/fastapi_db
```

## Troubleshooting

### Check Services
```bash
# SSH to your EC2 instance
ssh -i ~/.ssh/your-key.pem ubuntu@YOUR_EC2_PUBLIC_IP

# Check application service
sudo systemctl status fastapi-app
sudo journalctl -u fastapi-app -f

# Check Docker containers
sudo docker ps
sudo docker logs fastapi-app_web_1

# Check database
sudo -u postgres psql -c "\l"
```

### Common Issues
- **Connection refused**: Check security group allows port 8000
- **Database connection**: Verify PostgreSQL is running and credentials match
- **Docker issues**: Ensure Docker service is active
