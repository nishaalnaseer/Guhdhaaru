from src.schema.item import Category, Item, ItemType


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
