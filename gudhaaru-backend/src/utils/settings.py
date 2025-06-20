import os
from dotenv import load_dotenv
from src.utils.my_logger import get_logger

load_dotenv()

DATABASE = os.getenv("DATABASE")
DATABASE_HOST = os.getenv("DATABASE_HOST")
DATABASE_PORT = int(os.getenv("DATABASE_PORT"))
DATABASE_USERNAME = os.getenv("DATABASE_USERNAME")
DATABASE_PASSWORD = os.getenv("DATABASE_PASSWORD")
OTP_SECRET = os.getenv("OTP_SECRET")
OAUTH2_SECRET = os.getenv("OAUTH2_SECRET")
ENCRYPTION_SECRET = os.getenv("ENCRYPTION_SECRET")
HOST = os.getenv("HOST")
PORT = int(os.getenv("PORT"))
ASSETS_DIRECTORY = os.getenv("ASSETS_DIRECTORY")
ACCESS_TOKEN_EXPIRE_MINUTES = int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES"))
PASSWORD_RESET_TOKEN_EXPIRE_MINUTES = os.getenv("PASSWORD_RESET_TOKEN_EXPIRE_MINUTES")
MAILING_SERVER = os.getenv("MAILING_SERVER")
SMTP_PORT = int(os.getenv("SMTP_PORT"))
MAILING_USERNAME = os.getenv("MAILING_USERNAME")
MAILING_PASSWORD = os.getenv("MAILING_PASSWORD")
ADMIN1_EMAIL = os.getenv("ADMIN1_EMAIL")
ADMIN1_NAME = os.getenv("ADMIN1_NAME")
ADMIN1_PASSWORD = os.getenv("ADMIN1_PASSWORD")
DEV = int(os.getenv("DEV"))

_log_string = f"""ENV VARIABLES:
    DATABASE = {DATABASE}
    DATABASE_HOST = {DATABASE_HOST}
    DATABASE_PORT = {DATABASE_PORT}
    DATABASE_USERNAME = {DATABASE_USERNAME}
    DATABASE_PASSWORD = {DATABASE_PASSWORD}
    OTP_SECRET = {OTP_SECRET}
    OAUTH2_SECRET = {OAUTH2_SECRET}
    ENCRYPTION_SECRET = {ENCRYPTION_SECRET}
    HOST = {HOST}
    PORT = {PORT}
    ASSETS_DIRECTORY = {ASSETS_DIRECTORY}
    ACCESS_TOKEN_EXPIRE_MINUTES = {ACCESS_TOKEN_EXPIRE_MINUTES}
    PASSWORD_RESET_TOKEN_EXPIRE_MINUTES = {PASSWORD_RESET_TOKEN_EXPIRE_MINUTES}
    MAILING_SERVER = {MAILING_SERVER}
    SMTP_PORT = {SMTP_PORT}
    MAILING_USERNAME = {MAILING_USERNAME}
    MAILING_PASSWORD = {MAILING_PASSWORD}
    ADMIN1_EMAIL = {ADMIN1_EMAIL}
    ADMIN1_NAME = {ADMIN1_NAME}
    ADMIN1_PASSWORD = {ADMIN1_PASSWORD}
    DEV = {DEV}
    """
logger = get_logger("Settings")
logger.info(_log_string)
