# Simple FastAPI Dev Container

This is a minimal, simple dev container setup for FastAPI development that just works.

## What You Get

- **Python 3.11** development environment
- **Docker-in-Docker** for running external services
- **VS Code extensions** for Python development
- **Simple helper script** to manage services

## Quick Start

1. Open project in VS Code
2. Click "Reopen in Container" 
3. Inside the container, run:

```bash
# Start development environment
.devcontainer/dev-start.sh start
```

## How It Works

### Simple Architecture
- **Dev Container**: Your Python/FastAPI development environment
- **External Database**: PostgreSQL runs as a separate Docker container
- **Direct Access**: FastAPI runs directly in the dev container

### Service Management

```bash
# Start development (database + FastAPI)
.devcontainer/dev-start.sh start

# Stop all services
.devcontainer/dev-start.sh stop

# Check service status
.devcontainer/dev-start.sh status

# View database logs
.devcontainer/dev-start.sh logs

# Reset database and run migrations
.devcontainer/dev-start.sh reset-db
```

## Access Points

- **FastAPI**: `http://localhost:8000`
- **API Documentation**: `http://localhost:8000/docs`
- **Database**: `localhost:5432`

## Environment Variables

The setup uses these defaults:
- `DATABASE_URL`: `postgresql://postgres:postgres@localhost:5432/appdb`
- `API_HOST`: `0.0.0.0`
- `API_PORT`: `8000`

## Benefits of This Approach

✅ **Simple**: Single dev container + external database  
✅ **Fast**: Quick startup, no complex orchestration  
✅ **Reliable**: Minimal dependencies, fewer failure points  
✅ **Debug-Friendly**: Direct access to FastAPI process  
✅ **SSH-Compatible**: No WSL detection issues  

## Development Workflow

1. **Start services**: `.devcontainer/dev-start.sh start`
2. **Develop**: Edit code, hot reload works automatically
3. **Test**: Access your API at `http://localhost:8000`
4. **Debug**: Full VS Code debugging support
5. **Stop**: `.devcontainer/dev-start.sh stop` when done

## Troubleshooting

### Port conflicts
- Check what's using ports: `netstat -tlnp | grep :8000`
- Stop conflicting services or change ports

### Database issues
- Check if database is running: `.devcontainer/dev-start.sh status`
- View database logs: `.devcontainer/dev-start.sh logs`
- Reset database: `.devcontainer/dev-start.sh reset-db`

### Container issues
- Rebuild container: Command Palette → "Dev Containers: Rebuild Container"
