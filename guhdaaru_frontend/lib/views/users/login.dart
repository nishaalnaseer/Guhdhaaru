import "dart:convert";

import "package:flutter/material.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:http/http.dart";

import "../../structs/structs.dart";

class LoginPopUp extends StatefulWidget {
  final Function updateCallback;
  const LoginPopUp({super.key, required this.updateCallback});

  @override
  State<LoginPopUp> createState() => _LoginPopUpState();
}

class _LoginPopUpState extends State<LoginPopUp> {
  String email = "nishawl.naseer@outlook.com";
  String password = "FinalYearApp123";

  void afterLogin(Response response) {
    if(response.statusCode == 201) {
      var content = jsonDecode(response.body);

      //             ex:                Bearer schema.payload.signature
      String token = "${content["token_type"]} ${content["access_token"]}";

      AndroidOptions getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
      late final storage = FlutterSecureStorage(aOptions: getAndroidOptions());
      storage.write(key: "token", value: token);

      Settings().setToken(token);

      Navigator.of(context).pop();
      widget.updateCallback();
    } else {
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent dismissing dialog by tapping outside
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
                'Failed.'
            ),

            content: Text(response.body),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Login'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(labelText: 'Email'),
            onChanged: (value) {
              setState(() {
                email = value;
              });
            },
          ),
          TextField(
            obscuringCharacter: "*",
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
            onChanged: (value) {
              setState(() {
                password = value;
              });
            },
          ),
        ],
      ),

      actions: [
        TextButton(
          onPressed: () async {
            email = email.trim();
            password = password.trim();

            if(email.isEmpty || password.isEmpty) {
              return;
            }

            var data = 'grant_type=&username=$email&password=$password'
            '&scope=&client_id=&client_secret=';

            await post(
              Uri.parse("${Settings.server}/token"),
              body: jsonEncode(data),
              headers: {
                'accept': 'application/json',
                'Content-Type': 'application/x-www-form-urlencoded'
              }).then(afterLogin);
          },
          child: const Text('Login'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog without action
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}