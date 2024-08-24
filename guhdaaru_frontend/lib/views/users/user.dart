import "package:flutter/material.dart";
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
        enabled != widget.user.isAdmin
    );
  }

  void submit() {
    
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
            value: isAdmin,
            onChanged: (value) {
              setState(() {
                isAdmin = !isAdmin;
              });
            }
          ),

          CheckboxListTile(
            title: const Text("ENABLED"),
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
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog without action
          },
          child: const Text('Cancel'),
        ),
        showSubmit() ? TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog without action
          },
          child: const Text('Submit'),
        ) : const SizedBox(),
      ],
    );
  }
}