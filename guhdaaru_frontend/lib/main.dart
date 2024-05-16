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
import 'package:guhdaaru_frontend/views/utils/error_page.dart';
import 'package:guhdaaru_frontend/views/utils/loading_page.dart';
import 'package:guhdaaru_frontend/views/vendors/listings.dart';
import 'package:http/http.dart';
import 'package:go_router/go_router.dart';

Future<void> getSample() async {}

Future<Response> getHomePageData() async {
  return await get(Uri.parse("${Settings.server}/home"));
}

Widget createHomePage(Response response) {

  var content = jsonDecode(response.body);
  var categoriesContent = content["categories"] as List<dynamic>;
  var typesContent = content["types"] as List<dynamic>;

  Map<int, Category> finalCategories = {};
  Map<int, Category> categories = {};

  for(var category_ in categoriesContent) {
    var category = Category.fromJson(category_);

    if(category.id == 1) {
      continue;
    }

    if(category.parentId == 1) {
      finalCategories[category.id] = category;
    }
    categories[category.id] = category;
  }

  categories.forEach((key, value) {
    int parentId = value.parentId;
    if(parentId != 1) {
      if(finalCategories.containsKey(parentId)) {
        var parent = finalCategories[parentId];
        parent!.childrenTree[key] = value;
      } else {
        value.childrenTree[key] = value;
      }
    }
  });

  for(var type_ in typesContent) {
    var type = ItemType.fromJson(type_);

    if(type.id == 1) {
      continue;
    }

    var category = categories[type.categoryId];
    category!.typesTree[type.id] = type;
  }

  categories.forEach((key, value) {
    // Sort childrenTree in ascending order
    value.childrenTree = LinkedHashMap.fromEntries(
      value.childrenTree.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );

    // Sort typesTree in ascending order
    value.typesTree = LinkedHashMap.fromEntries(
      value.typesTree.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  });

  return HomePage(
      orderedCategories: finalCategories,
      categories: categories
  );
}

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
          "${Settings.server}/items/item-types/item-type?type_id=$typeID"
      )
  );
}

Future<Response> getLeafNode(int typeID) async {
  return await get(
    Uri.parse(
        "${Settings.server}/items/item-types/item-type"
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
    Uri.parse("${Settings.server}/listings_page?item_id=$itemID"),
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


void main(List<String> args) {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Guhdhaaru",

      routerConfig: GoRouter(
        routes: <RouteBase>[
          GoRoute(
            path: '/',
            builder: (BuildContext context, GoRouterState state) {
              return LoadingPage(
                decodeFunction: createHomePage,
                future: getHomePageData(),
              );
            },
            routes: <RouteBase>[
              GoRoute(
                path: 'items/item-type/:typeID',
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
                path: 'items/item/leaf',
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
                path: 'item/listings',
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
            ],
          ),
        ],
      ),
    );
  }
}
