from contextlib import asynccontextmanager
from fastapi import FastAPI, HTTPException
from src.crud.drop import create_new_db
from src.crud.engine import close_db
from src.schema.users import User


@asynccontextmanager
async def lifespan(app: FastAPI):
    # await create_new_db()
    pass
    yield
    await close_db()


def check_admin(user: User):
    if not user.is_admin:
        raise HTTPException(403, "Forbidden")
