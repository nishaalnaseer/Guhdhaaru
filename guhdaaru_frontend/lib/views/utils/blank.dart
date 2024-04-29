import 'package:flutter/material.dart';

class Blank extends StatefulWidget {
  const Blank({super.key});

  @override
  State<Blank> createState() => _BlankState();
}

class _BlankState extends State<Blank> {

  @override
  void initState() {
    super.initState();

    initialise();
  }

  void initialise() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushNamed(context, "/");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
