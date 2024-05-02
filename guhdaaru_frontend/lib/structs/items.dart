class Category {
  final int id;
  final String name;
  final int parentId;
  Category? parent;
  final Map<int, Category> childrenTree = {};
  final Map<int, ItemType> typesTree = {};

  Category({
    required this.id,
    required this.name,
    required this.parentId,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json["id"],
      name: json["name"],
      parentId: json["parent_id"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "parent_id": parentId,
    };
  }

}

class ItemType {
  final int id;
  final String name;
  final int parentId;
  final int categoryId;
  Category? category;
  late final Map<int, ItemType> childrenTree;
  bool isLeafNode;

  ItemType({
    required this.id,
    required this.name,
    required this.parentId,
    required this.categoryId,
    required this.isLeafNode,
  });

  factory ItemType.fromJson(Map<String, dynamic> json) {
    return ItemType(
      id: json["id"],
      name: json["name"],
      parentId: json["parent_id"],
      categoryId: json["category_id"],
      isLeafNode: json["leaf_node"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "parent_id": parentId,
      "category_id": categoryId,
      "leaf_node": isLeafNode
    };
  }
}


class ItemAttributeValue {
  final int id;
  final int attribute;
  final String value;

  ItemAttributeValue({
    required this.id,
    required this.attribute,
    required this.value,
  });

  factory ItemAttributeValue.fromJson(Map<String, dynamic>json) {
    return ItemAttributeValue(
      id: json["id"],
      attribute: json["attribute"],
      value: json["value"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "attribute": attribute,
      "value": value,
    };
  }
}


class ItemAttribute {
  final int id;
  final String name;
  final int typeID;
  final ItemAttributeValue? value;

  ItemAttribute({
    required this.id,
    required this.name,
    required this.typeID,
    required this.value,
  });

  factory ItemAttribute.fromJson(Map<String, dynamic> json) {
    return ItemAttribute(
        id: json["id"],
        name: json["name"],
        typeID: json["type_id"],
        value: ItemAttributeValue.fromJson(json["value"])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "type_id": typeID,
      "value": value?.toJson(),
    };
  }
}

class Item {
  final int id;
  final Map<String, ItemAttribute> attributes;

  Item({
    required this.id,
    required this.attributes
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        id: json["id"],
        attributes: (json["attributes"] as Map<String, dynamic>).map(
                (key, value) => MapEntry(key, ItemAttribute.fromJson(value))
        )
    );
  }
}

class LeafNode{
  final Map<int, Item> items;
  final ItemType itemType;

  LeafNode({
    required this.items,
    required this.itemType
  });

  factory LeafNode.fromJson(Map<String, dynamic> json) {
    return LeafNode(
        items: (json["items"] as Map<String, dynamic>).map(
                (key, value) => MapEntry(
                    int.parse(key), Item.fromJson(value)
                )
        ),
        itemType: ItemType.fromJson(json["item_type"])
    );
  }
}
