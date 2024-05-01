import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:guhdaaru_frontend/structs/items.dart';
import 'package:guhdaaru_frontend/structs/structs.dart';
import 'package:guhdaaru_frontend/views/home_page.dart';
import 'package:guhdaaru_frontend/views/utils/blank.dart';
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

  // HomePage order() {
  //   getHomePage().then((value) => );
  // }

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
                path: '/items/item',
                builder: (BuildContext context, GoRouterState state) {
                  String? type = state.uri.queryParameters["type_id"];

                  bool showError;
                  if(type ==  null) {
                    showError = true;
                  } else {



                  }

                  return const SizedBox();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
