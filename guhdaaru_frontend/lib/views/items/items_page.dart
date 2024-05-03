import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guhdaaru_frontend/views/utils/my_scaffold.dart';

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

  List<DataColumn> getColumns() {
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

  void setRows() {
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

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                  child: Text(leaf.itemType.name)
              ),
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

