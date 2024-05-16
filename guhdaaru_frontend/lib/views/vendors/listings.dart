import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guhdaaru_frontend/views/utils/my_scaffold.dart';

import '../../structs/structs.dart';

class ListingsPage extends StatefulWidget {
  final ListingsPageStruct struct;
  const ListingsPage({super.key, required this.struct});

  @override
  State<ListingsPage> createState() => _ListingsPageState();
}

class _ListingsPageState extends State<ListingsPage> {
  late ListingsPageStruct struct = widget.struct;

  DataTable itemDetails() {
    List<DataColumn> columns = [];
    List<DataCell> cells = [];
    Map<int, int> places = {};  // index, attributeID
    int index = 0;

    struct.item.attributes.forEach((key, value) {
      places[index] = value.id;
      index++;

      columns.add(
        DataColumn(
            label: Text(value.name)
        )
      );
    });

    struct.item.attributes.forEach((key, value) {
      var value = struct.item.values[key];

      DataCell cell;
      if(value == null) {
        cell = const DataCell(Text("--"));
      } else {
        cell = DataCell(Text(value.value));
      }

      cells.add(cell);
    });

    return DataTable(
      columns: columns,
      rows: [
        DataRow(
          cells: cells
        )
      ]
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text("Listings"),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(2),
              child: Text("Item ${struct.item.itemID}"),
            ),

            SizedBox(
              width: MediaQuery.sizeOf(context).width - 20,
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: itemDetails(),
              ),
            ),

            Container(
              width: MediaQuery.sizeOf(context).width - 20,
              height: MediaQuery.sizeOf(context).height - 250,
              padding: const EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ListView(
                  children: [
                    DataTable(
                      columns: const [
                        DataColumn(
                            label: Expanded(
                                child: Center(
                                    child: Text("Shop Name")
                                )
                            )
                        ),
                        DataColumn(
                            label: Expanded(
                                child: Center(
                                    child: Text("Location")
                                )
                            )
                        )
                      ],

                      rows: struct.listings.map(
                              (listing) => DataRow(
                              cells: [
                                DataCell(
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                            listing.vendor.name
                                        ),
                                      ),
                                    )
                                ),
                                DataCell(
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                            listing.vendor.location
                                        ),
                                      ),
                                    )
                                ),
                              ]
                          )
                      ).toList(),
                    )
                  ],
                ),
              ),
            )
          ],
        ), currentRoute: '/item/listings',
    );
  }
}
