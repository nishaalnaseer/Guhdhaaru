from fastapi import FastAPI
from src.crud.tables import *
from src.utils.utils import lifespan
from src.schema.users import *

app = FastAPI(lifespan=lifespan)


