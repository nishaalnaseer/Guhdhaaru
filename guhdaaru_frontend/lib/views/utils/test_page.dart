import "dart:async";

import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  late DateTime gotHere = DateTime.now();
  int delta = 0;
  late Timer timer;

  void setDelta() {
    DateTime now = DateTime.now();
    delta = (now.millisecondsSinceEpoch -
        gotHere.millisecondsSinceEpoch) ~/ 1000;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setDelta();
      setState(() {

      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          ElevatedButton(
            onPressed: () {
              dispose();
              context.go("/");
            },
            child: const Text("Reload"),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
                "$delta Seconds"
            ),
          )
        ],
      ),
    );
  }
}

