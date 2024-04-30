import 'package:flutter/material.dart';
import 'package:guhdaaru_frontend/views/utils/my_scaffold.dart';

import '../structs/items.dart';

class HomePage extends StatefulWidget {
  final Map<int, Category> categories;
  const HomePage({super.key, required this.categories});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextStyle bigStyle = const TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.bold,
    fontFamily: "Roboto",
  );
  TextStyle smallStyle = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    fontFamily: "Roboto",
  );

  Column getTypes({required Map<int, ItemType> types}) {
    List<Row> typeRows = [];

    double windowWidth =  MediaQuery.sizeOf(context).width;
    int columns = (windowWidth / 100).ceil();
    int rows = (types.length / columns).ceil();
    int count = 0;
    List<Widget> row = [];
    // typeRows.add(Row(children: row,));

    types.forEach((key, value) {
      row.add(
          Container(
            alignment: Alignment.topLeft,
            child: IconButton(
              onPressed: () {  },
              icon: Text(value.name),
            ),
          )
      );

      if(count % columns == 0) {
        typeRows.add(Row(children: row,));
        row = [];
      }

      count++;
    });

    return Column(children: typeRows,);
  }

  List<Container> getCategories(
      {required bool rootNode, required Map<int, Category> categories}
      ) {

    List<Container> containers = [];

    categories.forEach((key, value) {

      late List<Container> childrenTree;
      if(value.childrenTree.isNotEmpty) {
        childrenTree = getCategories(
            rootNode: false, categories: value.childrenTree
        );
      } else {
        childrenTree = [];
      }

      // List<Widget> types = [];
      // value.typesTree.forEach((key, value) {
      //   types.add(
      //     ElevatedButton(
      //         onPressed: () {},
      //         child: Text(value.name)
      //     )
      //   );
      // });

      List<Widget> children = [
        Text(
            value.name,
            style: rootNode ? bigStyle : smallStyle
        ),
      ];
      children.addAll(childrenTree);
      children.add(getTypes(types: value.typesTree));

      var container = Container(
        padding: rootNode ? const EdgeInsets.all(30) : const EdgeInsets.all(10),
        alignment: rootNode ? Alignment.center : Alignment.bottomLeft,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.end,
          children: children,
        ),
      );
      containers.add(container);
    });

    return containers;
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Align(
        alignment: Alignment.topLeft,
        child: ListView(
          children: getCategories(rootNode: true, categories: widget.categories),
        ),
      ),
    );
  }
}
