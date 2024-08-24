import "dart:convert";

import "package:flutter/material.dart";
import "package:guhdaaru_frontend/structs/structs.dart";
import "package:guhdaaru_frontend/views/vendors/vendor.dart";
import "package:http/http.dart";

import "../../structs/vendor.dart";


class RequestVendorPopUp extends StatefulWidget {
  final List<Vendor> existingVendors;
  final Function updateCallback;
  const RequestVendorPopUp({
    super.key, required this.existingVendors,
    required this.updateCallback
  });

  @override
  State<RequestVendorPopUp> createState() => _RequestVendorPopUpState();
}

class _RequestVendorPopUpState extends State<RequestVendorPopUp> {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void afterSubmit(Response response) {

    if(response.statusCode != 201) {
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
          }
      );
    } else {
      Navigator.of(context).pop();
      var vendor = Vendor.fromJson(jsonDecode(response.body));
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return VendorPopUp(
            updateCallback: widget.updateCallback,
            vendor: vendor, editable: false,
          ); // Show the register popup
        },
      );
    }

    var content = jsonDecode(response.body);
    var vendor = Vendor.fromJson(content);
    widget.existingVendors.add(vendor);

    widget.updateCallback();
  }

  void submit() async {

    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String location = locationController.text.trim();

    if(name.isEmpty || email.isEmpty || location.isEmpty) {
      return;
    }

    var vendorForEntry = Vendor(
        id: 0,
        name: name,
        email: email,
        location: location,
        status: "ENABLED",
        superAdmin: 1,
    );
    var content = jsonEncode(vendorForEntry.toJson());

    post(
      Uri.parse(
        "${Settings.server}/v0/vendors/vendor"
      ),
      headers: Settings.headers,
      body: content
    ).then(afterSubmit);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Request for Vendor"),
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
        TextButton(
          onPressed: () {
            submit();
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}

