from sqlalchemy import select
from sqlalchemy.orm import aliased

from src.crud.models import UserRecord, UserVendorPermission, PermissionRecord, VendorRecord, VendorUserRecord
from src.crud.utils import all_selection, scalar_selection
from src.schema.factrories.user import UserFactory
from src.schema.users import User


async def auth_user(username: str) -> User | bool:
    query = select(
        UserRecord, PermissionRecord, VendorUserRecord,
        VendorRecord
    ).outerjoin(
        UserVendorPermission, UserVendorPermission.user_id == UserRecord.id
    ).outerjoin(
        PermissionRecord, PermissionRecord.id == UserVendorPermission.permission_id
    ).outerjoin(
        VendorUserRecord, VendorUserRecord.id == UserVendorPermission.user_id
    ).outerjoin(
        VendorRecord, VendorRecord.super_admin == UserRecord.id
    ).where(UserRecord.email == username)

    rows = await all_selection(query)

    if not rows:
        return False
    user = UserFactory.get_user(rows[0][0])

    for row in rows:
        super_admin_record: VendorRecord = row[3]
        if super_admin_record:
            user.super_admin_vendors.append(super_admin_record.id)

        permission_record: PermissionRecord = row[1]
        vendor_user_record: VendorUserRecord = row[2]

        if permission_record and vendor_user_record:
            user.vendor_rights[vendor_user_record.vendor_id].append(
                permission_record.name
            )

    return user


async def select_user_by_id(user_id: int) -> UserRecord:
    query = select(UserRecord).where(UserRecord.id == user_id)
    return await scalar_selection(query)
