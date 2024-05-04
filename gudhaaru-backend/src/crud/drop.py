import aiomysql
from src.crud.engine import db, host, port, user, password
from src.crud.models import *
from src.crud.utils import initialise_db, add_objects, add_object


async def create_new_db():
    drop_query = "DROP DATABASE IF EXISTS %s;" % db
    create_query = "CREATE DATABASE %s" % db

    async with aiomysql.create_pool(
        host=host,
        port=port,
        user=user,
        password=password
    ) as pool:
        async with pool.acquire() as connection:
            async with connection.cursor() as cursor:
                await cursor.execute(drop_query)
                await cursor.execute(create_query)

        pool.close()
        await pool.wait_closed()

    await initialise_db()

    root_cat = CategoryRecord(
        id=1, name="FakeRoot", parent=1
    )
    root_type = TypeRecord(
        id=1, name="FakeRoot", parent=1, category=1, leaf_node=0
    )
    await add_object(root_cat)
    await add_object(root_type)
