from pydantic import BaseModel, EmailStr, Field


class User(BaseModel):
    id: int
    email: EmailStr
    password: str = Field(..., exclude=True)


class Admin(User):
    pass


class Vendor(User):
    location: str
