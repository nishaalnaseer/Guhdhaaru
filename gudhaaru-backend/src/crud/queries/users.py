from sqlalchemy import select

from src.crud.models import UserRecord, UserVendorPermission, PermissionRecord, VendorRecord
from src.schema.users import User


async def auth_user(username: str) -> User | None:
    query = select(
        UserRecord, UserVendorPermission, PermissionRecord, VendorRecord
    ).outerjoin(
        UserVendorPermission, UserVendorPermission.user_id == UserRecord.id
    ).outerjoin(
        PermissionRecord, PermissionRecord.id == UserVendorPermission.permission_id
    ).outerjoin(
        VendorRecord, VendorRecord.super_user == UserRecord.id
    ).where(UserRecord.username == username)

