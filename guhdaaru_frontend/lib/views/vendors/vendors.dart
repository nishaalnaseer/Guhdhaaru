import "package:flutter/material.dart";
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
      
    );
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
            child: ListView.builder(
              itemCount: vendors.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text("Hello"),
                );
              }
            ),
          )
        ],
      ),
      currentRoute: '/vendors',
    );
  }
}
