import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:guhdaaru_frontend/structs/structs.dart';
import 'package:guhdaaru_frontend/views/utils/my_scaffold.dart';
import 'package:http/http.dart';

import '../../structs/items.dart';

class LeafPage extends StatefulWidget {
  final LeafNode leaf;
  const LeafPage({super.key, required this.leaf});

  @override
  State<LeafPage> createState() => _LeafPageState();
}

class _LeafPageState extends State<LeafPage> {
  late LeafNode leaf = widget.leaf;
  Map<int, int> attributePlaces = {};  // (index, attributeID)
  List<DataRow> rows = [];
  List<DataColumn> cols = [const DataColumn(label: Text(""))];
  Map<int, TextEditingController> controllers = {};

  void setColumns() {
    attributePlaces = {};
    List<DataColumn> cols = [];
    if(leaf.attributes.isEmpty) {
      return;
    }

    List<int> ids = [];
    Map<int, DataColumn> columns = {}; // Notice the nullable DataColumn

    leaf.attributes.forEach((key, value) {
      ids.add(value.id);
      columns[value.id] = DataColumn(label: Text(value.name));
    });
    ids.sort();

    List<DataColumn> finalColumns = [];
    int index = 0;
    for (var element in ids) {
      DataColumn column = columns[element]!;
      finalColumns.add(column);

      attributePlaces[index] = element;
      index++;

    }

    setRows();
    finalColumns.add(const DataColumn(label: Text("Item ID")));
    finalColumns.add(const DataColumn(label: Text("")));
    finalColumns.add(const DataColumn(label: Text("")));
    cols = finalColumns;
    this.cols = cols;

    setState(() {

    });
  }

  void _setState() {
    setState(() {

    });
  }

  void viewListings(int itemID) {

  }

