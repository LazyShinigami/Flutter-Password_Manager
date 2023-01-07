// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pkeep/db-conn.dart';
import 'package:pkeep/homepage.dart';
import 'package:pkeep/model.dart';
import 'common.dart';

import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();
  double errorBoxSpacing = 0;
  String errorMessage = '';

  @override
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
                  myText.custom("Sign Up", letterSpace: 5, fontSize: 40),
                  const SizedBox(height: 15),
                  // error message box
                  myText.custom(
                    errorMessage,
                    fontSize: 12,
                    fontColor: Colors.orange,
                  ),
                  SizedBox(height: errorBoxSpacing),

                  // name input
                  myTextField(
                    label: "Name",
                    controller: nameController,
                    hintText: "What is your name?",
                  ),
                  const SizedBox(height: 15),

                  // username input
                  myTextField(
                    label: "Username",
                    controller: usernameController,
                    hintText: "What should we call you?",
                  ),
                  const SizedBox(height: 15),

                  // email input
                  myTextField(
                    label: "E-mail",
                    controller: emailController,
                    hintText: "Enter an e-mail",
                  ),
                  const SizedBox(height: 15),

                  // password input
                  myTextField(
                    label: "Password",
                    controller: passwordController,
                    hintText: "Enter a strong password",
                    obscureText: true,
                  ),
                  const SizedBox(height: 15),

                  // re-password input
                  myTextField(
                    label: "Confirm Password",
                    controller: rePasswordController,
                    hintText: "Re-enter your password",
                    obscureText: true,
                  ),
                  const SizedBox(height: 15),

                  myText.custom("Do we already know you?", fontSize: 15),
                  const SizedBox(height: 5),
                  InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()),
                          (route) => false);
                    },
                    child: myText.custom("Log in!", fontSize: 15),
                  ),
                  const SizedBox(height: 25),

                  // Register button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Colors.pink,
                        side:
                            const BorderSide(width: 2.0, color: Colors.white)),
                    onPressed: () async {
                      String validated = await validateAll(
                        nameController.text,
                        usernameController.text,
                        emailController.text,
                        passwordController.text,
                        rePasswordController.text,
                      );

                      if (validated.isNotEmpty) {
                        errorBoxSpacing = 20;
                        errorMessage = validated;
                        setState(() {});
                      } else {
                        var dbHelper = SQLHelper();
                        var allUsers = await dbHelper.readAllUsers();
                        int userID = (allUsers.isNotEmpty)
                            ? allUsers[allUsers.length - 1].userID! + 1
                            : 101;
                        User user = User(
                            userID: userID,
                            name: nameController.text,
                            username: usernameController.text,
                            email: emailController.text,
                            password: passwordController.text,
                            loggedIn: "YES");
                        // logging out all other users
                        for (User anyUser in allUsers) {
                          await dbHelper.updateLoggedInState(
                              newValue: "NO", userID: anyUser.userID!);
                        }
                        // creating out own user
                        await dbHelper.createUserEntry(user);
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
                          vertical: 15, horizontal: 15),
                      child: myText.custom("Sign Me Up!", letterSpace: 5),
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

  Future<String> validateAll(String name, String username, String email,
      String password, String rePassword) async {
    String flag = "";
    flag = validateName(name);
    if (flag.isEmpty) {
      flag = await validateUsername(username);
    }
    if (flag.isEmpty) {
      flag = validateEmail(email);
    }
    if (flag.isEmpty) {
      flag = validatePasssword(password);
    }
    if (flag.isEmpty) {
      flag = validateRePassword(password, rePassword);
    }

    return flag;
  }

  // valiation functions
  String validateName(String name) {
    String errorMessage = "";
    bool flag = false;
    if (name.isEmpty) {
      errorMessage = "Empty Name field!";
    } else if (name.contains(RegExp('[~`!@#%^&*()-+={}[]:;"<>,.?/]')) ||
        name.contains("_")) {
      errorMessage = "Name can only contain letters";
    } else {
      flag = true;
    }
    // setState(() {});
    return errorMessage;
  }

  Future<String> validateUsername(String username) async {
    bool flag = false;
    String errorMessage = "";
    if (username.isEmpty) {
      errorMessage = "Empty Username field!";
    } else if (username[0].contains(RegExp('[0123456789]'))) {
      errorMessage = "Username cannot begin with a number!";
    } else if (username.contains(' ')) {
      errorMessage = "Username cannot have spaces!";
    } else if (username.contains(RegExp('[!@#\$\\/.,{`}?<>:;"\'+%^&*()+~]'))) {
      errorMessage =
          "Username may only have alphanumeric characters and underscores!";
    } else if (username.length < 5) {
      errorMessage = "Username too short! [5-10]";
    } else if (username.length > 10) {
      errorMessage = "Username too long! [5-10]";
    } else {
      flag = true;
    }
    var dbHelper = SQLHelper();
    var allUsers = await dbHelper.readAllUsers();
    for (var user in allUsers) {
      if (user.username == username) {
        errorMessage = "Username taken!";
      }
    }

    // setState(() {});
    return errorMessage;
  }

  String validateEmail(String email) {
    bool flag = false;
    String errorMessage = "";
    if (email.isEmpty) {
      errorMessage = "Empty E-mail field!";
    } else if (!email.contains("@") || !email.contains(".")) {
      errorMessage = "Enter a valid E-mail!";
    } else if (email.contains(' ') ||
        email.contains(RegExp('[!#\$\\/,{}?<>:;"\'%^&*()~]'))) {
      errorMessage = "Invalid E-mail!";
    } else {
      flag = true;
    }
    // setState(() {});
    return errorMessage;
  }

  String validatePasssword(String password) {
    bool flag = false;
    String errorMessage = "";
    if (password.isEmpty) {
      errorMessage = "Empty Password field!";
    } else if (password.length < 8) {
      errorMessage = "Password too short!";
    } else {
      flag = true;
    }
    // setState(() {});
    return errorMessage;
  }

  String validateRePassword(String password, String rePassword) {
    bool flag = false;
    String errorMessage = "";
    if (rePassword.isEmpty) {
      errorMessage = "Empty Confirm Password field!";
    } else if (password != rePassword) {
      errorMessage = "Passwords do not match!";
    } else {
      flag = true;
    }
    // setState(() {});
    return errorMessage;
  }
}
