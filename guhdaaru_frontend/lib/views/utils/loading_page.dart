import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'my_scaffold.dart';


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
          return MyScaffold(
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Text(snapshot.error.toString()),
              ),
            ), currentRoute: '/error',
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
