import 'package:flutter/material.dart';
import 'common.dart';
import 'db-conn.dart';
import 'homepage.dart';
import 'signUp.dart';

import 'model.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String errorMessage = '';
  double errorBoxSpacing = 0;
  // late Future<List<User>> allUsers;
  // Future<List<User>>? _data1;
  // Future<List<User>> get data1 async {
  //   _data1 = readAllUsers();
  //   return _data1!;
  // }

  @override
  void initState() {
    super.initState();
    // allUsers = readAllUsers();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/circuit.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              // height: MediaQuery.of(context).size.height / 2,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              margin: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 2, color: Colors.white),
              ),
              child: Column(
                children: [
                  myText.custom("Login", letterSpace: 5, fontSize: 40),
                  const SizedBox(height: 15),
                  // error message box
                  myText.custom(
                    errorMessage,
                    fontSize: 12,
                    fontColor: Colors.orange,
                  ),
                  SizedBox(height: errorBoxSpacing),
                  myTextField(
                    label: "Username",
                    controller: usernameController,
                    hintText: "Enter your username",
                  ),
                  const SizedBox(height: 15),
                  myTextField(
                    label: "Password",
                    controller: passwordController,
                    hintText: "Enter your password",
                    obscureText: true,
                  ),
                  const SizedBox(height: 15),
                  myText.custom("New here?", fontSize: 15),
                  const SizedBox(height: 5),
                  InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUp()),
                          (route) => false);
                    },
                    child: myText.custom("Sign Up!", fontSize: 15),
                  ),
                  const SizedBox(height: 25),
                  TextButton(
                    style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Colors.pink,
                        side:
                            const BorderSide(width: 2.0, color: Colors.white)),
                    onPressed: () async {
                      errorMessage = await validateCredentials(
                          usernameController.text, passwordController.text);

                      // var dbHelper = SQLHelper();
                      // var allData = await dbHelper.readAllUsers();
                      // for (var u in allData) {
                      //   print(
                      //       "Username: ${u.username} & Password: ${u.password}");
                      // }
                      print(
                          "Error message: $errorMessage --!! && ${errorMessage.isNotEmpty}");
                      if (errorMessage.isNotEmpty) {
                        errorBoxSpacing = 20;
                        setState(() {});
                      } else {
                        errorMessage = "";
                        errorBoxSpacing = 0;

                        var dbHelper = SQLHelper();
                        var allUsers = await dbHelper.readAllUsers();
                        for (var anyUser in allUsers) {
                          if (anyUser.username == usernameController.text) {
                            await dbHelper.updateLoggedInState(
                                newValue: "YES", userID: anyUser.userID!);
                          } else {
                            await dbHelper.updateLoggedInState(
                                newValue: "NO", userID: anyUser.userID!);
                          }
                        }

                        // ignore: use_build_context_synchronously
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage(
                                      username: usernameController.text,
                                    )),
                            (route) => false);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 15),
                      child: myText.custom("Let Me In!", letterSpace: 5),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String> validateCredentials(String username, String password) async {
    String warning = "";
    if (username.isEmpty || password.isEmpty) {
      warning = "All fields are mandatory!";
      return warning;
    } else {
      //
      // The below line is how you will be accessing the fucking data!
      //
      var dbHelper = SQLHelper();
      List<User> allItems = await dbHelper.readAllUsers();
      print("Length: ${allItems.length}");
      if (allItems.length > 0) {
        for (var element in allItems) {
          if (username == element.username && password == element.password) {
            warning = "";
            break;
          } else {
            warning = "Invalid Credentials! If you're new, try signing up!";
          }
        }
      } else {
        warning = "Invalid Credentials! If you're new, try signing up!";
      }

      return warning;
    }
  }

  Future<List<Password>> getAllPasswords(String username) async {
    var dbHelper = SQLHelper();
    List<Password> allDataOfThisUser =
        await dbHelper.readPasswordsByUsername(username);
    return allDataOfThisUser;
  }

  // Future<List<User>> readAllUsers() async {

  //   return allItems;
  // }
}
