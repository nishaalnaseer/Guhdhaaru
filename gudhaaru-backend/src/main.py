from fastapi import FastAPI
from src.crud.models import *
from src.utils.utils import lifespan
from src.schema.users import *
from src.endpoints.items.items import router as items

app = FastAPI(lifespan=lifespan)
app.include_router(items)

