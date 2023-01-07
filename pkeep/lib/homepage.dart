// ignore_for_file: no_logic_in_create_state, non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'db-conn.dart';
import 'model.dart';
import 'common.dart';

var verifiedUser = false;

class HomePage extends StatefulWidget {
  // List<Password> allData;
  String username;
  // String userPassword;
  HomePage({required this.username, super.key});

  @override
  State<HomePage> createState() => _HomePageState(username);
}

class _HomePageState extends State<HomePage> {
  late Future<List<Password>> allData;
  int? totalRecords;
  Map allTiles = {};
  String username;
  bool validated = false;
  _HomePageState(this.username);
  int key = 0;
  String passwordPlaceHolder = "* * * * * *";
  String superPassword = "";

  // CONTROLLERS

  final TextEditingController _newClientNameController =
      TextEditingController();

  final TextEditingController _newClientUsernameController =
      TextEditingController();

  final TextEditingController _newClientPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    allData = getAllPasswords(username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // app bar
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: myText.custom(
          "Password Manager",
          fontSize: 20,
          letterSpace: 4,
        ),
        centerTitle: true,
        toolbarHeight: 75,
      ),

      // drawer
      endDrawer: MyDrawer(username: username),

      // body
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/circuit.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder(
          future: getAllPasswords(username),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());

