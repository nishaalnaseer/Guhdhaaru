import "dart:convert";

import "package:flutter/material.dart";
import "package:guhdaaru_frontend/structs/users.dart";
import "package:http/http.dart";

import "../../structs/structs.dart";
import "../../structs/vendor.dart";

class VendorPopUp extends StatefulWidget {
  final Vendor vendor;
  final Function updateCallback;
  const VendorPopUp({
    super.key, required this.vendor, required this.updateCallback
  });

  @override
  State<VendorPopUp> createState() => _VendorPopUpState();
}

class _VendorPopUpState extends State<VendorPopUp> {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var locationController = TextEditingController();
  var statusController = TextEditingController();

  @override
  void initState() {
    nameController.text = widget.vendor.name;
    emailController.text = widget.vendor.email;
    locationController.text = widget.vendor.location;
    statusController.text = widget.vendor.status;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.vendor.name),
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
          TextField(
            decoration: const InputDecoration(
                labelText: "Location",
                labelStyle: TextStyle(
                    color: Colors.black
                )
            ),
            controller: locationController,
            enabled: false,
            style: const TextStyle(
                color: Colors.black
            ),
          ),
          TextField(
            decoration: const InputDecoration(
                labelText: "Status",
                labelStyle: TextStyle(
                    color: Colors.black
                )
            ),
            controller: statusController,
            enabled: false,
            style: const TextStyle(
                color: Colors.black
            ),
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
      ],
    );
  }
}