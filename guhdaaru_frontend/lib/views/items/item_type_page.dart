import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guhdaaru_frontend/views/utils/my_scaffold.dart';
import 'package:http/http.dart';

import '../../structs/items.dart';
import '../../structs/structs.dart';

class ItemTypePage extends StatefulWidget {
  final ItemType itemType;
  const ItemTypePage({super.key, required this.itemType});

  @override
  State<ItemTypePage> createState() => _ItemTypePageState();
}

class _ItemTypePageState extends State<ItemTypePage> {
  late ItemType itemType = widget.itemType;

  void afterAddTypeRequest(Response response) {
    if(response.statusCode == 201) {

      ItemType type = ItemType.fromJson(
          jsonDecode(response.body)
      );

      itemType.childrenTree[type.id] = type;
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

  void beforeAddTypeRequest(String content) {
    post(
        Uri.parse("${Settings.server}/v0/items/item-types/item-type"),
        body: content,
        headers: Settings.headers
    ).then((value) => afterAddTypeRequest(value));
  }

  void addItemType() {

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
                      id: 0, name: controller.text,
                      categoryId: itemType.categoryId,
                      parentId: itemType.id, isLeafNode: isLeafNode
                  );

                  var content = jsonEncode(type.toJson());

                  beforeAddTypeRequest(content);
                },
                child: const Text('Add'),
              ),
            ],
          );
        });
      });
  }

  void forward(ItemType child) {
    String url;
    if(child.isLeafNode) {
      url = "/items/item/leaf?typeID=${child.id}";
    } else {
      url = "/items/item-type/${child.id}/";
    }

    context.pop();
    context.go(url);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Text(
                itemType.name,
                style: const TextStyle(
                    fontWeight: FontWeight.w500
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                addItemType();
              },
              padding: const EdgeInsets.all(10),
              icon: const Icon(
                Icons.add,
              ),
              tooltip: 'Add Item Type', // Set the hint text
            ),
          ),

          Expanded(
            child: SizedBox(
              child: GridView.count(
                crossAxisCount: 15, // Number of columns
                crossAxisSpacing: 10.0, // Spacing between columns
                mainAxisSpacing: 10.0, // Spacing between rows
                padding: const EdgeInsets.all(10.0), // Padding around the GridView
                children: itemType.childrenTree.entries.map((entry) {
                  var child = entry.value;
                  return GridTile(
                    child: IconButton(
                      onPressed: () {
                        forward(child);
                      },
                      icon: Text(child.name),
                    ),
                  );
                }).toList(),
              )
            )
          )
        ],
      ), currentRoute: '/items/item-type',
    );
  }
}
