from fastapi import APIRouter
from src.endpoints.items.category import router as categories
from src.endpoints.items.item_types import router as item_types


router = APIRouter(prefix="/items", tags=["items"])
router.include_router(categories)
router.include_router(item_types)
