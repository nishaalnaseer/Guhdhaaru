import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guhdaaru_frontend/views/utils/my_scaffold.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

import '../../structs/items.dart';
import '../../structs/structs.dart';
import '../../utils/settings.dart';

class ItemTypePage extends StatefulWidget {
  final ItemType itemType;
  const ItemTypePage({super.key, required this.itemType});

  @override
  State<ItemTypePage> createState() => _ItemTypePageState();
}

class _ItemTypePageState extends State<ItemTypePage> {
  late ItemType itemType = widget.itemType;
  bool pickingFiles = false;

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
        barrierDismissible: false,
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
      context.go(url);
    } else {
      url = "/items/item-type/${child.id}/";
      context.push(url);
    }

    // context.pop();
    // context.replace(url);
  }

  void uploadItemImage() async {
    if(pickingFiles) {
      return;
    }
    pickingFiles = true;
    try {

      FilePickerResult? result = await
        FilePicker.platform.pickFiles();

      if (result != null) {
        final url = Uri.parse(
            '${Settings.imageServer}/v0/item-type/${widget.itemType.id}'
        );

        MultipartRequest req = MultipartRequest('POST', url);
        if(kIsWeb) {
            req.files.add(
                MultipartFile.fromBytes(
                  'file',
                  result.files.single.bytes!,
                  filename: result.files.single.name,
                )
            );
        } else {
          String filePath = result.files.single.path!;
          req.files.add(
              await MultipartFile.fromPath(
                'file', filePath
              )
          );
        }

        req.headers['accept'] = 'application/json';
        req.headers['Content-Type'] = 'multipart/form-data';
        req.headers['Authorization'] = Settings.headers["Authorization"] ?? "";

        final stream = await req.send();
        final res = await Response.fromStream(stream);
        final status = res.statusCode;
        if (status != 201) {
            throw Exception(
              'http.send error: statusCode= $status response=${res.body}'
          );
        }

        setState(() {
        });
      }
    } catch (e) {
      logger.log(Logger.level, e);
    }
    pickingFiles = false;
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

          Container(
            alignment: Alignment.topRight,
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.sizeOf(context).width - 100,
                ),

                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () {
                      uploadItemImage();
                    },
                    padding: const EdgeInsets.all(10),
                    icon: const Icon(
                      Icons.image,
                    ),
                    tooltip: 'Upload Image', // Set the hint text
                  ),
                ),

                IconButton(
                  onPressed: () {
                    addItemType();
                  },
                  padding: const EdgeInsets.all(10),
                  icon: const Icon(
                    Icons.add,
                  ),
                  tooltip: 'Add Item Type', // Set the hint text
                )
              ],
            ),
          ),

          Expanded(
            // flex: 1,
            child: SizedBox(
              height: 150,
              child: GridView.count(
                crossAxisCount: 15, // Number of columns
                crossAxisSpacing: 10.0, // Spacing between columns
                mainAxisSpacing: 10.0, // Spacing between rows
                padding: const EdgeInsets.all(10.0), // Padding around the GridView
                children: itemType.childrenTree.entries.map((entry) {
                  var child = entry.value;
                  return GridTile(
                    child: InkWell(
                      onTap: () {
                        forward(child);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)
                        ),

                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Image.network(
                              "${Settings.imageServer}/v0/item_type/${child.id}",
                              width: 50,
                              height: 50,
                              //"/item_type/${value.id}"
                            ),
                            Text(
                              child.name,
                              style: const TextStyle(
                                  color: Colors.black
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    // child: IconButton(
                    //   onPressed: () {
                    //     forward(child);
                    //   },
                    //   icon: Text(child.name),
                    // ),
                  );
                }).toList(),
              )
            )
          )
        ],
      ),
      currentRoute: '/items/item-type',
    );
  }
}
