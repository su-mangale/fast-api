# Environment Management - Production + Dev Containers Only

## ✅ **Simplified Approach**

This project uses:
- 🐳 **Docker Compose** for production deployment
- 🔧 **Dev Containers** for development and testing

## 🏗️ **How It Works**

### Production
All environment variables are defined in `docker-compose.yml` with defaults:
```yaml
environment:
  DATABASE_URL: postgresql://${DB_USER:-postgres}:${DB_PASSWORD:-postgres}@db:5432/${DB_NAME:-appdb}
  SECRET_KEY: ${SECRET_KEY:-change-this-secret-key-in-production}
```

### Development
Use **Dev Containers** in VS Code for development and testing:
- Consistent environment across team
- Automatic dependency installation
- Integrated debugging and testing

## 🚀 **Usage**

### Development (Dev Containers)
```bash
# In VS Code
1. Open project folder
2. Command Palette: "Dev Containers: Reopen in Container"
3. Environment automatically set up
4. Run: uvicorn app.main:app --reload
```

### Production (Docker Compose)
```bash
# Secure deployment with nginx
export DB_PASSWORD="secure_password"
export SECRET_KEY="very_long_random_jwt_secret_key"
export COMPOSE_PROJECT_NAME="my-prod-app"

# Deploy with nginx reverse proxy (recommended)
docker-compose --profile production up -d

# Deploy API only (less secure)
docker-compose up -d
```

## 🔒 **Security Architecture**

### Production:
```
Internet → Nginx:80/443 → API:8000 (internal only) → DB:5432 (internal only)
```
- ✅ Only nginx exposed externally
- ✅ API only accessible via internal network
- ✅ Database completely isolated

### Development (Dev Containers):
```
VS Code Dev Container → Local FastAPI → Local/Container DB
```
- ✅ Isolated development environment
- ✅ Consistent across team members
- ✅ Easy testing and debugging

## 🔒 **Security Benefits**

✅ **No secrets in containers**: Environment variables never baked into images  
✅ **Runtime configuration**: All config provided at container startup  
✅ **External secrets ready**: Easy integration with Vault, K8s Secrets, etc.  
✅ **Dev isolation**: Development in containers, not host system  

## 🛠️ **Configuration**

### Required Production Variables
```bash
export DB_PASSWORD="your_secure_db_password"
export SECRET_KEY="your_32_char_minimum_jwt_secret"
```

### Optional Production Variables
```bash
export COMPOSE_PROJECT_NAME="my-app"
export DB_USER="postgres"
export DB_NAME="appdb"
export API_PORT="8000"
export API_WORKERS="4"
export NGINX_PORT="80"
```

## 📋 **Commands Reference**

```bash
# Development (Dev Containers)
# Use VS Code Dev Containers extension
# Or manually:
docker-compose -f .devcontainer/docker-compose.yml up -d

# Production (Secure - Only nginx exposed)
docker-compose --profile production up -d
docker-compose --profile production down

# Production (API only - less secure)
docker-compose up -d
docker-compose down

# Check current configuration
docker-compose config

# View environment variables in containers
docker-compose exec api env

# Test access
curl http://localhost:80/health      # Via nginx (production)
curl http://localhost:8000/health    # Direct API (if no nginx)
```

## 🌍 **Environment Variable Sources**

1. **OS Environment Variables** (highest priority)
2. **Docker Compose environment section** 
3. **Docker Compose defaults** (${VAR:-default})

## 📁 **Project Structure**

```
project/
├── .devcontainer/          # Dev Container configuration
│   ├── devcontainer.json
│   └── Dockerfile
├── app/                    # FastAPI application
├── docker-compose.yml      # Production deployment
├── Dockerfile             # Multi-stage production build
├── nginx.conf             # Nginx reverse proxy config
└── ENV_GUIDE.md           # This file
```

**Clean & Simple**: Only production deployment + dev containers for development!
