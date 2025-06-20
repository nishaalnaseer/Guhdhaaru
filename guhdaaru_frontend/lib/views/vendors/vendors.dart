import "dart:convert";

import "package:flutter/material.dart";
import "package:guhdaaru_frontend/structs/structs.dart";
import "package:guhdaaru_frontend/views/vendors/request_vendor.dart";
import "package:guhdaaru_frontend/views/vendors/vendor.dart";
import "package:guhdaaru_frontend/views/vendors/vendor_listings.dart";
import "package:http/http.dart";

import "../../structs/vendor.dart";
import "../utils/my_scaffold.dart";

class VendorsPage extends StatefulWidget {
  final bool myVendors;
  final bool adminView;
  const VendorsPage({
    super.key, required this.myVendors, required this.adminView
  });

  @override
  State<VendorsPage> createState() => _VendorsPageState();
}

class _VendorsPageState extends State<VendorsPage> {
  List<Vendor> vendors = [];
  late String currentRoute;
  bool vendorEditable = false;

  void getVendors(String apiRoute) async {

    var response = await get(
      Uri.parse("${Settings.server}$apiRoute"),
      headers: Settings.headers
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

    String apiRoute;
    if(widget.myVendors) {
      apiRoute = "/v0/vendors/vendors/me";
      currentRoute = "/vendors/me";
      vendorEditable = true;
    } else {
      apiRoute = "/v0/vendors/vendors";
      currentRoute = "/vendors";
    }

    super.initState();
    getVendors(apiRoute);
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
            width: MediaQuery.sizeOf(context).width,
            child: Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.topRight,
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                        width: 1.0,
                        color: Colors.red
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return RequestVendorPopUp(
                          existingVendors: vendors,
                          updateCallback: update,
                        ); // Show the register popup
                      },
                    );
                  },
                  child: const Text(
                      "Request New Vendor",
                    style: TextStyle(
                      color: Colors.red
                    ),
                  )
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
                DataColumn(label: Text(""),),
                DataColumn(label: Text(""))
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
                              vendor: vendor, editable: vendorEditable,
                            ); // Show the register popup
                          },
                        );
                      },
                      child: const Text(
                          "View Details",
                        style: TextStyle(
                            color: Colors.red
                        ),
                      ),
                    )
                  ),
                  DataCell(
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return VendorListingsPopUp(
                              vendor: vendor,
                            ); // Show the register popup
                          },
                        );
                      },
                      child: const Text(
                          "View Listings",
                        style: TextStyle(
                            color: Colors.red
                        ),
                      ),
                    )
                  ),
                ]
              )).toList(),
            ),
          )
        ],
      ),
      currentRoute: currentRoute,
    );
  }
}
