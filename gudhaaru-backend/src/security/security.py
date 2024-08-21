from datetime import timedelta, datetime
from typing import Annotated

import jwt
from fastapi import Depends, HTTPException, Security
from fastapi.security import OAuth2PasswordBearer, SecurityScopes
from jwt import InvalidTokenError
from passlib.context import CryptContext
from starlette import status

from src.crud.queries.users import auth_user
from src.schema.factrories.user import UserFactory
from src.schema.users import User
from src.schema.security import TokenData
# from src.schema.factories.user_factory import UserFactory
# from src.security.one_time_passwords import OTP
import os

from src.utils.settings import OAUTH2_SECRET, ACCESS_TOKEN_EXPIRE_MINUTES

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
_expiry = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
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
) -> str:
    try:
        payload = jwt.decode(token, OAUTH2_SECRET, algorithms=[ALGORITHM])
        username: str = payload.get("sub")

        if username is None:
            raise exception
    except InvalidTokenError:
        raise exception

    return username


async def authenticate_user(
        username: str, password: str
) -> User | bool:
    user = await auth_user(username)
    if not user:
        return False
    if not verify_password(password, user.password):
        return False
    return user


def create_access_token(user: User):
    exp = int((
        datetime.now()+timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    ).timestamp())
    to_encode = TokenData(
        sub=user.email,
        name=user.name,
        is_admin=user.is_admin,
        exp=exp
    ).model_dump()
    encoded_jwt = jwt.encode(to_encode, OAUTH2_SECRET, algorithm=ALGORITHM)
    return encoded_jwt


async def get_current_user(
        token: Annotated[str, Depends(oauth2_scheme)],
) -> User:
    username = validate_token(
        token,
        HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Could not validate credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )
    )

    user = await auth_user(username=username)

    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Could not validate credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )

    return user


async def get_current_active_user(
    current_user: Annotated[
        User, Security(get_current_user)
    ]
):
    if not current_user.enabled:
        raise HTTPException(status_code=400, detail="Inactive user")
    return current_user
