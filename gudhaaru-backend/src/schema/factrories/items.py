from typing import List, Dict

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
    def create_attribute_value(record) -> ItemAttributeValue:
        return ItemAttributeValue(
            id=record.id,
            item_id=record.item_id,
            attribute=record.attribute,
            value=record.value,
        )

    @staticmethod
    def create_item_attribute(records) -> ItemAttribute:
        attribute_record: AttributeRecord = records[0]
        attribute_value_record: AttributeValueRecord = records[1]

        return ItemAttribute(
            id=attribute_record.id,
            name=attribute_record.name,
            type_id=attribute_record.item_type,
            attribute=ItemFactory.create_attribute_value(
                attribute_value_record
            )
        )

    @staticmethod
    def create_half_item_type(record) -> ItemType:
        return ItemType(
            id=record.id,
            name=record.name,
            parent_id=record.parent,
            category_id=record.category,
            leaf_node=record.leaf_node
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

        attributes: Dict[str, ItemAttribute] = {}
        for record in records:
            value: AttributeValueRecord = record[0]
            attribute: AttributeRecord = record[1]

            attr = ItemFactory.create_item_attribute([attribute, value])
            attributes[attribute.name] = attr

        return Item(
            id=value.item_id,
            attributes=attributes
        )
