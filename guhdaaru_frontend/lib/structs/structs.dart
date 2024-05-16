import 'package:flutter/material.dart';
import 'package:guhdaaru_frontend/structs/vendor.dart';
import 'package:guhdaaru_frontend/views/vendors/listings.dart';

import 'items.dart';

class DrawerStruct {
  bool open = false;
  Function dispose;
  bool drawerInitialised = false;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  DrawerStruct({
    required this.dispose
  });
}

class Settings {
  static String server = "http://127.0.0.1:6969";
  static Map<String, String> headers = {
    "accept": "application/json",
    "Content-Type": "application/json"
  };

  void setToken(String token) {
    headers["Authorization"] = token;
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
    return ListingsPageStruct(
        item: SingleItem.fromJson(json["item"]),
        listings: (json["listings"] as List<dynamic>).map(
                (value) => Listing.fromJson(value)
        ).toList(growable: false)
    );
  }
}
