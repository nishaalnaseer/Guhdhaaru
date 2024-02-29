from sqlalchemy import Column, String, DateTime, func, ForeignKey, UniqueConstraint
from sqlalchemy.dialects.mysql.types import BIT, INTEGER

from src.crud.engine import Base


_COLLATION = "utf8mb4_general_ci"


class AdminRecord(Base):
    __tablename__ = "admin"
    id = Column(
        INTEGER(11), primary_key=True, autoincrement=True,
        unique=True
    )
    email = Column(
        String(50, collation=_COLLATION),
        nullable=False, unique=True
    )
    password = Column(
        String(60, collation=_COLLATION),
        nullable=False
    )


class VendorRecord(Base):
    __tablename__ = "vendor"
    id = Column(
        INTEGER(11), primary_key=True, autoincrement=True,
        unique=True
    )
    email = Column(
        String(50, collation=_COLLATION),
        nullable=False, unique=True
    )
    password = Column(
        String(60, collation=_COLLATION),
        nullable=False
    )
    location = Column(
        String(200, collation=_COLLATION),
        nullable=False
    )


class CategoryRecord(Base):
    __tablename__ = "category"
    id = Column(
        INTEGER(11), primary_key=True, autoincrement=True,
        unique=True
    )
    name = Column(
        String(50, collation=_COLLATION),
        nullable=False, unique=True
    )


class SubCategoryRecord(Base):
    __tablename__ = "sub_category"
    id = Column(
        INTEGER(11), primary_key=True, autoincrement=True,
        unique=True
    )
    name = Column(
        String(50, collation=_COLLATION),
        nullable=False
    )
    category = Column(
        INTEGER(11), ForeignKey("category.id"), nullable=False
    )

    __table_args__ = (
        UniqueConstraint(
            'category', 'name', name='_category-name'
        ),
    )


class NodeRecord(Base):
    __tablename__ = "node"
    id = Column(
        INTEGER(11), primary_key=True, autoincrement=True,
        unique=True
    )
    name = Column(
        String(50, collation=_COLLATION),
        nullable=False
    )
    parent = Column(
        INTEGER(11), ForeignKey('node.id'), nullable=True
    )
    sub_category = Column(
        INTEGER(11), ForeignKey("sub_category.id"), nullable=True
    )


class ItemRecord(Base):
    __tablename__ = "item"
    id = Column(
        INTEGER(11), primary_key=True, autoincrement=True,
        unique=True
    )
    name = Column(
        String(50, collation=_COLLATION),
        nullable=False
    )
    node = Column(
        INTEGER(11), ForeignKey("node.id"), nullable=False
    )
    __table_args__ = (
        UniqueConstraint(
            'node', 'name', name='_node-name'
        ),
    )


class ListingRecord(Base):
    __tablename__ = "listing"
    id = Column(
        INTEGER(11), primary_key=True, autoincrement=True,
        unique=True
    )
    item = Column(
        INTEGER(11), ForeignKey("item.id")
    )
    vendor = Column(
        INTEGER(11), ForeignKey("vendor.id")
    )
