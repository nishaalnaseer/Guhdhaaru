from datetime import timedelta, datetime
from typing import Annotated

import jwt
from fastapi import Depends, HTTPException, Security
from fastapi.security import OAuth2PasswordBearer, SecurityScopes
from jwt import InvalidTokenError
from passlib.context import CryptContext
from starlette import status
from src.schema.users import User
from src.schema.security import TokenData
# from src.schema.factories.user_factory import UserFactory
# from src.security.one_time_passwords import OTP
import os

from src.utils.settings import OAUTH2_SECRET

# variables :
# OAUTH2_SECRET - get with ```openssl rand -hex 32```
# PASSWORD_RESET_TOKEN_EXPIRE_MINUTES

ALGORITHM = "HS256"
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# EMAILS = EmailClient(
#     server=os.getenv("MAILING_SERVER"),
#     port=os.getenv("SMTP_PORT"),
#     username=os.getenv("MAILING_USERNAME"),
#     password=os.getenv("MAILING_PASSWORD"),
# )
oauth2_scheme = OAuth2PasswordBearer(
    tokenUrl="token",
)
# otp = OTP(os.environ.get("OTP_SECRET"))


def verify_password(plain_password: str, hashed_password: str):
    """
        Verify the password
        :param: plain_password
        :param: hashed password
        :return: boolean, true if correct
    """
    return pwd_context.verify(plain_password, hashed_password)


def get_password_hash(password):
    return pwd_context.hash(password)


def validate_token(
        token: str,
        exception: HTTPException,
) -> TokenData:
    try:
        payload = jwt.decode(token, OAUTH2_SECRET, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        password: str = payload.get("password")

        if username is None:
            raise exception
        token_data = TokenData(
            username=username,
            password=password,
        )
    except InvalidTokenError:
        raise exception

    return token_data


async def authenticate_user(
        username: str, password: str
) -> dict | bool:
    user = await auth_user(username)
    if not user:
        return False
    if not verify_password(password, user["user"].password):
        return False
    return user


def create_access_token(
        data: dict, expires_delta: timedelta | None = None
):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.now() + expires_delta
    else:
        expire = datetime.now() + timedelta(days=150)
    to_encode.update({"exp": expire})
    print(expire.timestamp())
    encoded_jwt = jwt.encode(to_encode, OAUTH2_SECRET, algorithm=ALGORITHM)
    return encoded_jwt
