import 'package:flutter/material.dart';

import '../../structs/structs.dart';
import 'my_drawer.dart';

class MyScaffold extends StatefulWidget {
  final Widget body;
  final String currentRoute;
  const MyScaffold({
    super.key,
    required this.body,
    required this.currentRoute,
  });

  @override
  State<MyScaffold> createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyScaffold> {
  late DrawerStruct drawerStruct;

  @override
  void initState() {
    super.initState();
    drawerStruct = DrawerStruct(
      dispose: dispose, currentRoute: widget.currentRoute
    );

    setState(() {

    });
  }

  // void dispose_() {
  //   Navigator.pop(context);
  //   Navigator.pop(context);
  // }


  @override
  Widget build(BuildContext context) {
    // Get the current theme data
    final ThemeData theme = Theme.of(context);
    // Get the color scheme
    final ColorScheme colorScheme = theme.colorScheme;
    // Access the secondary color
    final Color secondaryColor = colorScheme.secondary;
    final Color primary = colorScheme.primary;
    return Scaffold(
      key: drawerStruct.scaffoldKey,
      onDrawerChanged: (value) {
        drawerStruct.open = !drawerStruct.open;
        setState(() {

        });
      },
      drawer: MyDrawer(struct: drawerStruct,),
      appBar: AppBar(
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
            weight: 2.0,
          ),
          onPressed: () {
            drawerStruct.scaffoldKey.currentState?.openDrawer();
            setState(() {

            });
          },
        ),

        title: const Text(
          "Guhdhaaru",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontFamily: "Roboto",
          ),
        ),
      ),
      body: widget.body
    );
  }
}
