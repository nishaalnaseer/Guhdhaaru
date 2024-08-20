from src.utils.settings import *
from src.main import app


if __name__ == '__main__':
    import uvicorn

    uvicorn.run(
        host=HOST,
        app="main:app",
        port=PORT,
        # reload=True
    )
