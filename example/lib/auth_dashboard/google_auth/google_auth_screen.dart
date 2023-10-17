import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_utility/firebase_auth_utility.dart';
import 'package:flutter/material.dart';

class GoogleAuthScreen extends StatefulWidget {
  final UserCredential userCredential;
  const GoogleAuthScreen({Key? key, required this.userCredential})
      : super(key: key);

  @override
  State<GoogleAuthScreen> createState() => _GoogleAuthScreenState();
}

class _GoogleAuthScreenState extends State<GoogleAuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Auth Dashboard')),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 1.5, color: Colors.black54)),
              child: Image.network(
                  widget.userCredential.user!.photoURL.toString()),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(widget.userCredential.user!.displayName.toString()),
            const SizedBox(
              height: 20,
            ),
            Text(widget.userCredential.user!.email.toString()),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () async {
                  bool result = await FirebaseAuthUtil().signOutFromGoogle();
                  if (result) Navigator.pop(context);
                },
                child: const Text('Logout'))
          ],
        ),
      ),
    );
  }
}
