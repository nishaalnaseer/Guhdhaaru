import os
import pathlib

from dotenv import load_dotenv
load_dotenv()


OAUTH2_SECRET = os.getenv("OAUTH2_SECRET")
HOST = os.getenv("HOST")
PORT = int(os.getenv("PORT"))
ASSETS_DIRECTORY = pathlib.Path((os.getenv("ASSETS_DIRECTORY")))

CATEGORY_DIRECTORY = ASSETS_DIRECTORY / "items" / "categories"
ITEM_TYPE_DIRECTORY = ASSETS_DIRECTORY / "items" / "item_types"
ITEM_DIRECTORY = ASSETS_DIRECTORY / "items" / "items"
