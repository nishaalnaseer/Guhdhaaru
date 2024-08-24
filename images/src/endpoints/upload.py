from typing import Annotated

import aiofiles
from fastapi import UploadFile, File

from fastapi import APIRouter
from fastapi.params import Security

from src.models import TokenData
from src.security import validate_token
from src.settings import ITEM_TYPE_DIRECTORY, CATEGORY_DIRECTORY, ITEM_DIRECTORY


router = APIRouter()


async def save_image(path: str, file: UploadFile):
    async with aiofiles.open(
            path, 'wb'
    ) as f:
        content = await file.read()
        await f.write(content)


@router.post("/item-type/{item_type}", status_code=201)
async def upload_image(
        token: Annotated[
            TokenData, Security(validate_token, scopes=[])
        ],
        item_type: int,
        file: UploadFile = File(...)
):
    await save_image(
        ITEM_TYPE_DIRECTORY / f"{item_type}.jpg",
        file
    )


@router.post("/category/{category}", status_code=201)
async def upload_image(
        token: Annotated[
            TokenData, Security(validate_token, scopes=[])
        ],
        category: int,
        file: UploadFile = File(...)
):
    await save_image(
        CATEGORY_DIRECTORY / f"{category}.jpg",
        file
    )


@router.post("/item/{item}", status_code=201)
async def upload_image(
        token: Annotated[
            TokenData, Security(validate_token, scopes=[])
        ],
        item: int,
        file: UploadFile = File(...)
):
    await save_image(
        ITEM_DIRECTORY / f"{item}.jpg",
        file
    )
