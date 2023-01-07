import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'manual.dart';
import 'profile.dart';
import 'help.dart';
import 'login.dart';
import 'root.dart';
import 'signUp.dart';
import 'homepage.dart';

void main() {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (kReleaseMode) exit(1);
  };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Root(),
    );
  }
}
