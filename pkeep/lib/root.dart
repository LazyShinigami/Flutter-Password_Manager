import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pkeep/common.dart';
import 'package:pkeep/db-conn.dart';
import 'package:pkeep/homepage.dart';
import 'package:pkeep/login.dart';

import 'model.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  late Future<String> loggedInUsername;
  @override
  void initState() {
    super.initState();
    loggedInUsername = _getLoggedInUsername();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: loggedInUsername,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasData) {
                if (snapshot.data!.length <= 0) {
                  return Login();
                } else {
                  return HomePage(username: snapshot.data!);
                }
              } else if (snapshot.hasError) {
                return Center(
                  child: myText.custom(
                    "Something went wrong!\nRestart the App",
                    fontColor: Colors.red,
                  ),
                );
              } else {
                return Center(
                  child: myText.custom(
                    "Something went wrong!\nRestart the App",
                    fontColor: Colors.red,
                  ),
                );
              }
          }
        },
      ),
    );
  }

  Future<String> _getLoggedInUsername() async {
    var dbHelper = SQLHelper();
    // List<User> user = [await dbHelper.getLoggedInUsername()];
    User user = await dbHelper.getLoggedInUsername();
    return (user.username == null) ? "" : user.username!;
  }
}
