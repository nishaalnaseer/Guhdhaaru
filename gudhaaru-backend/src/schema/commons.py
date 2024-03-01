from pydantic import BaseModel


class Category(BaseModel):
    id: int
    name: str


class SubCategory(BaseModel):
    id: int
    name: str
    category: Category


class Node(BaseModel):
    id: int
    name: str
    sub_category: SubCategory
    parent_id: int


class Item(BaseModel):
    id: int
    name: str
    node: Node
