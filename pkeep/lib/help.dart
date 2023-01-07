import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pkeep/common.dart';

class Help extends StatefulWidget {
  const Help({super.key});

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  myText.custom(
                    "We're sorry you're having trouble!\nLet us try to help.",
                    fontColor: Colors.black,
                    letterSpace: 1,
                  ),
                  const Divider(
                    color: Colors.black,
                    thickness: 1,
                    height: 20,
                  ),
                  myText.custom(
                    "Contact the developer at:",
                    fontColor: Colors.black,
                  ),
                  const SizedBox(height: 10),
                  Socials(iconHeight: 25),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
