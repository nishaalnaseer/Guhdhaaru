from typing import Annotated

from fastapi import APIRouter, Security, HTTPException
from sqlalchemy import update, select

from src.crud.models import UserRecord
from src.crud.queries.users import select_user_by_id
from src.crud.utils import add_object, execute_safely, scalars_selection
from src.schema.factrories.user import UserFactory
from src.schema.users import User
from src.security.security import get_password_hash, get_current_active_user
from src.utils.utils import check_admin

router = APIRouter(prefix="/users", tags=["Users"])
# todo password changing
# todo when users email / phone number need to be verified upon creation
#


@router.post("/user/register", status_code=201)
async def register(
        user: User
) -> User:

    if not user.password:
        raise HTTPException(422, "Password is null")

    user_record = UserRecord(
        name=user.name,
        email=user.email,
        password=get_password_hash(user.password),
        is_admin=0,
    )
    await add_object(user_record)

    return UserFactory.get_user(user_record)


@router.patch("/user", status_code=201)
async def update_me(
        current_user: Annotated[
            User, Security(get_current_active_user, scopes=[])
        ],
        user: User
) -> User:
    query = update(
        UserRecord
    ).values(
        name=user.name,
        email=user.email,
    ).where(UserRecord.id == current_user.id)
    await execute_safely(query)

    user_record = await select_user_by_id(current_user.id)

    if user_record is None:
        raise HTTPException(status_code=404, detail="User not found")

    return UserFactory.get_user(user_record)


@router.get("/users")
async def get_users(
        current_user: Annotated[
            User, Security(get_current_active_user, scopes=[])
        ],
):
    check_admin(current_user)
    records = await scalars_selection(
        select(UserRecord)
    )

    return [
        UserFactory.get_user(record) for record in records
    ]


@router.get("/admins")
async def get_admins(
        current_user: Annotated[
            User, Security(get_current_active_user, scopes=[])
        ],
):
    check_admin(current_user)
    records = await scalars_selection(
        select(UserRecord).where(UserRecord.is_admin == 1)
    )
    return [
        UserFactory.get_user(record) for record in records
    ]
