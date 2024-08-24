import "dart:convert";

import "package:flutter/material.dart";
import "package:guhdaaru_frontend/structs/structs.dart";
import "package:guhdaaru_frontend/views/users/user.dart";
import "package:guhdaaru_frontend/views/utils/my_scaffold.dart";
import "package:http/http.dart";

import "../../structs/users.dart";

class UsersPage extends StatefulWidget {
  final bool adminOnly;
  const UsersPage({super.key, required this.adminOnly});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<User> users = [];
  late String currentRoute;

  Future<void> getUsers(String route) async {
    var response = await get(
      Uri.parse(
        "${Settings.server}$route"
      ),
      headers: Settings.headers
    );
    var content = jsonDecode(response.body) as List<dynamic>;
    users = content.map((json) => User.fromJson(json)).toList();

    setState(() {
    });
  }

  @override
  void initState() {

    String apiRoute;
    if(widget.adminOnly) {
      apiRoute = "/v0/users/admins";
      currentRoute = "/administrators";
    } else {
      apiRoute = "/v0/users/users";
      currentRoute = "/users";
    }

    getUsers(apiRoute);
    super.initState();
  }

  void update() {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
        body: Column(
          children: [
            Container(
              alignment: Alignment.center,
              width: MediaQuery.sizeOf(context).width,
              padding: const EdgeInsets.all(10),
              child: const Text(
                "Users",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Arial"
                ),
              ),
            ),

            SizedBox(
              height: 600,
              width: MediaQuery.sizeOf(context).width,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text("Name")),
                  DataColumn(label: Text("Email")),
                  DataColumn(label: Text("")),
                ],
                rows: users.map((user) => DataRow(
                    cells: [
                      DataCell(Text(user.name)),
                      DataCell(Text(user.email)),
                      DataCell(
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return UserPopUp(
                                  updateCallback: update,
                                  user: user,
                                ); // Show the register popup
                              },
                            );
                          },
                          child: const Text("View"),
                        )
                      ),
                    ]
                )).toList(),
              ),
            )
          ],
        ),
        currentRoute: currentRoute
    );
  }
}
