import 'package:flutter/material.dart';
import 'package:guhdaaru_frontend/structs/structs.dart';

class MyDrawer extends StatefulWidget {
  final DrawerStruct struct;
  const MyDrawer({super.key, required this.struct});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {

  void nextWindows(BuildContext context, String route) {
    widget.struct.dispose();
    dispose();
    Navigator.pushNamed(context, route);
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
      backgroundColor: Colors.black87,
      child: ListView(
        children: [
          // Padding(
          //     padding: const EdgeInsets.all(10),
          //     child: SizedBox(
          //       height: 200,
          //       width: 200,
          //       child: Image.network(
          //           "${Settings.server}/home"
          //       ),
          //     )
          // ),
          Padding(
            padding: const EdgeInsets.all(2),
            child: ExpansionTile(
              backgroundColor: Colors.grey,
              collapsedBackgroundColor: Colors.grey,
              iconColor: Colors.black,
              title: const Center(
                child: Text(
                  "Place",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Arial",
                  ),
                ),
              ),
              children: [
                ListTile(
                  textColor: Colors.black,
                  tileColor: Colors.grey,
                  title: const Center(
                    child: Text(
                      'Something',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Arial",
                      ),
                    ),
                  ),
                  onTap: () {
                    nextWindows(context, "/notTv?main");
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

