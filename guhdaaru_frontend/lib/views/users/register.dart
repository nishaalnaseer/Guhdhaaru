import "dart:convert";

import "package:flutter/material.dart";
import "package:guhdaaru_frontend/structs/users.dart";
import "package:http/http.dart";

import "../../structs/structs.dart";

class RegisterPopup extends StatefulWidget {
  const RegisterPopup({super.key});

  @override
  State<RegisterPopup> createState() => _RegisterPopupState();
}

class _RegisterPopupState extends State<RegisterPopup> {
  String name = '';
  String email = '';
  String password = "";

  void afterRegister(Response response) {

    if(response.statusCode == 201) {
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent dismissing dialog by tapping outside
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
                'Success, an email will be sent to you for verification.'
            ),

            // content: Text(response.body),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent dismissing dialog by tapping outside
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
                'Failed, an email will be sent to you for verification.'
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
      title: const Text('Register'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(labelText: 'Full Name'),
            onChanged: (value) {
              setState(() {
                name = value;
              });
            },
          ),
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
            name = name.trim();
            email = email.trim();
            password = password.trim();

            if(email.isEmpty || password.isEmpty || name.isEmpty) {
              return;
            }

            var user = User(
                id: 0,
                name: name,
                email: email,
                password: password,
                isAdmin: true,
                enabled: true
            );

            await post(
              Uri.parse("${Settings.server}/v0/users/user/register"),
              body: jsonEncode(user.toJson()),
              headers: Settings.headers
            ).then(afterRegister);
          },
          child: const Text('Register'),
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