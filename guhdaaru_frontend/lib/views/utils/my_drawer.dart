
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guhdaaru_frontend/structs/structs.dart';

class MyDrawer extends StatefulWidget {
  final DrawerStruct struct;
  const MyDrawer({super.key, required this.struct});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  void nextWindows(BuildContext context, String route) {
    var uri = Uri.parse(
      "${Settings.server}$route"
    );

    if(uri.path == widget.struct.currentRoute) {
      return;
    }

    // context.replace(route);
    context.go(route);
  }

  void update() {
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    widget.struct.drawerInitialised = true;
  }

  Color getHoverColor(String route) {
    if(route == widget.struct.currentRoute) {
      return Colors.red;
    } else {
      return Colors.white;
    }
  }

  Color getTileColor(String route) {
    if(route == widget.struct.currentRoute) {
      return Colors.red;
    } else {
      return Colors.white;
    }
  }

  Color getFrontColor(String route) {
    if(route == widget.struct.currentRoute) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }

  Padding getTextTile(String route, String display) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: ListTile(
        textColor: Colors.black,
        tileColor: getTileColor(route),
        hoverColor: getHoverColor(route),
        title: Center(
          child: Text(
            display,
            style: TextStyle(
              color: getFrontColor(route),
              fontFamily: "Arial",
            ),
          ),
        ),
        onTap: () {
          nextWindows(context, route);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Container(
        child: ListView(
          children: [
            const SizedBox(
              // height: 200,
              // width: 200,
              child: Image(
                image: AssetImage(
                    'assets/images/general/drawer.jpg'
                ),
                fit: BoxFit.fill,
              ),
            ),

            getTextTile("/", "Home"),

            Padding(
              padding: const EdgeInsets.all(2),
              child: ListTile(
                textColor: Colors.black,
                tileColor: Colors.transparent,
                hoverColor: Colors.grey.shade200,
                title: Center(
                  child: ExpansionTile(
                    textColor: Colors.black,
                    title: const Center(
                        child: Text(
                          "Vendors",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Arial",
                          ),
                        )
                    ),

                    children: [
                      getTextTile("/vendors", "View Vendors"),
                      getTextTile("/vendors/me", "My Vendors"),
                    ],
                  ),
                ),
                onTap: () {
                  // nextWindows(context, "/");
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(2),
              child: ListTile(
                textColor: Colors.black,
                tileColor: Colors.transparent,
                title: Center(
                  child: ExpansionTile(
                    textColor: Colors.black,
                    title: const Center(
                      child: Text(
                        "Users",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Arial",
                        ),
                      )
                    ),

                    children: [
                      getTextTile("/users", "View Users"),
                      getTextTile(
                          "/administrators",
                          "View Administrators"
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  // nextWindows(context, "/");
                },
              ),
            ),

            // Padding(
            //   padding: const EdgeInsets.all(2),
            //   child: ListTile(
            //     textColor: Colors.black,
            //     title: const Center(
            //       child: Text(
            //         'In Progress',
            //         style: TextStyle(
            //           color: Colors.black,
            //           fontFamily: "Arial",
            //         ),
            //       ),
            //     ),
            //     onTap: () {
            //       nextWindows(context, "/item/listings?itemID=44622");
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

