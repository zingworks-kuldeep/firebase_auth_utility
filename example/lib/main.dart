import 'package:firebase_auth_utility/firebase_auth_utility.dart';
import 'package:flutter/material.dart';

void main() async {
  await FirebaseAuthUtil()
      .initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  /// Default Constructor
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(controller: _phoneController),
          ElevatedButton(
              child: const Text('Get OTP'),
              onPressed: () => FirebaseAuthUtil().phoneAuthLogin(
                  countryCode: "91",
                  mobileNumber: _phoneController.text.toString(),
                  codeSent: (responseData) {},
                  verificationFailed: (e) {}))
        ],
      ),
    );
  }
}
