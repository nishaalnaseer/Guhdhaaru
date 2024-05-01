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

  ItemType({
    required this.id,
    required this.name,
    required this.parentId,
    required this.categoryId,
  });

  factory ItemType.fromJson(Map<String, dynamic> json) {
    return ItemType(
        id: json["id"],
        name: json["name"],
        parentId: json["parent_id"],
        categoryId: json["category_id"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "parent_id": parentId,
      "category_id": categoryId,
    };
  }
}
