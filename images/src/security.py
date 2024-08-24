from typing import Annotated

import jwt
from fastapi import HTTPException, Depends
from fastapi.security import OAuth2PasswordBearer
from jwt import InvalidTokenError
from starlette import status

from src.models import TokenData
from src.settings import OAUTH2_SECRET

ALGORITHM = "HS256"
oauth2_scheme = OAuth2PasswordBearer(
    tokenUrl="token",
)


def validate_token(
        token: Annotated[str, Depends(oauth2_scheme)],
) -> TokenData:
    try:
        payload = jwt.decode(token, OAUTH2_SECRET, algorithms=[ALGORITHM])
        username: str = payload.get("sub")

        if username is None:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Could not validate credentials",
                headers={"WWW-Authenticate": "Bearer"},
            )
    except InvalidTokenError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Could not validate credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )

    token_data = TokenData(**payload)

    if not token_data.is_admin:
        HTTPException(
            401, "Not Authorised"
        )

    return token_data


# async def get_token(
#         token: Annotated[str, Depends(oauth2_scheme)],
# ) -> User:
#     token_data = validate_token(
#         token
#     )
#
#     return user
