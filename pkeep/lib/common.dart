// ignore_for_file: no_logic_in_create_state, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pkeep/db-conn.dart';
import 'package:pkeep/homepage.dart';
import 'package:pkeep/manual.dart';
import 'package:pkeep/model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'help.dart';
import 'login.dart';
import 'profile.dart';
import 'search.dart';

//
// BACKGROUND CONTAINER
//
class BackgroundContainer extends StatefulWidget {
  Widget? child;
  BackgroundContainer({this.child, super.key});

  @override
  State<BackgroundContainer> createState() => _BackgroundContainerState(child!);
}

class _BackgroundContainerState extends State<BackgroundContainer> {
  Widget child;

  _BackgroundContainerState(this.child);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/circuit.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}

// class MyBoxDecoration extends StatefulWidget {
//   const MyBoxDecoration({super.key});
//   @override
//   State<MyBoxDecoration> createState() => _MyBoxDecorationState();
// }
// class _MyBoxDecorationState extends State<MyBoxDecoration> {
//   @override
//   Widget build(BuildContext context) {
//     return BoxDecoration();
//   }
// }

//
// TEXT
//
class myText extends StatelessWidget {
  myText({super.key});
  double? _fontSize;
  double? _letterSpace;
  Color? _fontColor;
  String? _content;
  FontWeight? _fontWeight = FontWeight.normal;

  myText.custom(this._content,
      {double? fontSize = 18,
      Color? fontColor = Colors.white,
      double? letterSpace = 0,
      FontWeight? fontWeight}) {
    _fontSize = fontSize;
    _fontColor = fontColor;
    _letterSpace = letterSpace;
    _fontWeight = fontWeight;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _content.toString(),
      style: TextStyle(
        color: _fontColor,
        fontSize: _fontSize,
        letterSpacing: _letterSpace,
        fontWeight: _fontWeight,
      ),
    );
  }
}

//
// TEXTFIELD
//
class myTextField extends StatefulWidget {
  String label;
  TextEditingController controller = TextEditingController();
  bool? obscureText = false;
  String? hintText;
  Color? inputColor;
  myTextField(
      {required this.label,
      required this.controller,
      this.hintText,
      this.obscureText,
      this.inputColor,
      super.key}) {
    inputColor ??= Colors.white;
    obscureText ??= false;
    hintText ??= "";
  }

  @override
  State<myTextField> createState() => _myTextFieldState(
      controller, label, hintText!, obscureText!, inputColor!);
}

class _myTextFieldState extends State<myTextField> {
  String label;
  TextEditingController _controller;
  String hintText;
  bool obscureText;
  Color inputColor;
  _myTextFieldState(this._controller, this.label, this.hintText,
      this.obscureText, this.inputColor);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      controller: _controller,
      style: TextStyle(
        fontSize: 20,
        color: inputColor,
        letterSpacing: 5,
      ),
      cursorColor: Colors.white,
      cursorHeight: 20,
      cursorRadius: const Radius.circular(15),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle:
            const TextStyle(color: Colors.grey, fontSize: 15, letterSpacing: 3),
        alignLabelWithHint: true,
        label: myText.custom(" $label ", letterSpace: 5, fontColor: inputColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}

//
// POPUP
//
class MyPopup extends StatefulWidget {
  List<Widget> children = [];
  myText title;
  MyPopup({required this.children, required this.title, super.key});

  @override
  State<MyPopup> createState() => _MyPopupState(children, title);
}

class _MyPopupState extends State<MyPopup> {
  List<Widget> children;
  myText title;
  @override
  _MyPopupState(this.children, this.title);

  Widget build(BuildContext context) {
    return Center(
      child: AlertDialog(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        title: title,
        content: Column(
          children: children,
        ),
      ),
    );
  }
}

//
// DRAWER
//
class MyDrawer extends StatefulWidget {
  String username;
  MyDrawer({required this.username, super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState(username);
}

class _MyDrawerState extends State<MyDrawer> {
  final TextEditingController _platformNameController = TextEditingController();
  String username;
  _MyDrawerState(this.username);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
      child: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            bottomLeft: Radius.circular(15),
          ),
        ),
        width: 275,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(30, 50, 10, 20),
          children: [
            // intro section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                myText.custom(
                  "Hi 👋",
                  fontColor: Colors.black,
                  fontSize: 25,
                ),
                const SizedBox(height: 5),
                myText.custom(
                  widget.username,
                  fontColor: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpace: 3,
                ),
                const SizedBox(height: 10),
                myText.custom("Good to have you here!",
                    fontColor: Colors.black, letterSpace: 2),
              ],
            ),

            // Divider
            const Divider(
                color: Colors.black,
                height: 40,
                thickness: 0.75,
                endIndent: 30),

            // profile option
            _drawerItemBuilder(
              title: "Profile",
              icon: MyIcon(
                name: "person",
                height: 20,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Profile(username: username),
                  ),
                );
              },
            ),

            // home option
            const SizedBox(height: 20),
            _drawerItemBuilder(
              title: "Home",
              icon: MyIcon(
                name: "home",
                height: 20,
              ),
              onTap: () async {
                List<Password> allData =
                    await _getAllPasswords(widget.username);
                String password = await _getUserPassword(widget.username);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(username: widget.username),
                    ),
                    (route) => false);
              },
            ),

            // search option
            // const SizedBox(height: 10),
            // _drawerItemBuilder(
            //   title: "Search",
            //   icon: MyIcon(
            //     name: "home",
            //     height: 20,
            //   ),
            //   onTap: () {
            //     Navigator.pushAndRemoveUntil(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => Search(
            //                 username: username,
            //               )),
            //       (route) => false,
            //     );
            //   },
            // ),

            // user manual option
            const SizedBox(height: 20),
            _drawerItemBuilder(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserManual(),
                    ));
              },
              icon: MyIcon(
                name: "book",
                height: 20,
              ),
              title: "User guide",
            ),

            // help option
            const SizedBox(height: 20),
            _drawerItemBuilder(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Help(),
                  ),
                );
              },
              title: "Help",
              icon: MyIcon(
                name: "help",
                height: 20,
              ),
            ),

            // log out option
            const SizedBox(height: 20),
            _drawerItemBuilder(
              onTap: () async {
                var dbHelper = SQLHelper();
                var users = await dbHelper.readAllUsers();
                for (User user in users) {
                  dbHelper.updateLoggedInState(
                      newValue: "NO", userID: user.userID!);
                }

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                    (route) => false);
              },
              title: "Logout",
              icon: MyIcon(
                name: "logout",
                height: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Password>> _getAllPasswords(username) async {
    var dbHelper = SQLHelper();
    List<Password> allData = await dbHelper.readPasswordsByUsername(username);
    return allData;
  }

  Future<String> _getUserPassword(username) async {
    var dbHelper = SQLHelper();
    List<User> allUsers = await dbHelper.readAllUsers();
    String password = "";
    for (User user in allUsers) {
      if (user.username == username) {
        password = user.password!;
        break;
      }
    }
    return password;
  }

  _drawerItemBuilder({Function()? onTap, MyIcon? icon, String? title}) {
    return InkWell(
      hoverColor: Colors.pink,
      onTap: onTap,
      child: Row(
        children: [
          icon!,
          const SizedBox(width: 10),
          myText.custom(
            title,
            fontColor: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpace: 5,
          ),
        ],
      ),
    );
  }
}