  void editItem(Item item) {
    List<Widget> children = [];
    var controller = TextEditingController();
    var newAttrController = TextEditingController();
    controller.text = leaf.itemType.name;

    void setChildren() {
      // todo fix setstate when called from delete function doesnt work
      children = [];
      children = [
        Text("Item ID: ${item.id}")
      ];

      List<Widget> attributes = [];
      leaf.attributes.forEach((key, attribute) {
        var attrController = TextEditingController();

        ItemAttributeValue? itemValue = item.attributes[attribute.id];
        ElevatedButton button;
        if(itemValue != null) {
          attrController.text = itemValue.value;
          button = ElevatedButton(
                onPressed: () async {
                  String text = attrController.text.trim();

                  if(text.isEmpty || text == itemValue.value) {
                    return;
                  }
                  var itemID = itemValue.itemID;

                  var value = ItemAttributeValue(
                      id: itemValue.id,
                      attribute: itemValue.attribute,
                      value: attrController.text,
                      itemID: itemID
                  );

                  var response = await patch(
                    Uri.parse("${Settings.server}/v0/items/item/attribute-value"),
                    headers: Settings.headers,
                    body: jsonEncode(value.toJson())
                  );

                  if(response.statusCode >= 400) {
                    attrController.text = itemValue.value;
                    return;
                  }

                  var content = jsonDecode(response.body);
                  var newValue = ItemAttributeValue.fromJson(content);
                  leaf.items[itemID]!.attributes[newValue.id] = newValue;
                  setColumns();
                  _setState();
                },
                child: const Text("Edit")
            );
        } else {
          button = ElevatedButton(
              onPressed: () async {

                String text = attrController.text.trim();

                if(text.isEmpty) {
                  return;
                }

                var value = ItemAttributeValue(
                  id: 1,
                  attribute: attribute.id,
                  value: text,
                  itemID: item.id
                );
                var response = await patch(
                  Uri.parse(
                    "${Settings.server}/v0/items/item/add-attribute-value"
                  ),
                  headers: Settings.headers,
                  body: jsonEncode(value.toJson())
                );

                var content = jsonDecode(response.body);
                var newValue = ItemAttributeValue.fromJson(content);
                leaf.items[item.id]!.attributes[newValue.id] = newValue;
                setColumns();
                _setState();
              },
              child: const Text("Submit")
          );
        }

        attributes.add(
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: SizedBox(
                    width: 600,
                    child: SizedBox(
                      width: 500,
                      child: TextField(
                        controller: attrController,
                        decoration: InputDecoration(
                          labelText: attribute.name,
                        ),
                      ),
                    ),
                  ),
                ),
                button,
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                  child: ElevatedButton(
                    onPressed: () async {

                    },
                    child: const Text("Delete")
                  )
                )
              ],
            )
        );
      });

      children.addAll(attributes);
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {

        return StatefulBuilder(builder: (context, setState) {
          setChildren();
          return AlertDialog(
            title: const Center(child: Text('Edit Item')),
            content: SingleChildScrollView(
              child: Column(
                children: children,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Close'),
              ),
            ],
          );
        });
      });
  }

  void editTypeRequest(ItemType type) async {
    var response = await patch(
      Uri.parse("${Settings.server}/v0/items/item-types/item-type"),
      body: jsonEncode(type.toJson()),
      headers: Settings.headers
    );

    if(response.statusCode == 201) {
      leaf.itemType = ItemType.fromJson(jsonDecode(response.body));
      setState(() {

      });
    } else {
    }

  }

  void addAttribute(ItemAttribute attribute) async {
    var response = await patch(
      Uri.parse("${Settings.server}/v0/items/item/add-attribute"),
      headers: Settings.headers,
      body: jsonEncode(attribute.toJson())
    );

    if(response.statusCode == 201) {
      var content = jsonDecode(response.body);

      var newAttr = ItemAttribute.fromJson(content);
      leaf.attributes[newAttr.id] = newAttr;

      setColumns();
      setState(() {

      });

    }
  }

  void addAttributeValue(ItemAttributeValue value) async {
    var response = await patch(
        Uri.parse("${Settings.server}/items/item/add-attribute-value"),
        headers: Settings.headers,
        body: jsonEncode(value.toJson())
    );

    if(response.statusCode == 201) {
      var content = jsonDecode(response.body);

      var newValue = ItemAttributeValue.fromJson(content);
      var item = leaf.items[newValue.itemID];

      if(item == null) {
        throw Exception("Target item of ItemAttributeValue is null");
      }

      item.attributes[newValue.id] = newValue;

      setRows();
      setState(() {

      });
    }
  }

  Future<void> deleteAttribute(int attributeID) async {
    var response = await delete(
      Uri.parse(
        "${Settings.server}/v0/items/item/attribute?attribute_id=$attributeID"
      ),
      headers:  Settings.headers
    );
    // todo display error message if status code not 204
    if(response.statusCode == 204) {
      leaf.attributes.remove(attributeID);
      List<int> toRemove = [];
      for (var value in leaf.items.values) {
        value.attributes.forEach((key, value) {
          if(value.attribute == attributeID) {
            toRemove.add(key);
          }
        });

        for (var element in toRemove) {
          value.attributes.remove(element);
        }

      }

      setColumns();
      setState(() {

      });
    }
  }

  void editType(){

    List<Widget> children = [];
    var controller = TextEditingController();
    var newAttrController = TextEditingController();
    controller.text = leaf.itemType.name;

    void setChildren() {
      // todo fix setstate when called from delete function doesnt work
      children = [];
      children = [
        SizedBox(
          width: 600,
          child: Row(
            children: [
              SizedBox(
                width: 500,
                child: TextField(
                  controller: controller,
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    String newName = controller.text.trim();
                    if(newName.isEmpty) {
                      return;
                    }

                    var type = ItemType(
                        id: leaf.itemType.id,
                        name: newName,
                        parentId: leaf.itemType.parentId,
                        categoryId: leaf.itemType.categoryId,
                        isLeafNode: leaf.itemType.isLeafNode
                    );
                    editTypeRequest(type);

                  },
                  child: const Text("Submit")
              )
            ],
          ),
        )
      ];

      List<Widget> attributes = [];
      leaf.attributes.forEach((key, value) {
        var attrController = TextEditingController();
        attrController.text = value.name;
        attributes.add(
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: SizedBox(
                    width: 600,
                    child: SizedBox(
                      width: 500,
                      child: TextField(
                        controller: attrController,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                    },
                    child: const Text("Submit")
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                    child: ElevatedButton(
                        onPressed: () async {
                          await deleteAttribute(value.id);
                          setChildren();
                          setState(() {

                          });
                        },
                        child: const Text("Delete")
                    )
                )
              ],
            )
        );
      });

      children.addAll(attributes);

      children.add(
          SizedBox(
            width: 600,
            child: Row(
              children: [
                SizedBox(
                  width: 500,
                  child: TextField(
                    controller: newAttrController,
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      String name = newAttrController.text.trim();

                      if(name.isEmpty) {
                        return;
                      }

                      var attribute = ItemAttribute(
                          id: 0,
                          name: name,
                          typeID: leaf.itemType.id
                      );
                      addAttribute(attribute);

                      newAttrController.clear();
                    },
                    child: const Text("Submit")
                )
              ],
            ),
          )
      );
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {

        return StatefulBuilder(builder: (context, setState) {
          setChildren();
          return AlertDialog(
            title: const Text('Edit Item Type'),
            content: SingleChildScrollView(
              child: Column(
                children: children,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Close'),
              ),
            ],
          );
        });
      });
  }

  void setRows() {
    if(leaf.attributes.isEmpty) {
      this.rows = [];
      return;
    }

    List<DataRow> rows = [];

    leaf.items.forEach((itemID, item) {
      List<DataCell> cells = [];
      attributePlaces.forEach((index, attributeID) {
        ItemAttributeValue? value = item.attributes[attributeID];

        String text;
        if(value == null) {
          text = "--";
        } else {
          text = value.value;
        }

        cells.add(DataCell(Text(text)));
      });

      cells.add(DataCell(Text("$itemID")));

      cells.add(
        DataCell(
          IconButton(
            onPressed: () {
              context.go("/item/listings?itemID=$itemID");
            },
            icon: const Icon(
                Icons.list
            ),
            tooltip: "View Listings",
          )
        )
      );
      cells.add(
        DataCell(
          IconButton(
            onPressed: () {
              editItem(item);
            },
            icon: const Icon(
              Icons.edit
            ),
            tooltip: "Edit Item",
          )
        )
      );

      rows.add(DataRow(cells: cells));
    });

    this.rows = rows;
  }

  void addItem() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        List<Widget> children = [];
        controllers = {};

        leaf.attributes.forEach((key, value) {
          var controller = TextEditingController();
          controllers[key] = controller;
          String text = "${value.name}:";

          children.add(
            Row(
              children: [
                Text(
                    text
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: SizedBox(
                    width: 300,
                    child: TextField(
                      controller: controller,
                    ),
                  ),
                )
              ],
            )
          );
        });

        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Center(
              child: Text('Add Item'),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: children,
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextButton(
                  onPressed: () async {
                    
                    List<Map<String, dynamic>> values = [];
                    
                    controllers.forEach((attributeID, controller) { 
                      String value = controller.text.trim();
                      
                      if( value.isNotEmpty ){
                        var attributeValue = ItemAttributeValue(
                            id: 1, attribute: attributeID, value: value,
                            itemID: 0
                        );
                        values.add(attributeValue.toJson());
                      }
                    });

                    var path = "/v0/items/item/attributes-value";
                    post(
                      Uri.parse("${Settings.server}$path"),
                      headers: Settings.headers,
                      body: jsonEncode(values)
                    ).then((response) => afterAddingItem(response));
                  },
                  child: const Center(
                    child: Text('Submit'),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Center(
                  child: Text('Cancel'),
                ),
              ),
            ],
          );
        });
      });
  }

  void afterAddingItem(Response response) {
    // FIXME
    if (response.statusCode == 201 ) {
      var content = jsonDecode(response.body);

      var values = (content["attributes"] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, ItemAttributeValue.fromJson(value))
      );

      values.forEach((key, value) {
        var item = leaf.items[value.itemID];
        item ??= Item(id: value.itemID, attributes: {});
        item.attributes[value.id] = value;
      });

      Navigator.of(context).pop();
      setColumns();
      setState(() {

      });
    } else if (response.statusCode >= 400) {
      var content = jsonDecode(response.body);
    }
  }

  @override
  void initState() {
    super.initState();
    setColumns();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                    child: Text(leaf.itemType.name)
                ),
              ),

              Row(
                children: [
                  const Expanded(child: SizedBox()),
                  IconButton(
                    onPressed: () {
                      addItem();
                    },
                    padding: const EdgeInsets.all(10),
                    icon: const Icon(
                      Icons.add,
                    ),
                    tooltip: 'Add Item',
                  ),

                  IconButton(
                    onPressed: () {
                      editType();
                    },
                    padding: const EdgeInsets.all(10),
                    icon: const Icon(
                      Icons.edit,
                    ),
                    tooltip: 'Edit Type',
                  ),

                  IconButton(
                    onPressed: () {
                    },
                    padding: const EdgeInsets.all(10),
                    icon: const Icon(
                      Icons.delete,
                    ),
                    tooltip: 'Delete Item Type',
                  )
                ],
              ),
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height-100,
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: [
                DataTable(
                  columns: cols,
                  rows: rows,
                )
              ],
            ),
          )
        ],
      ), currentRoute: '/items/item/leaf',
    );
  }
}
