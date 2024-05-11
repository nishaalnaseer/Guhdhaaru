from pydantic import BaseModel, EmailStr, Field


class User(BaseModel):
    id: int
    name: str
    email: EmailStr
    password: str | None = Field(exclude=True, default=None)
    is_admin: bool
