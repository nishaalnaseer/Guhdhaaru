from sqlalchemy import select, and_, or_, asc
from sqlalchemy.orm import aliased

from src.crud.engine import async_session
from src.crud.models import CategoryRecord, TypeRecord, AttributeRecord, AttributeValueRecord
from src.crud.utils import scalar_selection, scalars_selection, all_selection


async def select_category_by_name(name: str, parent: int):
    query = select(
        CategoryRecord
    ).where(
        and_(
            CategoryRecord.name == name,
            CategoryRecord.parent == parent
        )
    )
    return await scalar_selection(query)


async def select_category_by_id(cat_id: int):
    query = select(
        CategoryRecord
    ).where(
        CategoryRecord.id == cat_id
    )
    return await scalar_selection(query)


async def select_last_inserted_type(name: str, parent: int, category: int):
    query = select(
        TypeRecord
    ).where(
        and_(
            TypeRecord.name == name,
            TypeRecord.parent == parent,
            TypeRecord.category == category
        )
    )
    return await scalar_selection(query)


async def select_type_by_id(type_id: int):
    query = select(
        TypeRecord
    ).where(
        TypeRecord.id == type_id
    )
    return await scalar_selection(query)


async def select_attributes(item_type_id: int):
    query = select(
        AttributeRecord
    ).where(
        AttributeRecord.item_type == item_type_id
    )

    return await scalars_selection(query)


async def select_attribute2(attribute_id):
    _aliased = aliased(AttributeRecord)
    query = select(
        AttributeRecord
    ).join(
        _aliased, _aliased.id == attribute_id
    ).where(
        AttributeRecord.item_type == _aliased.item_type
    )
    return await scalars_selection(query)


async def select_item_only_by_id(item_id: int):
    query = select(
        AttributeValueRecord
    ).where(
        AttributeValueRecord.item_id == item_id
    )

    return await all_selection(query)


async def select_item_by_id(item_id: int):
    query = select(
        AttributeValueRecord, AttributeRecord
    ).join(
        AttributeRecord, AttributeRecord.id == AttributeValueRecord.attribute
    ).where(
        AttributeValueRecord.item_id == item_id
    )

    return await all_selection(query)


async def select_root_types():
    query = select(
        TypeRecord
    ).where(
        TypeRecord.parent == 1
    ).order_by(asc(TypeRecord.id))
    return await scalars_selection(query)


async def select_all_categories():
    query = select(
        CategoryRecord
    ).order_by(asc(CategoryRecord.id))
    return await scalars_selection(query)


async def select_type_data(type_id: int):
    query = select(
        TypeRecord
    ).where(
        or_(
            TypeRecord.id == type_id,
            TypeRecord.parent == type_id
        )
    )

    return await scalars_selection(query)


async def select_leaf_node(item_type_id: int):
    query = select(
        AttributeValueRecord, AttributeRecord, TypeRecord
    ).outerjoin(
        AttributeRecord, AttributeRecord.item_type == TypeRecord.id
    ).outerjoin(
        AttributeValueRecord,
        AttributeValueRecord.attribute == AttributeRecord.id
    ).where(
        TypeRecord.id == item_type_id
    )
    return await all_selection(query)


async def select_attribute(attr: int):
    query = select(
        AttributeRecord
    ).where(
        AttributeRecord.id == attr
    )

    return await scalar_selection(query)


async def select_attribute_value(value: int):
    query = select(
        AttributeValueRecord
    ).where(
        AttributeValueRecord.id == value
    )

    return await scalar_selection(query)


async def select_last_inserted_attr(name: str, type_id: int):
    query = select(
        AttributeRecord
    ).where(
        and_(
            AttributeRecord.name == name,
            AttributeRecord.item_type == type_id
        )
    )
    return await scalar_selection(query)


async def select_last_inserted_value(attribute: int, item_id: int):
    query = select(
        AttributeValueRecord
    ).where(
        and_(
            AttributeValueRecord.item_id == item_id,
            AttributeValueRecord.attribute == attribute
        )
    )
    return await scalar_selection(query)


async def select_attribute_values(item_id: int):
    query = select(
        AttributeValueRecord
    ).where(
        AttributeValueRecord.item_id == item_id
    )
    return await scalars_selection(query)
