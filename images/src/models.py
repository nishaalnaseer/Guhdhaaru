from pydantic import BaseModel


class TokenData(BaseModel):
    sub: str
    name: str
    is_admin: bool
    exp: int
