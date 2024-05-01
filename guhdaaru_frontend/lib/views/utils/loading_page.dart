import 'package:flutter/material.dart';
import 'package:http/http.dart';

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
          // Display the string retrieved from the coroutine
          return decodeFunction(snapshot.data);
        } else if (snapshot.hasError) {
          // Handle errors gracefully (optional)
          return const Text('Error fetching data');
        }
        // Show a loading indicator while waiting
        return const CircularProgressIndicator();
      },
    );
  }
}


// class LoadingPage extends StatefulWidget {
//   final Future<String> future;
//   final Function decodeFunction;
//   // final Function returnFunction;
//   const LoadingPage({
//     super.key, required this.future, required this.decodeFunction,
//     // required this.returnFunction
//   });
//
//   @override
//   State<LoadingPage> createState() => _LoadingPageState();
// }
//
// class _LoadingPageState extends State<LoadingPage> {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<String>(
//       future: widget.future,
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           // Display the string retrieved from the coroutine
//           return widget.decodeFunction(snapshot.data);
//         } else if (snapshot.hasError) {
//           // Handle errors gracefully (optional)
//           return const Text('Error fetching data');
//         }
//         // Show a loading indicator while waiting
//         return const CircularProgressIndicator();
//       },
//     );
//   }
// }
