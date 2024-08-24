import "package:flutter/material.dart";
import "package:guhdaaru_frontend/structs/structs.dart";
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
  String newStatus = "";

  @override
  void initState() {
    nameController.text = widget.vendor.name;
    emailController.text = widget.vendor.email;
    locationController.text = widget.vendor.location;
    super.initState();
  }

  bool showSubmit() {
    var name = nameController.text.trim();
    var email = emailController.text.trim();
    var location = locationController.text.trim();

    if(name.isEmpty || email.isEmpty || location.isEmpty || newStatus.isEmpty) {
      return false;
    }

    return (
      name != widget.vendor.name || email != widget.vendor.email
        || location != widget.vendor.location ||
        newStatus != widget.vendor.status
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
                newStatus = value ?? "";
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
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog without action
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}