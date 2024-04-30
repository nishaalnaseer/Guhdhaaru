import 'package:flutter/foundation.dart';

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
  final Map<int, ItemType> childrenTree = {};

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

// class Category {
//   int id;
//   String name;
//   int? parent;
//   Category? parent_;
//   Map<int, dynamic> childrenTree = {};
//   Map<int, dynamic> typeTree = {};
//
//   Category({
//     required this.id,
//     required this.name,
//     this.parent,
//     this.parent_,
//   });
//
//   factory Category.fromJson(Map<String, dynamic> json) {
//     return Category(
//       id: json['id'] as int,
//       name: json['name'] as String,
//       parent: json['parent'] as int?,
//       // childrenTree: Map<int, dynamic>.from(json['childrenTree'] as Map),
//       // typeTree: Map<int, dynamic>.from(json['typeTree'] as Map),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'parent': parent,
//       'childrenTree': childrenTree,
//       'typeTree': typeTree,
//     };
//   }
//
//   void addChild(dynamic child) {
//     childrenTree[child.id] = child;
//   }
//
//   void addType(dynamic child) {
//     typeTree[child.id] = child;
//   }
// }
//
// class ItemType {
//   int id;
//   String name;
//   int parent;
//   Category? category;
//   Category? parent_;
//   Map<int, ItemType> children = {};
//
//   ItemType({
//     required this.id,
//     required this.name,
//     required this.parent,
//     this.category,
//     this.parent_
//   });
//
//   factory ItemType.fromJson(Map<String, dynamic> json) {
//     return ItemType(
//       id: json['id'] as int,
//       name: json['name'] as String,
//       parent: json['parent'] as int,
//       // children: json['children'] != null
//       //     ? Map<int, dynamic>.from(json['children'] as Map)
//       //     : null,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'parent': parent,
//       'children': children,
//     };
//   }
// }
