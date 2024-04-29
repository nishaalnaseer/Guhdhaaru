import 'package:flutter/material.dart';

class DrawerStruct {
  bool open = false;
  Function dispose;
  late Function updateDrawer;
  bool drawerInitialised = false;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  DrawerStruct({
    required this.dispose
  });
}

class Settings {
  static String server = "http://127.0.0.1:6969";
}
