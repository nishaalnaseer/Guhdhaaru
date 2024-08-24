import 'package:flutter/material.dart';
import 'package:guhdaaru_frontend/structs/vendor.dart';

import 'items.dart';

class DrawerStruct {
  bool open = false;
  Function dispose;
  bool drawerInitialised = false;
  String currentRoute;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  DrawerStruct({
    required this.dispose,
    required this.currentRoute,
  });
}

class Settings {
  static String server = "https://api.guhdhaaru.nishawl.dev";
  static String imageServer = "http://127.0.0.1:10000";
  static Map<String, String> headers = {
    "accept": "application/json",
    "Content-Type": "application/json",
  };

  void setToken(String token) {
    Settings.headers["Authorization"] = token;
  }

  void setTokenNull() {
    headers.remove("Authorization");
  }

  bool loggedIn() {
    String? token = Settings.headers["Authorization"];

    return token != null;
  }
}

class ListingsPageStruct{
  final SingleItem item;
  final List<Listing> listings;

  ListingsPageStruct({
    required this.item,
    required this.listings,
  });

  factory ListingsPageStruct.fromJson(Map<String, dynamic> json) {
    var listings = (json["listings"] as List<dynamic>).map(
            (value) => Listing.fromJson(value)
    ).toList(growable: false);
    listings.sort((a, b) => a.id.compareTo(b.id));

    return ListingsPageStruct(
        item: SingleItem.fromJson(json["item"]),
        listings: listings
    );
  }
}
