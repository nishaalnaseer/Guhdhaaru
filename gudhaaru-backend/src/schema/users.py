from collections import defaultdict
from typing import Dict, List

from pydantic import BaseModel, EmailStr, Field


class User(BaseModel):
    id: int
    name: str
    email: EmailStr
    password: str | None = Field(exclude=True, default=None)
    is_admin: bool
    enabled: bool

    vendor_rights: Dict[int, List[str]] = defaultdict(list)
    super_admin_vendors: List[int] = []

    class Config:
        exclude = ["vendor_rights", "super_admin_vendors"]