//
// Custom Icon
//
class MyIcon extends StatelessWidget {
  MyIcon({super.key, required this.height, this.color, required this.name});
  double height = 25;
  Color? color = Colors.black;
  String name;
  String home = "lib/icons/home.png";
  String book = "lib/icons/book.png";
  String email = "lib/icons/email.png";
  String help = "lib/icons/help.png";
  String instagram = "lib/icons/instagram.png";
  String linkedin = "lib/icons/linkedin.png";
  String logout = "lib/icons/logout.png";
  String options = "lib/icons/options.png";
  String person = "lib/icons/person.png";
  String refresh = "lib/icons/refresh.png";
  String swap = "lib/icons/swap.png";
  String delete = "lib/icons/delete.png";

  @override
  Widget build(BuildContext context) {
    switch (name) {
      case "home":
        name = home;
        break;
      case "book":
        name = book;
        break;
      case "delete":
        name = delete;
        break;
      case "email":
        name = email;
        break;
      case "help":
        name = help;
        break;
      case "instagram":
        name = instagram;
        break;
      case "linkedin":
        name = linkedin;
        break;
      case "logout":
        name = logout;
        break;
      case "options":
        name = options;
        break;
      case "person":
        name = person;
        break;
      case "refresh":
        name = refresh;
        break;
      case "swap":
        name = swap;
        break;
    }
    return Container(
      height: height,
      child: Image.asset(
        name,
        color: color,
      ),
    );
  }
}

//
// ATTEMPT AT AN APP BAR
//
class MyAppBar extends StatelessWidget {
  String title;
  MyAppBar({required this.title, super.key});

  @override
  AppBar build(BuildContext context) {
    return AppBar(
      // automaticallyImplyLeading: false,
      backgroundColor: Colors.black,
      title: myText.custom(
        title,
        fontSize: 25,
        letterSpace: 5,
      ),
      centerTitle: true,
      toolbarHeight: 75,
    );
  }
}

//
// Social Section
//
class Socials extends StatelessWidget {
  Socials({super.key, required this.iconHeight});

  double iconHeight;
  String linkedinURL =
      "https://www.linkedin.com/in/ritesh-kumar-482824239/?original_referer=";
  String instagramURL = "https://www.instagram.com/lazy_shinigami_/";

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        LinkedButton(
          choice: "instagram",
          preURL: instagramURL,
          icon: MyIcon(height: iconHeight, name: "instagram"),
        ),
        LinkedButton(
          choice: "email",
          icon: MyIcon(height: iconHeight, name: "email"),
        ),
        LinkedButton(
          choice: "linkedin",
          preURL: linkedinURL,
          icon: MyIcon(height: iconHeight, name: "linkedin"),
        )
      ],
    );
  }
}

class LinkedButton extends StatelessWidget {
  LinkedButton(
      {this.preURL, required this.icon, super.key, required this.choice});

  String? preURL;
  String
      choice; // possible values for choice variable: email, linkedin, instagram
  Uri url = Uri();

  MyIcon icon;
  LaunchMode launchMode = LaunchMode.externalApplication;
  @override
  Widget build(BuildContext context) {
    switch (choice) {
      case "email":
        url = Uri(
          scheme: 'mailto',
          queryParameters: {'subject': 'PKeep'},
          path: 'ritesh.kumar.07.20@gmail.com',
        );
        break;
      case "linkedin":
        url = Uri.parse(preURL!);
        break;
      case "instagram":
        url = Uri.parse(preURL!);
        break;
    }
    return InkWell(
      onTap: () {
        _launch(url.toString());
      },
      child: icon,
    );
  }

  Future<void> _launch(String url) async {
    try {
      await launchUrlString(
        url,
        mode: launchMode,
      );
    } catch (e) {
      print(e);
    }
  }
}
