import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guhdaaru_frontend/structs/structs.dart';
import 'package:guhdaaru_frontend/views/utils/my_scaffold.dart';
import 'package:http/http.dart';
import '../structs/items.dart';

class HomePage extends StatefulWidget {
  // final Map<int, Category> orderedCategories;
  // final Map<int, Category> categories;
  const HomePage({
    super.key, // required this.orderedCategories, required this.categories
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextStyle bigStyle = const TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.bold,
    fontFamily: "Roboto",
  );
  TextStyle smallStyle = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    fontFamily: "Roboto",
  );
  Map<int, Category> orderedCategories = {};
  Map<int, Category> categories = {};
  bool disposing = false;

  void getHomePageData() async {
    var response = await get(Uri.parse("${Settings.server}/v0/home"));

    var content = jsonDecode(response.body);
    var categoriesContent = content["categories"] as List<dynamic>;
    var typesContent = content["types"] as List<dynamic>;

    Map<int, Category> orderedCategories = {};
    Map<int, Category> categories = {};

    for(var category_ in categoriesContent) {
      var category = Category.fromJson(category_);

      if(category.id == 1) {
        continue;
      }

      if(category.parentId == 1) {
        orderedCategories[category.id] = category;
      }
      categories[category.id] = category;
    }

    categories.forEach((key, value) {
      int parentId = value.parentId;
      if(parentId != 1) {
        if(orderedCategories.containsKey(parentId)) {
          var parent = orderedCategories[parentId];
          parent!.childrenTree[key] = value;
        } else {
          value.childrenTree[key] = value;
        }
      }
    });

    for(var type_ in typesContent) {
      var type = ItemType.fromJson(type_);

      if(type.id == 1) {
        continue;
      }

      var category = categories[type.categoryId];
      category!.typesTree[type.id] = type;
    }

    categories.forEach((key, value) {
      // Sort childrenTree in ascending order
      value.childrenTree = LinkedHashMap.fromEntries(
        value.childrenTree.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
      );

      // Sort typesTree in ascending order
      value.typesTree = LinkedHashMap.fromEntries(
        value.typesTree.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
      );
    });

    this.orderedCategories = orderedCategories;
    this.categories = categories;

    if(!disposing) {
      setState(() {

      });
    }
  }

