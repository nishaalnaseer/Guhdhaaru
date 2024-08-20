import os
from typing import List

import aiomysql
from src.crud.models import *
from src.crud.utils import initialise_db, add_objects, add_object
from src.security.security import get_password_hash
from src.utils.settings import (
    ADMIN1_PASSWORD, ADMIN1_EMAIL, DATABASE, DATABASE_HOST, DATABASE_PORT,
    DATABASE_USERNAME, DATABASE_PASSWORD, ADMIN1_NAME
)


def get_permissions(perms: int) -> List[PermissionRecord]:
    return [
        UserVendorPermission(permission_id=_id+1, user_id=1) for _id in range(perms)
    ]


async def init():
    drop_query = "DROP DATABASE IF EXISTS %s;" % DATABASE
    create_query = "CREATE DATABASE %s" % DATABASE

    async with aiomysql.create_pool(
            host=DATABASE_HOST,
            port=DATABASE_PORT,
            user=DATABASE_USERNAME,
            password=DATABASE_PASSWORD
    ) as pool:
        async with pool.acquire() as connection:
            async with connection.cursor() as cursor:
                await cursor.execute(drop_query)
                await cursor.execute(create_query)

        pool.close()
        await pool.wait_closed()

    await initialise_db()

    data = [
        PermissionRecord(id=1, name="add:user"),
        PermissionRecord(id=2, name="remove:user"),
        PermissionRecord(id=3, name="add:listing"),
        PermissionRecord(id=4, name="remove:listing"),
        PermissionRecord(id=5, name="update:details"),
    ]
    perms = len(data)
    data.append(
        UserRecord(
            name=ADMIN1_NAME,
            email=ADMIN1_EMAIL,
            password=get_password_hash(ADMIN1_PASSWORD),
            is_admin=1,
        ),
    )
    await add_objects(data)

    return perms


async def create_new_db():
    perms = await init()

    vendor_data = [
        VendorRecord(
            id=1,
            name="Great Hardware",
            super_user=1,
            email=ADMIN1_EMAIL,
            location="Maldives"
        ),
        VendorUserRecord(
            vendor_id=1,
            user_id=1
        )
    ]
    await add_objects(vendor_data)

    root_cat = CategoryRecord(
        id=1, name="FakeRoot", parent=1
    )
    root_type = TypeRecord(
        id=1, name="FakeRoot", parent=1, category=1, leaf_node=0
    )
    objects = get_permissions(perms)
    objects.append(root_cat)

    await add_objects(objects)
    await add_object(root_type)
