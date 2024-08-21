import 'dart:io';

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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Container(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                height: 200,
                width: 200,
                child: Image.network(
                    "http://10.62.13.11:8888/image?filename=smh.png"
                ),
              )
            ),

            Padding(
              padding: const EdgeInsets.all(2),
              child: ListTile(
                textColor: Colors.black,
                tileColor: Colors.grey,
                title: const Center(
                  child: Text(
                    'Home',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Arial",
                    ),
                  ),
                ),
                onTap: () {
                  nextWindows(context, "/");
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(2),
              child: ListTile(
                textColor: Colors.black,
                tileColor: Colors.grey,
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
                      ListTile(
                        textColor: Colors.black,
                        tileColor: Colors.grey,
                        title: const Center(
                          child: Text(
                            'View Vendors',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Arial",
                            ),
                          ),
                        ),
                        onTap: () {
                          nextWindows(context, "/vendors");
                        },
                      ),
                      ListTile(
                        textColor: Colors.black,
                        tileColor: Colors.grey,
                        title: const Center(
                          child: Text(
                            'My Vendors',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Arial",
                            ),
                          ),
                        ),
                        onTap: () {
                          nextWindows(context, "/my-vendors");
                        },
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  nextWindows(context, "/");
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(2),
              child: ListTile(
                textColor: Colors.black,
                tileColor: Colors.grey,
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
                      ListTile(
                        textColor: Colors.black,
                        tileColor: Colors.grey,
                        title: const Center(
                          child: Text(
                            'View Users',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Arial",
                            ),
                          ),
                        ),
                        onTap: () {
                          nextWindows(context, "/users");
                        },
                      ),
                      ListTile(
                        textColor: Colors.black,
                        tileColor: Colors.grey,
                        title: const Center(
                          child: Text(
                            'View Administrators',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Arial",
                            ),
                          ),
                        ),
                        onTap: () {
                          nextWindows(context, "/administrators");
                        },
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  nextWindows(context, "/");
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(2),
              child: ListTile(
                textColor: Colors.black,
                tileColor: Colors.grey,
                title: const Center(
                  child: Text(
                    'In Progress',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Arial",
                    ),
                  ),
                ),
                onTap: () {
                  nextWindows(context, "/item/listings?itemID=44622");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

