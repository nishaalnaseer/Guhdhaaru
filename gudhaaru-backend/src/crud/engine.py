from sqlalchemy.ext.asyncio import create_async_engine, async_sessionmaker
from sqlalchemy.ext.declarative import declarative_base
from src.utils.settings import (
    DATABASE, DATABASE_USERNAME, DATABASE_PASSWORD, DATABASE_HOST, DATABASE_PORT
)

url = (f"mysql+aiomysql://{DATABASE_USERNAME}:{DATABASE_PASSWORD}@"
       f"{DATABASE_HOST}:{DATABASE_PORT}/{DATABASE}")
engine = create_async_engine(url,)
async_session = async_sessionmaker(
    bind=engine,
    expire_on_commit=False,
    autoflush=False
)
Base = declarative_base()


async def close_db():
    await engine.dispose()
