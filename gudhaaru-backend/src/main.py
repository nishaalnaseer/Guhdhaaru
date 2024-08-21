from typing import Annotated

from fastapi import FastAPI, Depends, HTTPException
from fastapi.params import Security
from fastapi.security import OAuth2PasswordRequestForm
from starlette import status
from starlette.middleware.cors import CORSMiddleware

from src.schema.security import Token
from src.schema.users import User
from src.security.security import (
    authenticate_user, create_access_token, get_current_active_user
)
from src.utils.utils import lifespan
from src.endpoints.main import router as v0_router

app = FastAPI(lifespan=lifespan)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # List your allowed origins here
    allow_credentials=True,
    allow_methods=["*"],  # You can restrict the HTTP methods if needed
    allow_headers=["*"],  # You can restrict the headers if needed
)
app.include_router(v0_router)


@app.post(
    "/token", response_model=Token, tags=["Users"],
    status_code=201
)
async def login_for_access_token(
        form_data: Annotated[
            OAuth2PasswordRequestForm, Depends()
        ]
):
    """
    Create a token up to specification of Oauth2 Scope Authentication
    db tables are checked to see if the user should have those modules
    """
    print(form_data.password)
    user = await authenticate_user(
        form_data.username, form_data.password
    )

    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )

    if not user.enabled:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Disabled user",
            headers={"WWW-Authenticate": "Bearer"},
        )

    access_token = create_access_token(user)
    return {
        "access_token": access_token,
        "token_type": "bearer"
    }


@app.get(
    "/users/me", response_model=User, tags=["Users"],
)
async def read_users_me(
        current_user: Annotated[
            User, Security(get_current_active_user, scopes=[])
        ]
):
    return current_user
