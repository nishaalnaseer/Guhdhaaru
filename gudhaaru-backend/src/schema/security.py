from typing import List

from pydantic import BaseModel, field_validator

from src.schema.users import User
from src.schema.validation import basic_string_validation


class TokenData(BaseModel):
    sub: str
    name: str
    is_admin: bool
    exp: int


class Token(BaseModel):
    access_token: str
    token_type: str

    @classmethod
    @field_validator("token_type", mode="before")
    def token_type_validation(cls, value: str):
        return basic_string_validation(value, "token_type")

    @classmethod
    @field_validator("access_token", mode="before")
    def access_token_type_validation(cls, value: str):
        return basic_string_validation(value, "access_token")

