import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guhdaaru_frontend/structs/structs.dart';
import 'package:guhdaaru_frontend/views/utils/my_scaffold.dart';
import 'package:http/http.dart';
import '../structs/items.dart';

class HomePage extends StatefulWidget {
  final Map<int, Category> orderedCategories;
  final Map<int, Category> categories;
  const HomePage({
    super.key, required this.orderedCategories, required this.categories
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

  void afterAddCategoryRequest(Response response, int parent) {
    if(response.statusCode == 201) {

      Category newCategory = Category.fromJson(
        jsonDecode(response.body)
      );

      if(parent == 0) {
        widget.categories[newCategory.id] = newCategory;
        widget.orderedCategories[newCategory.id] = newCategory;
      } else {
        Category? parentCategory = widget.categories[parent];
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
      Uri.parse("${Settings.server}/items/categories/category"),
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

      Category? category = widget.categories[categoryID];
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
        Uri.parse("${Settings.server}/items/item-types/item-type"),
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
          children: [
            Text(
              value.name,
              style: rootNode ? bigStyle : smallStyle,
            ),
            IconButton(
              onPressed: () {
                addCategory(parentCategoryId: value.id);
              },
              padding: const EdgeInsets.all(10),
              icon: const Icon(
                Icons.add,
              ),
              tooltip: 'Add Sub Category', // Set the hint text
            ),
            IconButton(
              onPressed: () {
                addItemType(categoryID: value.id);
              },
              padding: const EdgeInsets.all(10),
              icon: const Icon(
                Icons.add,
              ),
              tooltip: 'Add Item Type', // Set the hint text
            ),
          ],
        )
      ];
      children.addAll(childrenTree);
      children.add(getTypes(types: value.typesTree));

      var container = Container(
        padding: rootNode ? const EdgeInsets.all(30) : const EdgeInsets.all(10),
        alignment: Alignment.topLeft, // Ensure all containers align to the left

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
          color: Colors.white, // Set container background color
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Soften the border
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
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
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Align(
        alignment: Alignment.topLeft,
        child: ListView(
          children: getCategories(
              rootNode: true,
              categories: widget.orderedCategories
          ),
        ),
      ),
    );
  }
}
