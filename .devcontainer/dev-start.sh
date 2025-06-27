#!/bin/bash

# Simple development setup script
# This runs the external services via Docker and starts the FastAPI app locally

echo "🚀 Starting FastAPI Development Environment"

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if we're inside a dev container or local environment
if [ -f /.dockerenv ]; then
    echo "📦 Running inside dev container"
    IN_CONTAINER=true
else
    echo "💻 Running on local host"
    IN_CONTAINER=false
fi

case "$1" in
    "start")
        echo "🐘 Starting PostgreSQL database..."
        docker run -d --name fastapi-dev-db \
            -e POSTGRES_USER=postgres \
            -e POSTGRES_PASSWORD=postgres \
            -e POSTGRES_DB=appdb \
            -p 5432:5432 \
            postgres:15 || echo "Database container already running or failed to start"
        
        echo "⏳ Waiting for database to be ready..."
        sleep 5
        
        echo "🔧 Running database migrations..."
        if command_exists alembic; then
            alembic upgrade head
        else
            echo "⚠️  Alembic not found, skipping migrations"
        fi
        
        echo "🚀 Starting FastAPI development server..."
        uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
        ;;
    
    "stop")
        echo "🛑 Stopping development services..."
        docker stop fastapi-dev-db 2>/dev/null || true
        docker rm fastapi-dev-db 2>/dev/null || true
        echo "✅ Services stopped"
        ;;
    
    "logs")
        echo "📋 Database logs:"
        docker logs fastapi-dev-db --tail 20
        ;;
    
    "status")
        echo "📊 Service Status:"
        docker ps --filter name=fastapi-dev
        ;;
    
    "reset-db")
        echo "� Resetting database..."
        docker stop fastapi-dev-db 2>/dev/null || true
        docker rm fastapi-dev-db 2>/dev/null || true
        
        echo "🐘 Starting fresh PostgreSQL database..."
        docker run -d --name fastapi-dev-db \
            -e POSTGRES_USER=postgres \
            -e POSTGRES_PASSWORD=postgres \
            -e POSTGRES_DB=appdb \
            -p 5432:5432 \
            postgres:15
        
        echo "⏳ Waiting for database to be ready..."
        sleep 8
        
        echo "� Running database migrations..."
        if command_exists alembic; then
            alembic upgrade head
        else
            echo "⚠️  Alembic not found, skipping migrations"
        fi
        
        echo "✅ Database reset complete"
        ;;
    
    *)
        echo "🔧 FastAPI Development Helper"
        echo ""
        echo "Usage: $0 {start|stop|logs|status|reset-db}"
        echo ""
        echo "Commands:"
        echo "  start     - Start database + FastAPI development server"
        echo "  stop      - Stop all development services"
        echo "  logs      - Show database logs"
        echo "  status    - Show status of services"
        echo "  reset-db  - Reset database and run migrations"
        echo ""
        echo "Environment:"
        echo "  Database URL: postgresql://postgres:postgres@localhost:5432/appdb"
        echo "  FastAPI:      http://localhost:8000"
        echo "  API Docs:     http://localhost:8000/docs"
        ;;
esac
