from contextlib import asynccontextmanager
from fastapi import FastAPI

from src.crud.engine import close_db


@asynccontextmanager
async def lifespan(app: FastAPI):
    pass
    yield
    await close_db()
