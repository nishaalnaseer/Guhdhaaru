from typing import List

from src.crud.models import AttributeValueRecord, AttributeRecord
from src.schema.item import (
    Category, Item, ItemType, ItemAttribute, ItemAttributeValue
)


class ItemFactory:
    @staticmethod
    def create_category(record) -> Category:
        return Category(
            name=record.name,
            id=record.id,
            parent_id=record.parent
        )

    @staticmethod
    def create_half_item_type(record) -> ItemType:
        return ItemType(
            id=record.id,
            name=record.name,
            parent_id=record.parent,
            category_id=record.category,
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

    @staticmethod
    def create_item(records) -> Item:
        # AttributeValueRecord, AttributeRecord

        if len(records) == 0:
            raise Exception("No records")

        attributes: List[List[ItemAttribute | ItemAttributeValue,]] = []
        for record in records:
            value: AttributeValueRecord = record[0]
            attribute: AttributeRecord = record[1]

            attributes.append(
                [
                    ItemAttributeValue(
                        id=value.id,
                        attribute=value.attribute,
                        value=value.value,
                    ),
                    ItemFactory.create_attribute(attribute)
                ]
            )

        return Item(
            id=value.item_id,
            attributes=attributes
        )
