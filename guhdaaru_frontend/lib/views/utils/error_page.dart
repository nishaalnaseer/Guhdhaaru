import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ErrorPage extends StatelessWidget {
  final String error;
  final String backRoute;
  const ErrorPage({
    super.key, required this.error, required this.backRoute
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(error),
        ),
        ElevatedButton(
            onPressed: () {
              context.go(backRoute);
            },
            child: const Text(
                "Go Back"
            )
        )
      ],
    );
  }
}
