class Category {
  final int id;
  final String name;
  final int parentId;
  Category? parent;
  Map<int, Category> childrenTree = {};
  Map<int, ItemType> typesTree = {};

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
  final int itemID;

  ItemAttributeValue({
    required this.id,
    required this.attribute,
    required this.value,
    required this.itemID,
  });

  factory ItemAttributeValue.fromJson(Map<String, dynamic>json) {
    return ItemAttributeValue(
      id: json["id"],
      attribute: json["attribute"],
      value: json["value"],
      itemID: json["item_id"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "attribute": attribute,
      "value": value,
      "item_id": itemID
    };
  }
}

class ItemAttribute {
  final int id;
  final String name;
  final int typeID;

  ItemAttribute({
    required this.id,
    required this.name,
    required this.typeID,
    // required this.value,
  });

  factory ItemAttribute.fromJson(Map<String, dynamic> json) {
    return ItemAttribute(
        id: json["id"],
        name: json["name"],
        typeID: json["type_id"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "type_id": typeID,
    };
  }
}

class Item {
  final int id;
  final Map<int, ItemAttributeValue> attributes;

  Item({
    required this.id,
    required this.attributes
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json["id"],
      attributes: (json["attributes"] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
            int.parse(key), ItemAttributeValue.fromJson(value)
        )
      ),
    );
  }
}

class LeafNode{
  final Map<int, Item> items;
  ItemType itemType;
  final Map<int, ItemAttribute> attributes;

  LeafNode({
    required this.items,
    required this.itemType,
    required this.attributes,
  });

  factory LeafNode.fromJson(Map<String, dynamic> json) {
    return LeafNode(
      items: (json["items"] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          int.parse(key), Item.fromJson(value)
        )
      ),
      itemType: ItemType.fromJson(json["item_type"]),
      attributes: (json["attributes"] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          int.parse(key), ItemAttribute.fromJson(value)
        )
      )
    );
  }
}
