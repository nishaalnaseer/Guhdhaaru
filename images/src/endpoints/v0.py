from pathlib import Path

from aiofiles import os
from fastapi import APIRouter
from starlette.responses import FileResponse
from src.endpoints.upload import router as uploads

from src.settings import CATEGORY_DIRECTORY, ITEM_TYPE_DIRECTORY, ITEM_DIRECTORY

router = APIRouter(prefix="/v0")
router.include_router(uploads)


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
