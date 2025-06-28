# FastAPI Server Configuration with Ansible

Ultra simple Ansible setup to configure EC2 instances for FastAPI with PostgreSQL using Docker Compose.

## What This Configures

### System Setup
- System updates (Ubuntu/RedHat)
- Essential packages (git, curl, wget, vim)
- Python 3 + pip
- Docker CE + Docker Compose (official Docker installation method)
- Application user setup

### Application Deployment
- Git repository cloning
- Environment configuration (.env file)
- Docker containers (FastAPI + PostgreSQL + Nginx via Docker Compose)
- Uses production profile from existing docker-compose.yml in repository

**Note**: PostgreSQL runs as a Docker container, not as a system service. The deployment uses the existing docker-compose.yml from your git repository with the production profile.

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
# Application Configuration
app_name: fastapi-app
git_repo: "https://github.com/your-username/your-repo.git"  # Update with your repo

# Database Configuration
db_name: fastapi_db
db_user: fastapi_user
db_password: fastapi_password123  # Change in production
```

## Manual Deployment

### Step 1: Test Connection
```bash
cd ansible
ansible all -m ping
```

### Step 2: Full Deployment (Role-based)
```bash
ansible-playbook site.yml
```

### Step 3: Alternative Deployment (Individual Playbooks)
```bash
# Server configuration only
ansible-playbook playbooks/configure-server.yml

# Application deployment only
ansible-playbook playbooks/deploy-app.yml
```

### Step 4: Verify Deployment
```bash
# Check if app is running via nginx
curl http://YOUR_EC2_PUBLIC_IP

# Check API docs
curl http://YOUR_EC2_PUBLIC_IP/docs

# SSH to instance and check Docker containers
ssh -i ~/.ssh/your-key.pem ubuntu@YOUR_EC2_PUBLIC_IP
sudo docker ps
sudo docker compose --profile production logs
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

## Docker Compose Profile

The deployment uses the production profile from your repository's docker-compose.yml:
```bash
docker compose --profile production up -d --build
```

This profile includes:
- FastAPI application container
- PostgreSQL database container
- Nginx reverse proxy (only service exposed externally)
- Internal network isolation for security

## Database Connection

Your FastAPI app connects using environment variables:
```
DB_USER=fastapi_user
DB_PASSWORD=fastapi_password123
DB_NAME=fastapi_db
DATABASE_URL=postgresql://fastapi_user:fastapi_password123@db:5432/fastapi_db
```

## Troubleshooting

### Check Services
```bash
# SSH to your EC2 instance
ssh -i ~/.ssh/your-key.pem ubuntu@YOUR_EC2_PUBLIC_IP

# Check Docker containers
sudo docker ps
sudo docker compose --profile production logs

# Check specific container logs
sudo docker logs fastapi-app-api
sudo docker logs fastapi-app-db  
sudo docker logs fastapi-app-nginx

# Check container health
sudo docker compose --profile production ps
```

### Common Issues
- **Connection refused**: Check security group allows port 80 (HTTP) and 443 (HTTPS)
- **Database connection**: Verify PostgreSQL container is running and healthy
- **Docker issues**: Ensure Docker service is active
- **Nginx issues**: Check nginx container logs
- **Repository issues**: Ensure docker-compose.yml and nginx.conf exist in your repository
