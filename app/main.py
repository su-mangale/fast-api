from fastapi import FastAPI, Depends, HTTPException
from fastapi.staticfiles import StaticFiles
from fastapi.responses import HTMLResponse
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from sqlalchemy import text
import logging
from . import models, schemas, crud
from .database import SessionLocal, engine, Base
from .config import DEBUG, CORS_ORIGINS, ENVIRONMENT
from .routes_auth import router as auth_router
from .protected_routes_example import router as protected_router
from .dependencies import get_current_active_user

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Try to create database tables, but handle connection errors gracefully
try:
    # Test database connection first
    with engine.connect() as conn:
        conn.execute(text("SELECT 1"))
    logger.info("Database connection successful")
    
    # Create database tables
    Base.metadata.create_all(bind=engine)
    logger.info("Database tables created/verified")
except Exception as e:
    logger.error(f"Database connection failed: {e}")
    logger.error("Please ensure PostgreSQL is running and accessible")
    logger.error("For dev container: Start PostgreSQL or use Docker Compose")
    # Don't exit - let the app start but it will fail on database operations

# FastAPI app configuration
app = FastAPI(
    title="Fast API Built in Python with ❤️",
    description="",
    version="1.0.0",
    debug=DEBUG
)
# CORS middleware




# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include authentication and protected routes
app.include_router(auth_router)
app.include_router(protected_router)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.get("/health", tags=["DEFAULTs"])
def health_check():
    """Health check endpoint for monitoring and load balancers"""
    try:
        db = SessionLocal()
        db.execute(text("SELECT 1"))
        db.close()
        return {"status": "healthy", "database": "connected"}
    except Exception as e:
        return {"status": "unhealthy", "database": "disconnected", "error": str(e)}


@app.post("/items/", response_model=schemas.Item, tags=["CRUDs"])
def create_item(item: schemas.ItemCreate, db: Session = Depends(get_db), current_user=Depends(get_current_active_user)):
    return crud.create_item(db=db, item=item)

@app.get("/items/", response_model=list[schemas.Item], tags=["CRUDs"])
def read_items(skip: int = 0, limit: int = 100, db: Session = Depends(get_db), current_user=Depends(get_current_active_user)):
    return crud.get_items(db, skip=skip, limit=limit)

@app.get("/items/{item_id}", response_model=schemas.Item, tags=["CRUDs"])
def read_item(item_id: int, db: Session = Depends(get_db), current_user=Depends(get_current_active_user)):
    db_item = crud.get_item(db, item_id=item_id)
    if db_item is None:
        raise HTTPException(status_code=404, detail="Item not found")
    return db_item

@app.put("/items/{item_id}", response_model=schemas.Item, tags=["CRUDs"])
def update_item(item_id: int, item: schemas.ItemCreate, db: Session = Depends(get_db), current_user=Depends(get_current_active_user)):
    db_item = crud.update_item(db, item_id, item)
    if db_item is None:
        raise HTTPException(status_code=404, detail="Item not found")
    return db_item

@app.delete("/items/{item_id}", response_model=schemas.Item, tags=["CRUDs"])
def delete_item(item_id: int, db: Session = Depends(get_db), current_user=Depends(get_current_active_user)):
    db_item = crud.delete_item(db, item_id)
    if db_item is None:
        raise HTTPException(status_code=404, detail="Item not found")
    return db_item
