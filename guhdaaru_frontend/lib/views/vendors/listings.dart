import 'package:flutter/material.dart';
import 'package:guhdaaru_frontend/views/utils/my_scaffold.dart';

import '../../structs/structs.dart';

class ListingsPage extends StatefulWidget {
  final ListingsPageStruct struct;
  const ListingsPage({super.key, required this.struct});

  @override
  State<ListingsPage> createState() => _ListingsPageState();
}

class _ListingsPageState extends State<ListingsPage> {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text("Listings"),
              ),
            )
          ],
        )
    );
  }
}
