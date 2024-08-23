import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:guhdaaru_frontend/structs/items.dart';
import 'package:guhdaaru_frontend/structs/structs.dart';
import 'package:guhdaaru_frontend/structs/vendor.dart';
import 'package:guhdaaru_frontend/views/home_page.dart';
import 'package:guhdaaru_frontend/views/items/items_page.dart';
import 'package:guhdaaru_frontend/views/items/item_type_page.dart';
import 'package:guhdaaru_frontend/views/users/users.dart';
import 'package:guhdaaru_frontend/views/utils/error_page.dart';
import 'package:guhdaaru_frontend/views/utils/loading_page.dart';
import 'package:guhdaaru_frontend/views/vendors/listings.dart';
import 'package:guhdaaru_frontend/views/vendors/vendors.dart';
import 'package:http/http.dart';
import 'package:go_router/go_router.dart';

Future<void> getSample() async {}

Widget createItemTypePage(Response response) {
  Map<int, ItemType> childrenTree = {};

  var content = jsonDecode(response.body) as List<dynamic>;

  String itemIDRaw = response.request!.url.query.split("=")[1];
  int itemID = int.parse(itemIDRaw);
  ItemType? itemType;

  for(var x in content){
    ItemType type = ItemType.fromJson(x);

    if(type.id == itemID) {
      itemType = type;
    } else {
      childrenTree[type.id] = type;
    }
  }
  itemType!.childrenTree = childrenTree;

  return ItemTypePage(itemType: itemType,);
}

Future<Response> getItemTypePage(int typeID) async {
  return await get(
      Uri.parse(
          "${Settings.server}/v0/items/item-types/item-type?type_id=$typeID"
      )
  );
}

Future<Response> getLeafNode(int typeID) async {
  return await get(
    Uri.parse(
        "${Settings.server}/v0/items/item-types/item-type"
            "/leaf-node?type_id=$typeID"
    )
  );
}

LeafPage createLeafPage(Response response) {

  var content = jsonDecode(response.body);
  LeafNode leaf = LeafNode.fromJson(content);

  return LeafPage(leaf: leaf);
}

Future<Response> getListingsPage(int itemID) async {
  var response = await get(
    Uri.parse("${Settings.server}/v0/listings_page?item_id=$itemID"),
    headers: Settings.headers
  );

  if(response.statusCode > 399) {
    throw Exception(
      "Server returned ${response.statusCode} \ncontent: ${
        jsonDecode(response.body)
      }");
  }

  return response;
}

ListingsPage createListingsPage(Response response) {
  var struct = ListingsPageStruct.fromJson(jsonDecode(response.body));
  return ListingsPage(
    struct: struct,
  );
}


final GoRouter goRouter = GoRouter(
    routes: [

      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        },
      ),

      GoRoute(
        path: '/items/item-type/:typeID',
        builder: (BuildContext context, GoRouterState state) {
          String? typeRaw = state.pathParameters["typeID"];

          bool showError;
          int typeID;
          if(typeRaw == null) {
            showError = true;
          } else {
            try {
              typeID = int.parse(typeRaw);
              showError = false;
            } on FormatException {
              showError = true;
            }
          }

          if(showError) {
            return const ErrorPage(
                error: "Invalid item type ID",
                backRoute: "/"
            );
          }

          typeID = int.parse(typeRaw!);
          return LoadingPage(
              future: getItemTypePage(typeID),
              decodeFunction: createItemTypePage
          );
        },
      ),

      GoRoute(
        path: '/items/item/leaf',
        builder: (BuildContext context, GoRouterState state) {
          String? idRaw = state.uri.queryParameters["typeID"];

          bool showError;
          int id;
          if(idRaw == null) {
            showError = true;
          } else {
            try {
              id = int.parse(idRaw);
              showError = false;
            } on FormatException {
              showError = true;
            }
          }

          if(showError) {
            return const ErrorPage(
                error: "Invalid item ID",
                backRoute: "/"
            );
          }

          id = int.parse(idRaw!);
          return LoadingPage(
              future: getLeafNode(id),
              decodeFunction: createLeafPage
          );
        },
      ),

      GoRoute(
        path: '/item/listings',
        builder: (BuildContext context, GoRouterState state) {
          String? itemID = state.uri.queryParameters["itemID"];

          bool showError;
          int id;
          if(itemID == null) {
            showError = true;
          } else {
            try {
              id = int.parse(itemID);
              showError = false;
            } on FormatException {
              showError = true;
            }
          }

          if(showError) {
            return const ErrorPage(
                error: "Invalid item ID",
                backRoute: "/"
            );
          }

          id = int.parse(itemID!);
          return LoadingPage(
              future: getListingsPage(id),
              decodeFunction: createListingsPage
          );
        },
      ),

      GoRoute(
        path: '/vendors',
        builder: (BuildContext context, GoRouterState state) {

          return const VendorsPage(myVendors: false,);
        },
      ),

      GoRoute(
        path: '/vendors/me',
        builder: (BuildContext context, GoRouterState state) {

          return const VendorsPage(myVendors: true,);
        },
      ),

      GoRoute(
        path: '/users',
        builder: (BuildContext context, GoRouterState state) {

          return const UsersPage(adminOnly: false,);
        },
      ),

      GoRoute(
        path: '/administrators',
        builder: (BuildContext context, GoRouterState state) {

          return const UsersPage(adminOnly: true,);
        },
      ),

    ]
);


void main(List<String> args) {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Guhdhaaru",

      routerConfig: goRouter,
    );
  }
}
