from datetime import timedelta
from typing import Annotated

from fastapi import FastAPI, Depends, HTTPException
from fastapi.security import OAuth2PasswordRequestForm
from starlette import status
from starlette.middleware.cors import CORSMiddleware
import os
from src.schema.security import Token
from src.utils.utils import lifespan

app = FastAPI(lifespan=lifespan)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*.nishawl.dev", "nishawl.dev"],  # List your allowed origins here
    allow_credentials=True,
    allow_methods=["*"],  # You can restrict the HTTP methods if needed
    allow_headers=["*"],  # You can restrict the headers if needed
)


_expires = timedelta(minutes=int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES")))


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
    user_data = await authenticate_user(
        form_data.username, form_data.password
    )

    if not user_data:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )

    user = UserFactory.create_full_user(user_data)
    if user.status != "ENABLED":
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )

    scopes = user.permissions

    access_token_expires = _expires
    access_token = create_access_token(
        data={
            "sub": user.email,
            "scopes": list(scopes),
            "full_name": user.name,
            "is_club_rep": _is_club_rep,
            "roles": [x.name for x in user.roles]
        },
        expires_delta=access_token_expires
    )
    return {
        "access_token": access_token,
        "token_type": "bearer"
    }
