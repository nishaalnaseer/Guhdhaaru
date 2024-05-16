import 'package:flutter/material.dart';
import 'package:http/http.dart';
import "package:go_router/go_router.dart";


class LoadingPage extends StatelessWidget {
  final Future<Response> future;
  final Function decodeFunction;
  const LoadingPage({
    super.key, required this.future, required this.decodeFunction
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Response>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return decodeFunction(snapshot.data);
        } else if (snapshot.hasError) {
          print(snapshot.stackTrace);
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Text(snapshot.error.toString()),
              ),
            ),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
