import 'dart:convert';

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
  static String imageServer = "https://images.guhdhaaru.nishawl.dev";
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

  bool isAdmin() {
    String? token = Settings.headers["Authorization"];

    if(token == null) {
      return false;
    }

    var payload = token.split(".")[1];
    var bytes = base64.decode(payload);
    var content = utf8.decode(bytes);
    var json = jsonDecode(content);

    bool? value = json["is_admin"];
    if(value == null) {
      return false;
    }
    return value;
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