              case ConnectionState.done:
                if (snapshot.hasData) {
                  totalRecords = snapshot.data!.length;

                  if (totalRecords! > 0) {
                    return GridView.count(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                      crossAxisCount: 2,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 13,
                      children: [
                        for (int i = 0; i < totalRecords!; i++)
                          _tileBuilder(snapshot.data![i])
                      ],
                    );
                  } else {
                    return Center(
                        child: myText.custom(
                      "No passwords yet!",
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpace: 3,
                    ));
                  }
                } else if (snapshot.hasError) {
                  return Center(
                    child: myText.custom(
                      "Oops! Something went wrong!\nRestart recommended!",
                      fontColor: const Color.fromARGB(255, 255, 115, 0),
                      fontWeight: FontWeight.bold,
                      letterSpace: 2,
                    ),
                  );
                } else {
                  return Center(
                    child: myText.custom(
                      "Oops! Something went wrong!\nRestart recommended!",
                      fontColor: const Color.fromARGB(255, 255, 115, 0),
                      fontWeight: FontWeight.bold,
                      letterSpace: 2,
                    ),
                  );
                }
            }
          },
        ),
        // child: Socials(iconHeight: 20),
      ),

      // bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () {
                setState(() {});
              },
              child: MyIcon(name: "home", height: 25),
            ),
            tooltip: "Home",
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () async {
                var allItems = await allData;
                totalRecords = allItems.length;
                setState(() {});
              },
              child: MyIcon(name: "refresh", height: 25),
            ),
            tooltip: "Refresh",
            label: "Refresh",
          )
        ],
      ),

      // floating action button
      floatingActionButton: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 3, color: Colors.white),
          borderRadius: BorderRadius.circular(50),
        ),
        child: FloatingActionButton(
          onPressed: () {
            _newClientNameController.clear();
            _newClientUsernameController.clear();
            _newClientPasswordController.clear();
            _addPasswordPopup();
          },
          backgroundColor: Colors.black,
          child: const Icon(
            Icons.add_rounded,
            size: 35,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _tileBuilder(Password password) {
    allTiles[password.pID] = password;
    return MyTile(
      password: password,
      pID: password.pID!,
      username: username,
    );
  }

  _addPasswordPopup() {
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: SingleChildScrollView(
            child: MyPopup(
              title: myText.custom(
                "Secure Your Credentials!",
                fontColor: Colors.black,
              ),
              children: [
                myTextField(
                  inputColor: Colors.black,
                  label: "Client name",
                  hintText: "Name of platform",
                  controller: _newClientNameController,
                ),
                const SizedBox(height: 10),
                myTextField(
                  inputColor: Colors.black,
                  label: "Client username",
                  hintText: "Username as registered",
                  controller: _newClientUsernameController,
                ),
                const SizedBox(height: 10),
                myTextField(
                  obscureText: true,
                  inputColor: Colors.black,
                  label: "Enter Password",
                  hintText: "Password for platform",
                  controller: _newClientPasswordController,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        int inserted = 0;
                        bool valid = _validateNewEntry(
                            _newClientNameController.text,
                            _newClientUsernameController.text,
                            _newClientPasswordController.text);
                        if (valid) {
                          var allItems = await getAllPasswords(username);
                          var dbHelper = SQLHelper();
                          var resultSet = await dbHelper.readAllPasswords();
                          int index = (resultSet.isNotEmpty)
                              ? resultSet[resultSet.length - 1].pID! + 1
                              : 3295;
                          var password = Password(
                            index,
                            username,
                            _newClientNameController.text,
                            _newClientUsernameController.text,
                            _newClientPasswordController.text,
                          );

                          inserted =
                              await dbHelper.createPasswordEntry(password);
                        }
                        if (inserted > 0) {
                          Navigator.pop(context);
                          setState(() {});
                        }
                      },
                      child: myText.custom(
                        "Add",
                        letterSpace: 3,
                        fontSize: 15,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: myText.custom(
                        "Cancel",
                        letterSpace: 3,
                        fontSize: 15,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String decrypt(password) {
    return password;
  }

  Future<List<Password>> getAllPasswords(String username) async {
    var dbHelper = SQLHelper();
    List<Password> allDataOfThisUser =
        await dbHelper.readPasswordsByUsername(username);
    return allDataOfThisUser;
  }

  bool _validateNewEntry(String cName, String cUsername, String cPassword) {
    if (cName.isEmpty || cUsername.isEmpty || cPassword.isEmpty) {
      return false;
    }
    return true;
  }

  _dummyPopup() {
    return AlertDialog(
      content: Text("DID IT WORK?"),
    );
  }
}

class MyTile extends StatefulWidget {
  Password password;
  int pID;
  String username;

  MyTile(
      {required this.password,
      required this.pID,
      required this.username,
      super.key});

  @override
  State<MyTile> createState() => _MyTileState(password, pID, username);
}

class _MyTileState extends State<MyTile> {
  Password password;
  int pID;
  String username;
  _MyTileState(this.password, this.pID, this.username);
  late Future<User> user;
  @override
  void initState() {
    super.initState();
    user = getUserDetails(username);
  }

  @override
  Widget build(BuildContext context) {
    String? cName, cUsername, cPassword;
    cName = password.clientName;
    cUsername = password.clientUsername;
    cPassword = password.clientPassword;
    return InkWell(
      onTap: () {
        _editPopup(context: context, pID: pID);
      },
      onLongPress: () {
        _askForPasswordPopup(
          pID: pID,
          choiceOfOperation: "delete",
          message: "Are you sure you want to delete?",
        );
      },
      child: Container(
        // key: Key("$key"),
        // key: UniqueKey(),
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(38, 255, 255, 255),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 2, color: Colors.white),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            myText.custom(
              cName,
              fontSize: 18,
              letterSpace: 3,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 2),
            const Divider(color: Colors.white, endIndent: 10, indent: 10),
            const SizedBox(height: 2),
            myText.custom(cUsername, fontSize: 15, letterSpace: 3),
            const SizedBox(height: 5),
            myText.custom(cPassword,
                fontSize: 15, letterSpace: 3, fontWeight: FontWeight.bold),
          ],
        ),
      ),
    );
  }

  _editPopup({required BuildContext context, required int pID}) {
    final TextEditingController _clientNameController = TextEditingController();
    final TextEditingController _clientUsernameController =
        TextEditingController();
    final TextEditingController _clientPasswordController =
        TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: SingleChildScrollView(
              child: MyPopup(
                title: myText.custom(
                  "Edit Credentials",
                  fontColor: Colors.black,
                  fontSize: 22,
                ),
                children: [
                  const SizedBox(height: 10),
                  myTextField(
                    inputColor: Colors.black,
                    label: "Client name",
                    hintText: "Name of platform",
                    controller: _clientNameController,
                  ),
                  const SizedBox(height: 10),
                  myTextField(
                    inputColor: Colors.black,
                    label: "Client username",
                    hintText: "Username as registered",
                    controller: _clientUsernameController,
                  ),
                  const SizedBox(height: 10),
                  myTextField(
                    obscureText: true,
                    inputColor: Colors.black,
                    label: "Enter Password",
                    hintText: "Password for platform",
                    controller: _clientPasswordController,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          var dbHelper = SQLHelper();

                          if (_clientNameController.text.isNotEmpty) {
                            await dbHelper.updatePassword_cName(
                                _clientNameController.text, pID);
                          }
                          if (_clientUsernameController.text.isNotEmpty) {
                            await dbHelper.updatePassword_cUsername(
                                _clientUsernameController.text, pID);
                          }
                          if (_clientPasswordController.text.isNotEmpty) {
                            await dbHelper.updatePassword_cPassword(
                                _clientPasswordController.text, pID);
                          }
                          // inserted =
                          //     await dbHelper.;

                          Navigator.pop(context);
                          setState(() {});
                        },
                        child: myText.custom(
                          "Edit",
                          letterSpace: 3,
                          fontSize: 15,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: myText.custom(
                          "Cancel",
                          letterSpace: 3,
                          fontSize: 15,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  _askForPasswordPopup(
      {required int pID, required String choiceOfOperation, String? message}) {
    final TextEditingController _userPasswordController =
        TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: SingleChildScrollView(
            child: MyPopup(
              title: myText.custom(
                "We need to confirm it's really you",
                fontColor: Colors.black,
                fontSize: 19,
              ),
              children: [
                myTextField(
                  obscureText: true,
                  inputColor: Colors.black,
                  label: "Enter Password",
                  hintText: "Enter your app password",
                  controller: _userPasswordController,
                ),
                const SizedBox(height: 5),
                if (message!.isNotEmpty)
                  myText.custom(message, fontColor: Colors.black),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    User user = await getUserDetails(username);
                    String superPassword = user.password!;

                    if (superPassword == _userPasswordController.text) {
                      switch (choiceOfOperation) {
                        case "delete":
                          var dbHelper = SQLHelper();
                          int deleted = await dbHelper.deletePasswordByID(pID);
                          if (deleted > 0) {
                            Navigator.pop(context);
                            setState(() {});
                          }
                          break;
                      }
                    }
                  },
                  child: myText.custom(
                    "Confirm",
                    letterSpace: 3,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<User> getUserDetails(username) async {
    User user = User();
    var dbHelper = SQLHelper();
    var users = await dbHelper.readAllUsers();
    for (User u in users) {
      if (u.username == username) {
        user = u;
      }
    }
    return user;
  }
}
