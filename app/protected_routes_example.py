from fastapi import APIRouter, Depends
from app.dependencies import get_current_active_user

router = APIRouter()

@router.get("/protected")
def protected_route(current_user = Depends(get_current_active_user)):
    return {"message": f"Hello, {current_user.username}. You are authenticated."}
