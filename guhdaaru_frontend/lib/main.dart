import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:guhdaaru_frontend/structs/items.dart';
import 'package:guhdaaru_frontend/structs/structs.dart';
import 'package:guhdaaru_frontend/views/home_page.dart';
import 'package:guhdaaru_frontend/views/utils/blank.dart';
import 'package:http/http.dart';

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

  Future<List<Map<int, Category>>> getHomePage() async {
    var response = await get(Uri.parse("${Settings.server}/home"));
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

    return [categories, finalCategories];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guhdhaaru',

      onGenerateRoute: (settings) {
        switch (settings.name) {
          case "/":
            return MaterialPageRoute(
              builder: (context) => FutureBuilder(
                future: getHomePage(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Return a loading indicator while the data is being fetched
                    return loading();
                  } else if (snapshot.hasError) {
                    // Handle error case
                    return Text('Error: ${snapshot.error}');
                  } else {

                    var content = snapshot.data;

                    if(content == null) {
                      return const Blank();
                    }

                    Map<int, Category> ordered = content[1];
                    Map<int, Category> unOrdered = content[0];

                    return HomePage(
                      orderedCategories: ordered, categories: unOrdered,
                    );
                  }
                },
              )
            );
          case "/types/type":
            return MaterialPageRoute(
                builder: (context) => FutureBuilder(
                  future: getHomePage(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Return a loading indicator while the data is being fetched
                      return loading();
                    } else if (snapshot.hasError) {
                      // Handle error case
                      return Text('Error: ${snapshot.error}');
                    } else {

                      var content = snapshot.data;

                      if(content == null) {
                        return const Blank();
                      }

                      Map<int, Category> ordered = content[1];
                      Map<int, Category> unOrdered = content[0];

                      return HomePage(
                        orderedCategories: ordered, categories: unOrdered,
                      );
                    }
                  },
                )
            );
        }
        return MaterialPageRoute(
          builder: (context) => FutureBuilder(
            future: getSample(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return loading();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return const Blank();
              }
            },
          )
        );
      },
    );
  }
}
