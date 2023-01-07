import 'package:flutter/material.dart';
import 'package:pkeep/common.dart';

class UserManual extends StatefulWidget {
  const UserManual({super.key});

  @override
  State<UserManual> createState() => _UserManualState();
}

class _UserManualState extends State<UserManual> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 50, 15, 20),
          child: Column(
            children: [
              // Rules of Usage
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 56, 136, 173),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 2,
                    color: Colors.white,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    myText.custom(
                      "Rules of Usage 📖",
                      fontWeight: FontWeight.bold,
                      letterSpace: 2,
                      fontSize: 20,
                    ),
                    const Divider(
                      height: 25,
                      thickness: 1,
                      color: Colors.white,
                    ),
                    myText.custom(
                      '''• Tap the add button in the bottom center to add a password for a specific platform.
                    \n• You can edit your credentials by tapping on the corresponding tile.
                    \n• Long press a tile to delete the specific credentials from the record. This will require you to enter your account password for the app.
                    \n• You have access to more tools from the app drawer, accessible from the icon in the top right corner.''',
                      letterSpace: 1,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Different Features
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(
                  color: const Color(0xff0a837f),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 2,
                    color: Colors.white,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    myText.custom(
                      "Different Features ❔",
                      fontWeight: FontWeight.bold,
                      letterSpace: 2,
                      fontSize: 20,
                    ),
                    const Divider(
                      height: 25,
                      thickness: 1,
                      color: Colors.white,
                    ),
                    myText.custom(
                      '''• This app will help you manage all the dozens of passwords for different websites, apps, and basically anything else!
                    \n• Your passwords are secure with us. They never even leave your device!
                    \n• We encrypt your password before saving them and decrypt them only when you use the app. NEVER ELSE!
                    ''',
                      letterSpace: 1,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Tips
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 148, 137, 207),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 2,
                    color: Colors.white,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    myText.custom(
                      "Tips 💡",
                      fontWeight: FontWeight.bold,
                      letterSpace: 2,
                      fontSize: 20,
                    ),
                    const Divider(
                      height: 25,
                      thickness: 1,
                      color: Colors.white,
                    ),
                    myText.custom(
                      '''• Always use strong passwords. Include random alphabets, numbers, symbols. Afraid of forgetting them? That's what we are here for!
                    \n• The app drawer is the doorway to different dimensions within the app. Make sure you do not miss out!
                    \n• Check out the updates section below and keep an eye out for more security features!
                    \n• It should go without saying that avoid saving your bank account details with us. Just a precaution to avoid any loss in the highly unlikely chance of data breach.''',
                      letterSpace: 1,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Still have questions
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(
                  color: const Color(0xfff88863),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 2,
                    color: Colors.white,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    myText.custom(
                      "Still Have A Questions?",
                      fontWeight: FontWeight.bold,
                      letterSpace: 2,
                      fontSize: 20,
                    ),
                    const Divider(
                      height: 25,
                      thickness: 1,
                      color: Colors.white,
                    ),
                    myText.custom("Contact us at:"),
                    const SizedBox(height: 10),
                    Socials(iconHeight: 25),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Updates
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 207, 87, 66),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 2,
                    color: Colors.white,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    myText.custom(
                      "Upcoming Updates",
                      fontWeight: FontWeight.bold,
                      letterSpace: 2,
                      fontSize: 20,
                    ),
                    const Divider(
                      height: 25,
                      thickness: 1,
                      color: Colors.white,
                    ),
                    myText.custom(
                      '''• We are constantly working on strong encryption algorithms!
                    \n• You will soon be able to back-up all your data with your Google account. Securely, of course! You would then be able to access it on any device!
                    \n• Random password generator! You wouldn't have to worry about being creative each time you set up an account anywhere.
                    \n• Did you accidentally set a weak password for this app? Don't worry, you will soon be able to change it!''',
                      letterSpace: 1,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
