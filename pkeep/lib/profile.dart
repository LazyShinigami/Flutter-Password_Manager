// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pkeep/db-conn.dart';
import 'package:pkeep/login.dart';
import 'common.dart';
import 'model.dart';

class Profile extends StatefulWidget {
  String username;
  Profile({required this.username, super.key});

  @override
  State<Profile> createState() => _ProfileState(username);
}

class _ProfileState extends State<Profile> {
  String username;
  _ProfileState(this.username);
  late Future<Map<String, dynamic>> userDetails;
  @override
  void initState() {
    super.initState();
    userDetails = _getUserDetails(username);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        backgroundColor: Colors.black,
        title: myText.custom(
          "Profile",
          fontSize: 25,
          letterSpace: 5,
        ),
        centerTitle: true,
        toolbarHeight: 75,
      ),

      // drawer
      endDrawer: MyDrawer(username: username),

      // body
      body: BackgroundContainer(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
          child: Center(
            child: FutureBuilder(
              future: userDetails,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          myText.custom(
                            snapshot.data!['username'],
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            letterSpace: 4,
                          ),
                          const Divider(
                              height: 60, thickness: 1, color: Colors.white),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                myText.custom("Name"),
                                myText.custom(snapshot.data!['name']),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                myText.custom("E-mail"),
                                myText.custom(snapshot.data!['email']),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                myText.custom("Total Credentials Secured"),
                                myText.custom("${snapshot.data!['total']}"),
                              ],
                            ),
                          ),
                          const Divider(height: 40, color: Colors.white),
                          TextButton(
                            onPressed: _comingSoonPopup,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.password_rounded,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 15),
                                myText.custom(
                                  "Edit Password",
                                  letterSpace: 2,
                                  fontSize: 15,
                                )
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              var dbHelper = SQLHelper();
                              var users = await dbHelper.readAllUsers();
                              for (User user in users) {
                                dbHelper.updateLoggedInState(
                                    newValue: "NO", userID: user.userID!);
                              }
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login()),
                                (route) => false,
                              );
                            },
                            child: Row(
                              children: [
                                MyIcon(
                                  name: "logout",
                                  color: Colors.white,
                                  height: 20,
                                ),
                                const SizedBox(width: 15),
                                myText.custom(
                                  "Logout",
                                  letterSpace: 2,
                                  fontSize: 15,
                                )
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              var dbHelper = SQLHelper();
                              var users = await dbHelper.readAllUsers();
                              for (User user in users) {
                                dbHelper.updateLoggedInState(
                                    newValue: "NO", userID: user.userID!);
                              }
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login()),
                                (route) => false,
                              );
                            },
                            child: Row(
                              children: [
                                MyIcon(
                                  name: "swap",
                                  color: Colors.white,
                                  height: 20,
                                ),
                                const SizedBox(width: 15),
                                myText.custom(
                                  "Switch Account",
                                  letterSpace: 2,
                                  fontSize: 15,
                                )
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Row(
                              children: [
                                MyIcon(
                                  name: "delete",
                                  color: Colors.red,
                                  height: 20,
                                ),
                                const SizedBox(width: 15),
                                myText.custom(
                                  "Delete Account",
                                  letterSpace: 2,
                                  fontColor: Colors.red,
                                  fontSize: 15,
                                )
                              ],
                            ),
                          )
                        ],
                      );
                    } else {
                      return myText
                          .custom("Something went wrong! Restart the app!");
                    }
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> _getUserDetails(username) async {
    Map<String, dynamic> deets = {};
    var dbHelper = SQLHelper();
    List<User> users = await dbHelper.readAllUsers();
    for (User user in users) {
      if (user.username == username) {
        deets["username"] = username;
        deets["name"] = user.name;
        deets["email"] = user.email;
      }
    }
    List<Password> passwords = await dbHelper.readPasswordsByUsername(username);
    deets["total"] = passwords.length;
    return deets;
  }

  _comingSoonPopup() {
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
              content: Column(
                children: [
                  myText.custom(
                    "This feature is coming soon!",
                    fontColor: Colors.black,
                  ),
                  const SizedBox(height: 10),
                  myText.custom(
                    "Stay Tuned!",
                    fontColor: Colors.black,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
