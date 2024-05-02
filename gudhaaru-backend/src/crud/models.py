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
        # ForeignKey("category.id"),
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
        # ForeignKey("type.id"),
        nullable=False
    )
    category = Column(
        INTEGER(unsigned=True),
        ForeignKey("category.id"), nullable=False
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


class ItemRecord(Base):
    __tablename__ = "item"
    id = Column(
        INTEGER(unsigned=True),
        primary_key=True,
        autoincrement=True,
        nullable=False,
        unique=True,
    )
    item_type = Column(
        INTEGER(unsigned=True),
        ForeignKey("type.id"),
        nullable=False
    )
    name = Column(
        String(50, collation=_COLLATION),
        nullable=False,
    )
    __table_args__ = (
        UniqueConstraint(
            'item_type', "name",
            name='_type-name'
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
        ForeignKey("type.id"),
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
        ForeignKey("attribute.id"),
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


# class EscrowRecord(Base):
#     __tablename__ = "escrow"
#     id = Column(
#         INTEGER(unsigned=True),
#         primary_key=True,
#         autoincrement=True,
#         nullable=False,
#         unique=True,
#     )
#     # vendor = Column(
#     #     INTEGER(unsigned=True),
#     #     ForeignKey("vendor.id"),
#     #     nullable=False
#     # )
#     vendor =
#     item = Column(
#         INTEGER(unsigned=True),
#         ForeignKey("item.id"),
#         nullable=False
#     )
