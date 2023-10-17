import 'package:firebase_auth_utility/firebase_auth_utility.dart';
import 'package:flutter/material.dart';

class EmailSignupScreen extends StatefulWidget {
  const EmailSignupScreen({Key? key}) : super(key: key);

  @override
  State<EmailSignupScreen> createState() => _EmailSignupScreenState();
}

class _EmailSignupScreenState extends State<EmailSignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Email Signup Auth')),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                textCapitalization: TextCapitalization.none,
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Colors.grey.shade400)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Colors.grey.shade400)),
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: "EmailId"),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _passwordController,
                textCapitalization: TextCapitalization.none,
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Colors.grey.shade400)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Colors.grey.shade400)),
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: "Password"),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (_emailController.text.toString().isNotEmpty &&
                        _passwordController.text.toString().isNotEmpty) {
                      var credential = await FirebaseAuthUtil()
                          .createUserByEmail(
                              emailId: _emailController.text.toString(),
                              password: _passwordController.text.toString());
                      if (credential.toString().isNotEmpty) {
                        print('Success ${credential!.user!.uid}');
                      }
                    } else {
                      print('all fields are mandatory.');
                    }
                  },
                  child: const Text('SignIn')),
            ],
          ),
        ),
      ),
    );
  }
}
