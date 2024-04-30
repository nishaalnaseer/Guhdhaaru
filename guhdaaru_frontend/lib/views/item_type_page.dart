import 'package:flutter/material.dart';
import 'package:guhdaaru_frontend/views/utils/my_scaffold.dart';

class ItemTypePage extends StatefulWidget {
  const ItemTypePage({super.key});

  @override
  State<ItemTypePage> createState() => _ItemTypePageState();
}

class _ItemTypePageState extends State<ItemTypePage> {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Align(
        alignment: Alignment.topLeft,
        child: GridView.count(
          crossAxisCount: 2, // Number of columns
          crossAxisSpacing: 10.0, // Spacing between columns
          mainAxisSpacing: 10.0, // Spacing between rows
          padding: EdgeInsets.all(10.0), // Padding around the GridView
          children: List.generate(10, (index) {
            // Generate 10 items
            return GridTile(
              child: Container(
                color: Colors.blueGrey[100],
                child: Center(
                  child: Text(
                    'Item $index',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
