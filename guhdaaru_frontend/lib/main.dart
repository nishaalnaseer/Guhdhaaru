import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:guhdaaru_frontend/structs/items.dart';
import 'package:guhdaaru_frontend/structs/structs.dart';
import 'package:guhdaaru_frontend/views/home_page.dart';
import 'package:guhdaaru_frontend/views/items/item_type_page.dart';
import 'package:guhdaaru_frontend/views/utils/blank.dart';
import 'package:guhdaaru_frontend/views/utils/error_page.dart';
import 'package:guhdaaru_frontend/views/utils/loading_page.dart';
import 'package:http/http.dart';
import 'package:go_router/go_router.dart';

void main(List<String> args) {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  Widget loading() {
    Widget box = const Center(
      child: SizedBox(
        height: 400,
        width: 400,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 10,
        ),
      ),
    );
    return box;
  }

  Future<void> getSample() async {}

  Future<Response> getHomePageData() async {
    return await get(Uri.parse("${Settings.server}/home"));
  }

  HomePage createHomePage(Response response) {

    var content = jsonDecode(response.body);
    var categoriesContent = content["categories"] as List<dynamic>;
    var typesContent = content["types"] as List<dynamic>;

    Map<int, Category> finalCategories = {};
    Map<int, Category> categories = {};

    for(var category_ in categoriesContent) {
      var category = Category.fromJson(category_);

      if(category.parentId == 0) {
        finalCategories[category.id] = category;
      }
      categories[category.id] = category;
    }

    categories.forEach((key, value) {
      int parentId = value.parentId;
      if(parentId != 0) {
        if(finalCategories.containsKey(parentId)) {
          var parent = finalCategories[parentId];
          parent!.childrenTree[key] = value;
        } else {
          var parent = categories[parentId];
          parent!.childrenTree[key] = value;
        }
      }
    });

    for(var type_ in typesContent) {
      var type = ItemType.fromJson(type_);
      var category = categories[type.categoryId];
      category!.typesTree[type.id] = type;
    }

    return HomePage(
        orderedCategories: finalCategories,
        categories: categories
    );
  }

  ItemTypePage createItemTypePage(Response response) {

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

    return ItemTypePage(item: itemType);
  }

  Future<Response> getItemTypePage(int typeID) async {
    return await get(
      Uri.parse(
        "${Settings.server}/items/item-types/item-type?type_id=$typeID"
      )
    );
  }

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
                path: 'details',
                builder: (BuildContext context, GoRouterState state) {
                  return const SizedBox();
                },
              ),

              GoRoute(
                path: 'items/item',
                builder: (BuildContext context, GoRouterState state) {
                  String? typeRaw = state.uri.queryParameters["type_id"];

                  bool showError;
                  int typeID;
                  if(typeRaw ==  null) {
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
            ],
          ),
        ],
      ),
    );
  }
}
