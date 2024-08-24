import "dart:convert";

import "package:flutter/material.dart";
import "package:guhdaaru_frontend/structs/structs.dart";
import "package:http/http.dart";
import "../../structs/users.dart";

class UserPopUp extends StatefulWidget {
  final User user;
  final Function updateCallback;
  const UserPopUp({
    super.key, required this.user, required this.updateCallback
  });

  @override
  State<UserPopUp> createState() => _UserPopUpState();
}

class _UserPopUpState extends State<UserPopUp> {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  late bool isAdmin = widget.user.isAdmin;
  late bool enabled = widget.user.enabled;

  @override
  void initState() {
    nameController.text = widget.user.name;
    emailController.text = widget.user.email;
    super.initState();
  }

  bool showSubmit() {
    return (
        isAdmin != widget.user.isAdmin
    ) || (
        enabled != widget.user.enabled
    );
  }

  void submit() async {

    widget.user.isAdmin = isAdmin;
    widget.user.enabled = enabled;
    var content = jsonEncode(widget.user.toJson());

    var response = await patch(
      Uri.parse("${Settings.server}/v0/users/user"),
      headers: Settings.headers,
      body: content
    );

    var user = User.fromJson(jsonDecode(response.body));
    widget.user.isAdmin = user.isAdmin;
    widget.user.enabled = user.enabled;
    setState(() {

    });
    widget.updateCallback();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.user.name),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(
                labelText: "Name",
                labelStyle: TextStyle(
                    color: Colors.black
                )
            ),
            controller: nameController,
            enabled: false,

            style: const TextStyle(
                color: Colors.black
            ),
          ),
          TextField(
            decoration: const InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(
                    color: Colors.black
                )
            ),
            controller: emailController,
            enabled: false,
            style: const TextStyle(
                color: Colors.black
            ),
          ),

          CheckboxListTile(
            title: const Text("Admin"),
            activeColor: Colors.red,
            value: isAdmin,
            onChanged: (value) {
              setState(() {
                isAdmin = !isAdmin;
              });
            }
          ),

          CheckboxListTile(
            title: const Text("ENABLED"),
              activeColor: Colors.red,
            value: enabled,
            onChanged: (value) {
              setState(() {
                enabled = !enabled;
              });
            }
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog without action
          },
          child: const Text(
            'Close',
            style: TextStyle(
              color: Colors.red
            ),
          ),
        ),
        showSubmit() ? ElevatedButton(
          onPressed: () {
            submit();
          },
          child: const Text(
            'Submit',
            style: TextStyle(
              color: Colors.red
            ),
          ),
        ) : const SizedBox(),
      ],
    );
  }
}