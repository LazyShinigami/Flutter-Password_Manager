import 'package:flutter/material.dart';
import 'package:pkeep/common.dart';
import 'package:pkeep/db-conn.dart';

import 'model.dart';

class Search extends StatefulWidget {
  String username;
  Search({required this.username, super.key});

  @override
  State<Search> createState() => _SearchState(username);
}

class _SearchState extends State<Search> {
  String username;
  _SearchState(this.username);
  final TextEditingController _clientNameController = TextEditingController();
  late Future<List<Password>> allData;
  @override
  void initState() {
    super.initState();
    allData = _getAllPasswords(username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 60, 15, 0),
          child: Container(
            // HAVE A LOOK
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                myText.custom(
                  "Looking for something specific?",
                  letterSpace: 2,
                ),
                const SizedBox(height: 15),
                myTextField(
                  label: "Platform Name",
                  controller: _clientNameController,
                  hintText: "Name of the paltform",
                ),
                const SizedBox(height: 10),
                TextButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () async {
                    print("-->" + username);
                    allData = _getAllPasswords(username);
                    setState(() {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 20,
                    ),
                    child: myText.custom("Search!"),
                  ),
                ),
                FutureBuilder(
                  future: allData,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Center(
                          child: myText.custom(
                            "Found nothing!",
                            fontColor: const Color.fromARGB(255, 255, 115, 0),
                            fontWeight: FontWeight.bold,
                            letterSpace: 2,
                          ),
                        );

                      case ConnectionState.waiting:
                        return Center(
                          child: myText.custom(
                            "Waiting...",
                            fontColor: const Color.fromARGB(255, 255, 115, 0),
                            fontWeight: FontWeight.bold,
                            letterSpace: 2,
                          ),
                        );

                      case ConnectionState.active:
                        return Center(
                          child: myText.custom(
                            "Active",
                            fontColor: const Color.fromARGB(255, 255, 115, 0),
                            fontWeight: FontWeight.bold,
                            letterSpace: 2,
                          ),
                        );
                      // return const Center(child: CircularProgressIndicator());

                      case ConnectionState.done:
                        if (snapshot.hasData) {
                          return Center(
                            child: myText.custom(
                              "DO IT!",
                              fontColor: const Color.fromARGB(255, 255, 115, 0),
                              fontWeight: FontWeight.bold,
                              letterSpace: 2,
                            ),
                          );
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<Password>> _getAllPasswords(username) async {
    var dbHelper = SQLHelper();
    List<Password> allItems = await dbHelper.readPasswordsByUsername(username);
    return allItems;
  }
}
