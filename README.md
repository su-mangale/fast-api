
# FastAPI CRUD API with JWT Authentication & PostgreSQL

This project is a production-ready API service built with FastAPI (Python) providing:
- JWT token-based authentication for all protected endpoints
- Basic CRUD functionality
- PostgreSQL as the database
- Dev Containers for development
- Docker Compose for production deployment

Swagger UI is available at `/docs` (default FastAPI docs, no custom UI).


## Architecture

- **FastAPI**: High-performance Python web framework for building APIs
- **JWT Authentication**: Secure endpoints using JSON Web Tokens
- **PostgreSQL**: Relational database for persistent storage
- **SQLAlchemy**: ORM for database interaction
- **Alembic**: Database migrations
- **Docker**: Containerization for production deployment
- **Dev Containers**: Consistent development environment using VS Code Dev Containers

## Directory Structure

```
project/
│   README.md
│   requirements.txt
│   Dockerfile                    # Multi-stage production build
│   docker-compose.yml           # Production deployment
│   nginx.conf                   # Nginx reverse proxy config
│   alembic.ini                  # Database migration config
│   setup-env.sh                 # Environment setup script
│   ENV_GUIDE.md                 # Detailed environment guide
│   .devcontainer/               # Dev Container configuration
│       devcontainer.json
│       Dockerfile
│   app/                         # FastAPI application
│       main.py                  # API endpoints
│       models.py                # Database models
│       schemas.py               # Pydantic schemas
│       crud.py                  # Database operations
│       database.py              # Database connection
│   alembic/                     # Database migrations
│   .github/                     # GitHub configurations
│   .vscode/                     # VS Code tasks
```

## Development

### Using Dev Containers (Recommended)
1. **Prerequisites**: VS Code with Dev Containers extension
2. **Setup**: 
   ```bash
   # Clone and open project
   git clone <repository>
   cd project
   code .
   ```
3. **Start Dev Container**:
   - Command Palette (`Ctrl+Shift+P`)
   - Select: "Dev Containers: Reopen in Container"
   - Environment automatically configured with all dependencies

4. **Run Application**:
   ```bash
   # Inside dev container, start the development environment
   .devcontainer/dev-start.sh start
   ```

5. **Access API**: `http://localhost:8000/docs`

> **Note**: The dev container helper script automatically starts PostgreSQL database and FastAPI with hot reload enabled.

### Manual Setup (Alternative)
```bash
# Install dependencies
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Setup database and run migrations
# Update DATABASE_URL in app/database.py
alembic upgrade head

# Start API
uvicorn app.main:app --reload
```

### Docker Compose Deployment

#### Secure Deployment (Recommended)
```bash
# Set environment variables
export DB_PASSWORD="your_secure_db_password"
export SECRET_KEY="your_32_character_minimum_jwt_secret"
export COMPOSE_PROJECT_NAME="my-app"

# Deploy with nginx reverse proxy
docker-compose --profile production up -d

# Access API via nginx
curl http://localhost:80/health
```

**Security Features:**
- ✅ Only nginx exposed (ports 80/443)
- ✅ API isolated on internal network
- ✅ Database completely internal
- ✅ No direct API access from internet

### Simple Deployment (Less Secure)
```bash
# Deploy API directly (exposes port 8000)
docker-compose up -d

# Access API directly
curl http://localhost:8000/health
```

## Environment Variables

### Required for Production
```bash
DB_PASSWORD="secure_password"          # Database password
SECRET_KEY="jwt_secret_key_32_chars"   # JWT secret key
```

### Optional Configuration
```bash
COMPOSE_PROJECT_NAME="my-app"          # Project name
DB_USER="postgres"                     # Database user
DB_NAME="appdb"                        # Database name
API_PORT="8000"                        # API port
API_WORKERS="4"                        # FastAPI workers
NGINX_PORT="80"                        # Nginx port
```


## API Endpoints

- `POST /login` - Obtain JWT token
- `POST /register` - Register new user (hidden from docs)
- `GET /health` - Health check
- `POST /items/` - Create item (JWT required)
- `GET /items/` - List items (JWT required)
- `GET /items/{id}` - Get item by ID (JWT required)
- `PUT /items/{id}` - Update item (JWT required)
- `DELETE /items/{id}` - Delete item (JWT required)


## Security & Best Practices

- ✅ **JWT authentication** for all protected endpoints
- ✅ **Multi-stage Docker builds** for optimized images
- ✅ **Non-root containers** for security
- ✅ **Network isolation** between services
- ✅ **Health checks** for all services
- ✅ **Environment-based configuration**
- ✅ **Dev containers** for consistent development

## Commands

```bash
# Development
./setup-env.sh                              # Setup guide
code .                                       # Open in VS Code
# Then: "Dev Containers: Reopen in Container"

# Production
docker-compose --profile production up -d   # Secure deployment
docker-compose up -d                        # Simple deployment
docker-compose down                         # Stop services
docker-compose logs -f api                  # View logs

# Database
docker-compose exec api alembic upgrade head    # Run migrations
docker-compose exec db psql -U postgres -d appdb  # Access database
```


## License
MIT
