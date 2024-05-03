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
  Map<int, int> attributePlaces = {};

  List<DataColumn> getColumns() {
    List<DataColumn> columns = [];
    List<int> ids = [];

    leaf.attributes.forEach((key, value) {
      ids.add(value.id);
    });
    ids.sort();

    return columns;
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
              columns: leaf.attributes.values.map(
                (item) => DataColumn(
                  label: Text(item.name)
                )
              ).toList(),
              rows: leaf.items.values.map(
                (item) => DataRow(
                  cells: item.attributes.values.map(
                    (attribute) => DataCell(Text(attribute.value))
                  ).toList()
                )
              ).toList()
            )
          ],
        )
    );
  }
}

