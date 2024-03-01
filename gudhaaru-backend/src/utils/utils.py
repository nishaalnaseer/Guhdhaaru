from contextlib import asynccontextmanager
from fastapi import FastAPI

from src.crud.engine import close_db
from src.crud.utils import initialise_db


@asynccontextmanager
async def lifespan(app: FastAPI):
    await initialise_db()
    yield
    await close_db()
