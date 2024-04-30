import 'package:flutter/material.dart';
import 'package:guhdaaru_frontend/views/utils/my_scaffold.dart';
import '../structs/items.dart';

class HomePage extends StatefulWidget {
  final Map<int, Category> categories;
  const HomePage({Key? key, required this.categories}) : super(key: key);

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

    // Fixed the MediaQuery call
    double windowWidth = MediaQuery.of(context).size.width;
    int columns = (windowWidth / 100).ceil();
    int rows = (types.length / columns).ceil();
    int count = 0;
    List<Widget> row = [];
    typeRows.add(Row(children: row));

    types.forEach((key, value) {
      row.add(
        Container(
          alignment: Alignment.topLeft,
          child: IconButton(
            onPressed: () {},
            icon: Text(value.name),
          ),
        ),
      );

      if (count % columns+1 == 0) {
        row = [];
        typeRows.add(Row(children: row));
      }

      count++;
    });

    return Column(children: typeRows);
  }

  List<Widget> getCategories(
      {required bool rootNode, required Map<int, Category> categories}) {
    List<Widget> containers = [];

    categories.forEach((key, value) {
      List<Widget> childrenTree = value.childrenTree.isNotEmpty
          ? getCategories(
          rootNode: false,
          categories: value.childrenTree
      ) : [];

      List<Widget> children = [
        Text(
          value.name,
          style: rootNode ? bigStyle : smallStyle,
        ),
      ];
      children.addAll(childrenTree);
      children.add(getTypes(types: value.typesTree));

      var container = Container(
        padding: rootNode ? const EdgeInsets.all(30) : const EdgeInsets.all(10),
        alignment: Alignment.topLeft, // Ensure all containers align to the left

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
          color: Colors.white, // Set container background color
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Soften the border
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start
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
