from sqlalchemy import (
    Column, String, DateTime, func, ForeignKey, UniqueConstraint
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
        ForeignKey("category.id"),
    )

    __table_args__ = (
        UniqueConstraint(
            'parent', "name",
            name='_category-name'
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
        ForeignKey("type.id"),
    )
    category = Column(
        INTEGER(unsigned=True),
        ForeignKey("category.id"),
    )
    __table_args__ = (
        UniqueConstraint(
            'parent', "name", "category",
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


class AttributeTemplateRecord(Base):
    __tablename__ = "attribute_template"
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
    item = Column(
        INTEGER(unsigned=True),
        ForeignKey("type.id"),
        nullable=False
    )
    __table_args__ = (
        UniqueConstraint(
            'item', "name",
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
    attribute_template = Column(
        INTEGER(unsigned=True),
        ForeignKey("attribute_template.id"),
        nullable=False,
        unique=True
    )
    value = Column(
        String(50, collation=_COLLATION),
        nullable=False,
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