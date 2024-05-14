from sqlalchemy import (
    Column, String, DateTime, func, ForeignKey, UniqueConstraint,
    CheckConstraint
)
from sqlalchemy.dialects.mysql.types import BIT, INTEGER

from src.crud.engine import Base


_COLLATION = "utf8mb4_general_ci"


class CategoryRecord(Base):
    __tablename__ = "category"
    id = Column(
        INTEGER(unsigned=True),
        primary_key=True,
        autoincrement=True,
        nullable=False,
        unique=True,
    )
    name = Column(
        String(50, collation=_COLLATION),
        nullable=False,
    )
    parent = Column(
        INTEGER(unsigned=True),
        ForeignKey("category.id", ondelete="CASCADE", onupdate="CASCADE"),
        nullable=False
    )

    __table_args__ = (
        UniqueConstraint(
            "name", "parent",
            name="_name-name-unique"
        ),
    )


class TypeRecord(Base):
    __tablename__ = "type"
    id = Column(
        INTEGER(unsigned=True),
        primary_key=True,
        autoincrement=True,
        nullable=False,
        unique=True,
    )
    name = Column(
        String(50, collation=_COLLATION),
        nullable=False,
    )
    parent = Column(
        INTEGER(unsigned=True),
        ForeignKey("type.id", ondelete="CASCADE", onupdate="CASCADE"),
        nullable=False
    )
    category = Column(
        INTEGER(unsigned=True),
        ForeignKey("category.id", ondelete="CASCADE", onupdate="CASCADE"),
        nullable=False
    )
    leaf_node = Column(
        BIT(1),
        nullable=False
    )
    __table_args__ = (
        UniqueConstraint(
            'parent', "name",
            name='_category-name-parent'
        ),
    )


# class ItemRecord(Base):
#     __tablename__ = "item"
#     id = Column(
#         INTEGER(unsigned=True),
#         primary_key=True,
#         autoincrement=True,
#         nullable=False,
#         unique=True,
#     )
#     item_type = Column(
#         INTEGER(unsigned=True),
#         ForeignKey("type.id", ondelete="CASCADE", onupdate="CASCADE"),
#         nullable=False
#     )
#     name = Column(
#         String(50, collation=_COLLATION),
#         nullable=False,
#     )
#     __table_args__ = (
#         UniqueConstraint(
#             'item_type', "name",
#             name='_type-name'
#         ),
#     )


class AttributeRecord(Base):
    __tablename__ = "attribute"
    id = Column(
        INTEGER(unsigned=True),
        primary_key=True,
        autoincrement=True,
        nullable=False,
        unique=True,
    )
    name = Column(
        String(50, collation=_COLLATION),
        nullable=False,
    )
    item_type = Column(
        INTEGER(unsigned=True),
        ForeignKey("type.id", ondelete="CASCADE", onupdate="CASCADE"),
        nullable=False
    )
    __table_args__ = (
        UniqueConstraint(
            'item_type', "name",
            name='_type-name'
        ),
    )


class AttributeValueRecord(Base):
    __tablename__ = "attribute_value"
    id = Column(
        INTEGER(unsigned=True),
        primary_key=True,
        autoincrement=True,
        nullable=False,
        unique=True,
    )
    attribute = Column(
        INTEGER(unsigned=True),
        ForeignKey("attribute.id", ondelete="CASCADE", onupdate="CASCADE"),
        nullable=False
    )
    value = Column(
        String(50, collation=_COLLATION),
        nullable=False,
    )
    item_id = Column(
        INTEGER(unsigned=True),
        nullable=False
    )
    __table_args__ = (
        UniqueConstraint(
            'item_id', "attribute",
            name='_item_id-attribute'
        ),
    )


class UserRecord(Base):
    __tablename__ = "user"
    id = Column(
        INTEGER(unsigned=True),
        primary_key=True,
        autoincrement=True,
        nullable=False,
        unique=True,
    )
    name = Column(
        String(50, collation=_COLLATION),
        nullable=False, unique=True
    )
    email = Column(
        String(50, collation=_COLLATION),
        nullable=False,
    )
    password = Column(
        String(60, collation=_COLLATION),
        nullable=False,
    )
    is_admin = Column(
        BIT(),
        nullable=False,
    )


class VendorRecord(Base):
    __tablename__ = "vendor"
    id = Column(
        INTEGER(unsigned=True),
        primary_key=True,
        autoincrement=True,
        nullable=False,
        unique=True,
    )
    name = Column(
        String(50, collation=_COLLATION),
        nullable=False, unique=True
    )
    email = Column(
        String(50, collation=_COLLATION),
        nullable=False
    )
    location = Column(
        String(50, collation=_COLLATION),
        nullable=False,
    )


class VendorUserRecord(Base):
    __tablename__ = "vendor_users"
    id = Column(
        INTEGER(unsigned=True),
        primary_key=True,
        autoincrement=True,
        nullable=False,
        unique=True,
    )
    vendor_id = Column(
        INTEGER(unsigned=True),
        ForeignKey("vendor.id"),
        nullable=False,
    )
    user_id = Column(
        INTEGER(unsigned=True),
        ForeignKey("user.id"),
        nullable=False,
    )
    __table_args__ = (
        UniqueConstraint(
            'vendor_id', 'user_id', name='_user-vendor'
        ),
    )


class EscrowRecord(Base):
    __tablename__ = "escrow"
    id = Column(
        INTEGER(unsigned=True),
        primary_key=True,
        autoincrement=True,
        nullable=False,
        unique=True,
    )
    vendor_id = Column(
        INTEGER(unsigned=True),
        ForeignKey("vendor.id"),
        nullable=False
    )
    item = Column(
        INTEGER(unsigned=True),
        # ForeignKey("item.id"),
        nullable=False
    )
    __table_args__ = (
        UniqueConstraint(
            'vendor_id', 'item', name='_vendor-vendor'
        ),
    )
