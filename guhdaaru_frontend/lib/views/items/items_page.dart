import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  Map<int, TextEditingController> controllers = {};

  List<DataColumn> getColumns() {
    if(leaf.attributes.isEmpty) {
      return [const DataColumn(label: Text(""))];
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
    return finalColumns;
  }

  void viewListings(int itemID) {

  }

  void editItem(int itemID) {

  }

  void addItemToType(Map<String, dynamic> content) {

  }

  void editType(){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        var controller = TextEditingController();
        var newAttrController = TextEditingController();
        controller.text = leaf.itemType.name;

        List<Widget> children = [
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
                    onPressed: () {

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
                    newAttrController.clear();
                  },
                  child: const Text("Submit")
                )
              ],
            ),
          )
        );

        return StatefulBuilder(builder: (context, setState) {
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
          ElevatedButton(
            onPressed: () { viewListings(itemID); },
            child: const Text("View Listings"),
          )
        )
      );
      cells.add(
        DataCell(
          ElevatedButton(
            onPressed: () { editItem(itemID); },
            child: const Text("Edit Item"),
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
                    child: SizedBox(
                      width: 300,
                      child: TextField(
                        controller: controller,
                      ),
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
                            id: 1, attribute: attributeID, value: value
                        );
                        values.add(attributeValue.toJson());
                      }
                    });

                    var path = "/items/item/attributes-value";
                    post(
                      Uri.parse("${Settings.server}$path"),
                      headers: Settings.headers,
                      body: jsonEncode(values)
                    ).then((response) => popIfGood(response));
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

  void popIfGood(Response response) {
    if (response.statusCode >= 200 ) {
      var content = jsonDecode(response.body);

      var values = (content as List<dynamic>).map(
        (json) => ItemAttributeValue.fromJson(json)
      );

      Navigator.of(context).pop();
    } else if (response.statusCode >= 400) {
      var content = jsonDecode(response.body);
      print(content);
    }
  }

  @override
  void initState() {
    super.initState();
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
          DataTable(
            columns: getColumns(),
            rows: rows
          )
        ],
      )
    );
  }
}

