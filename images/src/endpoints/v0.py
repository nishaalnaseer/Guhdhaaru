from pathlib import Path
from typing import Annotated

from aiofiles import os
from fastapi import APIRouter, Security, HTTPException, File, UploadFile
from starlette.responses import FileResponse

from src.models import TokenData
from src.security import validate_token
from src.settings import CATEGORY_DIRECTORY, ITEM_TYPE_DIRECTORY, ITEM_DIRECTORY

router = APIRouter(prefix="/v0")


@router.post("/category/{category_id}", status_code=201)
async def upload_image(
        token: Annotated[
            TokenData, Security(validate_token, scopes=[])
        ],
        category_id: int,
        file: UploadFile = File(...)
):
    if not token.is_admin:
        raise HTTPException(401, "Not authorized")
    # try:
    #     return FileResponse(
    #         CATEGORY_DIRECTORY / f"{category_id}.jpg"
    #     )
    # except FileNotFoundError:
    #     raise FileResponse(
    #         CATEGORY_DIRECTORY / f"default.jpg"
    #     )


async def _get_image(path: Path, image_id: int):
    image = path / f"{image_id}.jpg"
    if await os.path.isfile(image):
        return FileResponse(image)
    else:
        return FileResponse(path / f"default.jpg")


@router.get("/category/{category}")
async def get_category(category: int):
    return await _get_image(CATEGORY_DIRECTORY, category)


@router.get("/item_type/{item_type}")
async def get_item_types(item_type: int):
    return await _get_image(ITEM_TYPE_DIRECTORY, item_type)


@router.get("/item/{item}")
async def get_item(item: int):
    return await _get_image(ITEM_DIRECTORY, item)
