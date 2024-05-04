from contextlib import asynccontextmanager
from fastapi import FastAPI

from src.crud.drop import create_new_db
from src.crud.engine import close_db


@asynccontextmanager
async def lifespan(app: FastAPI):
    await create_new_db()
    yield
    await close_db()
