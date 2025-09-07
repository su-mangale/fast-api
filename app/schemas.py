from pydantic import BaseModel

class ItemBase(BaseModel):
    name: str
    description: str

class ItemCreate(ItemBase):
    pass


class UserCreate(BaseModel):
    username: str
    password: str

class Item(ItemBase):
    id: int
    class Config:
        from_attributes = True
