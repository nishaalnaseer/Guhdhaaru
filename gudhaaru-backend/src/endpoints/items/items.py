from fastapi import APIRouter
from src.endpoints.items.category import router as categories


router = APIRouter(prefix="/items", tags=["items"])
router.include_router(categories)
