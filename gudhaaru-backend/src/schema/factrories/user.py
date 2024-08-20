from src.crud.models import UserRecord
from src.schema.users import User


class UserFactory:
    @staticmethod
    def get_user(record: UserRecord) -> User:
        return User(
            id=record.id,
            name=record.name,
            email=record.email,
            password=record.password,
            is_admin=record.is_admin,
            enabled=record.enabled
        )
