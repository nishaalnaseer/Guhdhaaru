import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../structs/structs.dart';
import '../users/login.dart';
import '../users/register.dart';
import 'my_drawer.dart';


class MyScaffold extends StatefulWidget {
  final Widget body;
  final String currentRoute;
  const MyScaffold({
    super.key,
    required this.body,
    required this.currentRoute,
  });

  @override
  State<MyScaffold> createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyScaffold> {
  late DrawerStruct drawerStruct;
  bool loggedIn = Settings().loggedIn();

  void getToken() async {
    AndroidOptions getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );
    late final storage = FlutterSecureStorage(aOptions: getAndroidOptions());

    String? token = await storage.read(key: "token");

    if(token == null) {
      return;
    }
    Settings().setToken(token);
    loggedIn = true;
  }

  @override
  void initState() {
    getToken();

    super.initState();
    drawerStruct = DrawerStruct(
      dispose: dispose, currentRoute: widget.currentRoute
    );

    setState(() {

    });
  }

  void update() {
    loggedIn = Settings().loggedIn();
    setState(() {
      loggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the current theme data
    final ThemeData theme = Theme.of(context);
    // Get the color scheme
    final ColorScheme colorScheme = theme.colorScheme;
    // Access the secondary color
    final Color secondaryColor = colorScheme.secondary;
    final Color primary = colorScheme.primary;
    return Scaffold(
      key: drawerStruct.scaffoldKey,
      onDrawerChanged: (value) {
        drawerStruct.open = !drawerStruct.open;
        setState(() {

        });
      },
      drawer: MyDrawer(struct: drawerStruct,),
      appBar: AppBar(
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
            weight: 2.0,
          ),
          onPressed: () {
            drawerStruct.scaffoldKey.currentState?.openDrawer();
            setState(() {

            });
          },
        ),

        title: const Text(
          "Guhdhaaru",
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: "Roboto",
          ),
        ),
        actions: [
          loggedIn ? TextButton(
            onPressed: () {
              Settings().setTokenNull();
              loggedIn = false;

              AndroidOptions getAndroidOptions() => const AndroidOptions(
                encryptedSharedPreferences: true,
              );
              late final storage = FlutterSecureStorage(aOptions: getAndroidOptions());
              storage.write(key: "token", value: null);

              setState(() {

              });
            },
            child: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ) : TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return LoginPopUp(
                    updateCallback: update,
                  ); // Show the register popup
                },
              );
            },
            child: const Text(
              'Login',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          loggedIn ? const SizedBox(

          ) : TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const RegisterPopup(); // Show the register popup
                },
              );
            },
            child: const Text(
              'Register',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: widget.body
    );
  }
}
