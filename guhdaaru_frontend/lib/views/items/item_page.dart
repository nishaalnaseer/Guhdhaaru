import 'package:flutter/material.dart';
import 'package:guhdaaru_frontend/views/utils/my_scaffold.dart';

import '../../structs/items.dart';

class LeafPage extends StatefulWidget {
  final LeafNode leaf;
  const LeafPage({super.key, required this.leaf});

  @override
  State<LeafPage> createState() => _LeafPageState();
}

class _LeafPageState extends State<LeafPage> {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Hello")
          ],
        )
    );
  }
}

