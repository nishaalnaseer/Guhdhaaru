import asyncio
from contextlib import asynccontextmanager
from aiofiles import os
from fastapi import FastAPI
from starlette.middleware.cors import CORSMiddleware

from src.endpoints.v0 import router as v0
from src.settings import CATEGORY_DIRECTORY, ITEM_TYPE_DIRECTORY, ITEM_DIRECTORY


async def create_assets_directory():
    cat_exists, type_exists, item_exists = await asyncio.gather(
        os.path.exists(CATEGORY_DIRECTORY),
        os.path.exists(ITEM_TYPE_DIRECTORY),
        os.path.exists(ITEM_DIRECTORY)
    )
    tasks = [

    ]
    if not cat_exists:
        print("GOin going to create assets directory")
        tasks.append(
            os.makedirs(CATEGORY_DIRECTORY)
        )
    if not type_exists:
        tasks.append(
            os.makedirs(ITEM_TYPE_DIRECTORY)
        )
    if not item_exists:
        tasks.append(
            os.makedirs(ITEM_DIRECTORY)
        )
    await asyncio.gather(*tasks)


@asynccontextmanager
async def lifespan(app: FastAPI):
    await create_assets_directory()
    pass
    yield


app = FastAPI(lifespan=lifespan)
app.include_router(v0)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # List your allowed origins here
    allow_credentials=True,
    allow_methods=["*"],  # You can restrict the HTTP methods if needed
    allow_headers=["*"],  # You can restrict the headers if needed
)
