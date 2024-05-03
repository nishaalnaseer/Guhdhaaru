import 'package:flutter/material.dart';

class PopUp extends StatefulWidget {
  final Widget body;
  const PopUp({super.key, required this.body});

  @override
  State<PopUp> createState() => _PopUpState();
}

class _PopUpState extends State<PopUp> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 600,
      color: Colors.transparent,
      alignment: Alignment.center,
      child: widget.body,
    );
  }
}
