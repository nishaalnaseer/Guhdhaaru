from sqlalchemy import (
    Column, String, ForeignKey, UniqueConstraint, PrimaryKeyConstraint, Enum
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
        nullable=False
    )
    email = Column(
        String(50, collation=_COLLATION),
        nullable=False, unique=True
    )
    password = Column(
        String(60, collation=_COLLATION),
        nullable=False,
    )
    is_admin = Column(
        BIT(),
        nullable=False,
    )
    enabled = Column(BIT(), nullable=False, default=1)


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
    super_user = Column(
        INTEGER(unsigned=True),
        ForeignKey("user.id"),
        nullable=False,
    )
    status = Column(
        Enum(
            "ENABLED",
            "DISABLED",
            "REQUESTED",
            "DENIED",
            name="status",
            collation=_COLLATION
        ),
        nullable=False, default="REQUESTED"
    )


class VendorUserRecord(Base):
    __tablename__ = "vendor_user"
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


class ListingsRecord(Base):
    __tablename__ = "listing"
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


class PermissionRecord(Base):
    __tablename__ = "permission"
    id = Column(
        INTEGER(unsigned=True),
        primary_key=True,
        autoincrement=True,
        nullable=False,
        unique=True,
    )
    name = Column(
        String(20),
        nullable=False,
        unique=True
    )


class UserVendorPermission(Base):
    __tablename__ = "user_vendor_permission"
    user_id = Column(
        INTEGER(unsigned=True),
        ForeignKey("vendor_user.id")
    )
    permission_id = Column(
        INTEGER(unsigned=True),
        ForeignKey("permission.id")
    )
    __table_args__ = (
        PrimaryKeyConstraint("user_id", "permission_id"),
    )
