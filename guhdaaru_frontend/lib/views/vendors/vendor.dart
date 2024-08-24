import "dart:convert";

import "package:flutter/material.dart";
import "package:guhdaaru_frontend/structs/structs.dart";
import "package:http/http.dart";
import "../../structs/vendor.dart";

class VendorPopUp extends StatefulWidget {
  final Vendor vendor;
  final bool editable;
  final Function updateCallback;
  const VendorPopUp({
    super.key, required this.vendor, required this.updateCallback,
    required this.editable
  });

  @override
  State<VendorPopUp> createState() => _VendorPopUpState();
}

class _VendorPopUpState extends State<VendorPopUp> {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var locationController = TextEditingController();
  var isAdmin = Settings().isAdmin();
  late String status = widget.vendor.status;
  late String name = widget.vendor.name;
  late String email = widget.vendor.email;
  late String location = widget.vendor.location;

  @override
  void initState() {
    nameController.text = widget.vendor.name;
    emailController.text = widget.vendor.email;
    locationController.text = widget.vendor.location;
    super.initState();
  }

  void afterSubmit(Response response) {
    if(response.statusCode == 201) {
      var vendor = Vendor.fromJson(jsonDecode(response.body));
      widget.vendor.status = vendor.status;
      widget.vendor.location = vendor.location;
      widget.vendor.email = vendor.email;
      widget.vendor.superAdmin = vendor.superAdmin;
      widget.vendor.name = vendor.name;
      setState(() {

      });
      widget.updateCallback();
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
                'Failed.'
            ),
            content: Text(response.body),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  void submit() async {
    widget.vendor.status = status;
    widget.vendor.name = name;
    widget.vendor.email = email;
    widget.vendor.location = location;
    var content = jsonEncode(widget.vendor.toJson());

    String route;
    if(!isAdmin) {
      // if the user aint an admin but wants to update their vendor
      route = "/v0/vendors/vendor/me";
    } else {
      if(widget.editable) {
        // if the user is admin and their vendor
        route = "/v0/vendors/vendor";
      } else {
        // if the user is admin but not their vendor
        route = "/v0/vendors/vendor/status";
      }
    }

    patch(
      Uri.parse("${Settings.server}$route"),
      headers: Settings.headers,
      body: content
    ).then(afterSubmit);
  }

  bool showSubmit() {
    if(name.isEmpty || email.isEmpty || location.isEmpty || status.isEmpty) {
      return false;
    }

    return (
      name != widget.vendor.name || email != widget.vendor.email
        || location != widget.vendor.location ||
        status != widget.vendor.status
    );
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
            enabled: widget.editable,
            style: const TextStyle(
              color: Colors.black
            ),
            onChanged: (value) {
              setState(() {
                name = nameController.text;
              });
            },
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: "Email",
              labelStyle: TextStyle(
                color: Colors.black
              )
            ),
            controller: emailController,
            enabled: widget.editable,
            style: const TextStyle(
              color: Colors.black
            ),
            onChanged: (value) {
              setState(() {
                email = emailController.text;
              });
            },
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: "Location",
              labelStyle: TextStyle(
                color: Colors.black
              )
            ),
            controller: locationController,
            enabled: widget.editable,
            style: const TextStyle(
              color: Colors.black
            ),
            onChanged: (value) {
              setState(() {
                location = locationController.text;
              });
            },
          ),
          isAdmin ? Padding(
            padding: const EdgeInsets.all(10),
            child: DropdownButton(
              value: widget.vendor.status,
              hint: const Text("Status"),
              items: const [
                DropdownMenuItem(
                  value: "ENABLED",
                  child: Text("ENABLED"),
                ),
                DropdownMenuItem(
                  value: "DISABLED",
                  child: Text("DISABLED"),
                ),
                DropdownMenuItem(
                  value: "REQUESTED",
                  child: Text("REQUESTED"),
                ),
                DropdownMenuItem(
                  value: "DENIED",
                  child: Text("DENIED"),
                )
              ],
              onChanged: (value) {
                status = value ?? "";
                setState(() {

                });
              },
            ),
          )
              : const SizedBox()
        ],
      ),
      actions: [
        TextButton(
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
        showSubmit() ? TextButton(
          onPressed: (submit),
          child: const Text(
            'Submit',
            style: TextStyle(
              color: Colors.red
            ),
          ),
        )
            : const SizedBox(),
      ],
    );
  }
}