from typing import List

from src.schema.item import Category, Item, ItemType, ItemAttribute


class ItemFactory:
    @staticmethod
    def create_category(record) -> Category:
        return Category(
            name=record.name,
            id=record.id,
            parent=record.parent
        )

    @staticmethod
    def create_half_item_type(record) -> ItemType:
        return ItemType(
            id=record.id,
            name=record.name,
            parent=record.parent,
            category=record.category,
        )

    @staticmethod
    def create_attribute(record) -> ItemAttribute:
        return ItemAttribute(
            id=record.id,
            name=record.name,
            type_id=record.item_type,
        )

    @staticmethod
    def create_attributes(records) -> List[ItemAttribute]:
        return [
            ItemFactory.create_attribute(record) for record in records
        ]