  void afterAddCategoryRequest(Response response, int parent) {
    if(response.statusCode == 201) {

      Category newCategory = Category.fromJson(
        jsonDecode(response.body)
      );

      if(parent == 0) {
        categories[newCategory.id] = newCategory;
        orderedCategories[newCategory.id] = newCategory;
      } else {
        Category? parentCategory = categories[parent];
        parentCategory!.childrenTree[newCategory.id] = newCategory;
      }
      Navigator.of(context).pop();

      setState(() {

      });

    } else {
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent dismissing dialog by tapping outside
        builder: (BuildContext context) {
          TextEditingController controller = TextEditingController();

          return AlertDialog(
            title: Text('Error ${response.statusCode}'),

            content: Text(response.body),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  void beforeAddCategoryRequest(String content, int parent) {
    post(
      Uri.parse("${Settings.server}/v0/items/categories/category"),
      body: content,
      headers: Settings.headers
    ).then((value) => afterAddCategoryRequest(value, parent));
  }

  void addCategory({required int parentCategoryId}) {
    showDialog(
        context: context,
        builder: (context) {

          bool isLeafNode = false;
          TextEditingController controller = TextEditingController();
          FocusNode focusNode = FocusNode(); // Create a FocusNode
          WidgetsBinding.instance.addPostFrameCallback(
                  (_) => focusNode.requestFocus()
          );

          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: const Text('Create Type'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    TextField(
                      controller: controller,
                      focusNode: focusNode, // Assign the focus node to the TextField
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: CheckboxListTile(
                        value: isLeafNode,
                        title: const Text(
                            "Does this Type have any items?"
                        ),
                        onChanged: (newValue) {
                          isLeafNode = !isLeafNode;
                          setState(() {

                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {

                    var cat = Category(
                        id: 0, name: controller.text, parentId: parentCategoryId
                    );

                    var content = jsonEncode(cat.toJson());

                    beforeAddCategoryRequest(content, parentCategoryId);// Close the dialog
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          });
        });
  }

  void afterAddTypeRequest(Response response, int categoryID) {
    if(response.statusCode == 201) {

      ItemType type = ItemType.fromJson(
          jsonDecode(response.body)
      );

      Category? category = categories[categoryID];
      category!.typesTree[type.id] = type;
      Navigator.of(context).pop();

      setState(() {

      });

    } else {
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent dismissing dialog by tapping outside
        builder: (BuildContext context) {
          TextEditingController controller = TextEditingController();

          return AlertDialog(
            title: Text('Error ${response.statusCode}'),

            content: Text(response.body),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  void beforeAddTypeRequest(String content, int categoryID) {
    post(
        Uri.parse("${Settings.server}/v0/items/item-types/item-type"),
        body: content,
        headers: Settings.headers
    ).then((value) => afterAddTypeRequest(value, categoryID));
  }

  Column getTypes({required Map<int, ItemType> types}) {
    List<Row> typeRows = [];

    // Fixed the MediaQuery call
    double windowWidth = MediaQuery.of(context).size.width;
    int columns = (windowWidth / 100).ceil();
    int rows = (types.length / columns).ceil();
    int count = 0;
    List<Widget> row = [];
    typeRows.add(Row(children: row));

    types.forEach((key, value) {
      row.add(
        Container(
          alignment: Alignment.topLeft,
          child: IconButton(
            onPressed: () {
              String url;
              if(value.isLeafNode) {
                url = "/items/item/leaf?typeID=${value.id}";
              } else {
                url = "/items/item-type/${value.id}/";
              }

              context.go(url);
            },
            icon: Text(value.name),
          ),
        ),
      );

      if (count % columns+1 == 0) {
        row = [];
        typeRows.add(Row(children: row));
      }

      count++;
    });

    return Column(children: typeRows);
  }

  List<Widget> getCategories({
    required bool rootNode,
    required Map<int, Category> categories}
      ) {
    if(categories.isEmpty) {
      return [];
    }

    List<Widget> containers = [
      Align(
        alignment: Alignment.topRight,
        child: rootNode ? IconButton(
          onPressed: () async {
            addCategory(parentCategoryId: 0);
          },
          padding: const EdgeInsets.all(20),
          icon: const Icon(
            Icons.add,
          ),
          tooltip: 'Add Category', // Set the hint text
        ) : const SizedBox(),
      )
    ];

    categories.forEach((key, value) {
      List<Widget> childrenTree = getCategories(
          rootNode: false,
          categories: value.childrenTree
      );

      List<Widget> children = [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value.name,
              style: rootNode ? bigStyle : smallStyle,
            ),
            Row(
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                        width: 1.0,
                        color: Colors.red
                    ),
                  ),
                  onPressed: () {
                    addCategory(parentCategoryId: value.id);
                  },

                  child: const Text(
                    "Add Sub Category",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red
                    ),
                  )
                ),

                const SizedBox(
                  width: 8,
                ),

                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      width: 1.0,
                      color: Colors.red
                    ),
                  ),
                  onPressed: () {
                    addItemType(categoryID: value.id);
                  },
                  child: const Text(
                    "Add Item Type",
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.red
                    ),
                  )
                ),
              ],
              // mainAxisAlignment:,
            )
          ],
        )
      ];
      children.addAll(childrenTree);
      children.add(getTypes(types: value.typesTree));

      var container = Container(
        padding: rootNode ? const EdgeInsets.all(30) : const EdgeInsets.all(10),
        alignment: Alignment.topLeft, // Ensure all containers align to the left

        decoration: value.parentId != 1 ? BoxDecoration(
            border: Border(
              bottom: BorderSide( //                   <--- right side
                color: Colors.grey.shade300,
                width: 1.0,
              ),
            )
        ) : BoxDecoration(

        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start
          children: children,
        ),
      );
      containers.add(container);
    });

    return containers;
  }

  void addItemType({required categoryID}) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing dialog by tapping outside
      builder: (BuildContext context) {
        TextEditingController controller = TextEditingController();
        FocusNode focusNode = FocusNode(); // Create a FocusNode
        bool isLeafNode = false;
        // Schedule the focus node to request focus after the build has completed
        WidgetsBinding.instance.addPostFrameCallback(
                (_) => focusNode.requestFocus()
        );

        return AlertDialog(
          title: const Text('Create Type'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: controller,
                  focusNode: focusNode, // Assign the focus node to the TextField
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: CheckboxListTile(
                    value: isLeafNode,
                    title: const Text(
                        "Does this Type have any items?"
                    ),
                    onChanged: (newValue) {
                      // Call invertLeafNode with the new value
                      // invertLeafNode(newValue!);
                      isLeafNode = !isLeafNode;
                      setState(() {

                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                var type = ItemType(
                    id: 0, name: controller.text, categoryId: categoryID,
                    parentId: 0, isLeafNode: isLeafNode
                );

                var content = jsonEncode(type.toJson());

                beforeAddTypeRequest(content, categoryID);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getHomePageData();
  }

  @override
  void dispose() {
    disposing = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Align(
        alignment: Alignment.topLeft,
        child: ListView(
          children: getCategories(
            rootNode: true,
            categories: orderedCategories
          ),
        ),
      ), currentRoute: '/',
    );
  }
}
