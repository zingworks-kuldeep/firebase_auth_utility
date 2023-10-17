import 'package:example/auth_dashboard_screen.dart';
import 'package:firebase_auth_utility/firebase_auth_utility.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  await FirebaseAuthUtil()
      .initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthDashboardScreen(),
    );
  }
}
