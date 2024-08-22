import "dart:convert";

import "package:flutter/material.dart";
import "package:guhdaaru_frontend/structs/structs.dart";
import "package:guhdaaru_frontend/views/vendors/vendor.dart";
import "package:http/http.dart";

import "../../structs/vendor.dart";
import "../utils/my_scaffold.dart";

class VendorsPage extends StatefulWidget {
  const VendorsPage({super.key});

  @override
  State<VendorsPage> createState() => _VendorsPageState();
}

class _VendorsPageState extends State<VendorsPage> {
  List<Vendor> vendors = [];

  void getVendors() async {
    var response = await get(
      Uri.parse("${Settings.server}/v0/vendors/vendors")
    );
    
    var content = jsonDecode(response.body) as List<dynamic>;
    
    vendors = content.map((json) => Vendor.fromJson(json)).toList();

    setState(() {

    });
  }

  void update() {
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    getVendors();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Column(
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width,
            padding: const EdgeInsets.all(10),
            child: Align(
              alignment: Alignment.center,
              child: SearchAnchor(
                builder: (BuildContext context, SearchController controller) {
                  return SearchBar(
                    controller: controller,
                    hintText: "Search Vendor",
                    onTap: () {
                      controller.openView();
                    },
                    onChanged: (_) {
                      controller.openView();
                    },
                    leading: const Icon(Icons.search),
                    // trailing: <Widget>[
                    //   Tooltip(
                    //     message: 'Change brightness mode',
                    //     child: IconButton(
                    //       isSelected: isDark,
                    //       onPressed: () {
                    //         setState(() {
                    //           isDark = !isDark;
                    //         });
                    //       },
                    //       icon: const Icon(Icons.wb_sunny_outlined),
                    //       selectedIcon: const Icon(Icons.brightness_2_outlined),
                    //     ),
                    //   )
                    // ],
                  );
                },

                suggestionsBuilder: (BuildContext context, SearchController controller) {
                  return List<ListTile>.generate(5, (int index) {
                    final String item = 'item $index';
                    return ListTile(
                      title: Text(item),
                      onTap: () {
                        setState(() {
                          controller.closeView(item);
                        });
                      },
                    );
                  });
                }
              ),
            ),
          ),

          SizedBox(
            height: MediaQuery.sizeOf(context).height - 250,
            width: MediaQuery.sizeOf(context).width,
            child: DataTable(
              columns: const [
                DataColumn(label: Text("Name"),),
                DataColumn(label: Text("Location"),),
                DataColumn(label: Text(""),)
              ],
              rows: vendors.map((vendor) => DataRow(
                  cells: [
                    DataCell(Text(vendor.name)),
                    DataCell(Text(vendor.location)),
                    DataCell(
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return VendorPopUp(
                                updateCallback: update,
                                vendor: vendor,
                              ); // Show the register popup
                            },
                          );
                        },
                        child: const Text("View"),
                      )
                    ),
                  ]
              )).toList(),
            ),
          )
        ],
      ),
      currentRoute: '/vendors',
    );
  }
}
