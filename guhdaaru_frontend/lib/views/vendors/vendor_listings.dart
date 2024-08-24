import "dart:convert";

import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:guhdaaru_frontend/structs/structs.dart";
import "package:http/http.dart";

import "../../structs/vendor.dart";

class VendorListingsPopUp extends StatefulWidget {
  final Vendor vendor;
  const VendorListingsPopUp({super.key, required this.vendor});

  @override
  State<VendorListingsPopUp> createState() => _VendorListingsPopUpState();
}

class _VendorListingsPopUpState extends State<VendorListingsPopUp> {

  List<VendorListing> listings = [];

  void getListings() async {
    var response = await get(
      Uri.parse("${Settings.server}/v0/vendors/vendor/listings?"
          "vendor_id=${widget.vendor.id}"),
      headers: Settings.headers
    );

    var content = jsonDecode(response.body) as List<dynamic>;
    listings = content.map((json) => VendorListing.fromJson(json)).toList();
    setState(() {

    });
  }

  @override
  void initState() {
    getListings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Listings for ${widget.vendor.name}"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DataTable(
            columns: const [
              DataColumn(label: Text("Item Details")),
              DataColumn(label: Text("Item ID")),
              DataColumn(label: Text("")),
              DataColumn(label: Text("")),
            ],

            rows: listings.map((listing) => DataRow(
                cells: [
                  DataCell(Text("${listing.itemID}")),
                  DataCell(Text(listing.itemDetails)),
                  DataCell(
                    OutlinedButton(
                      onPressed: () {
                        context.go("/item/listings?itemID=${listing.itemID}");
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            width: 1.0,
                            color: Colors.red
                        ),
                      ),
                      child: const Text(
                        "View Item",
                        style: TextStyle(
                            color: Colors.black
                        ),
                      ),
                    )
                  ),
                  DataCell(
                    OutlinedButton(
                      onPressed: () {

                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          width: 1.0,
                          color: Colors.red
                        ),
                      ),
                      child: const Text(
                        "Remove Listing",
                        style: TextStyle(
                          color: Colors.black
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

      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
