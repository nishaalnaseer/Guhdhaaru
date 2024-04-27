import asyncio
from src.crud.utils import close_db
from src.crud.drop import create_new_db


async def _main():
    await create_new_db()
    await close_db()


def main():
    asyncio.run(_main())
