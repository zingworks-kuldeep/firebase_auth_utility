import 'package:example/auth_dashboard/email_login_auth/email_login_screen.dart';
import 'package:example/auth_dashboard/email_signup_auth/email_signup_screen.dart';
import 'package:example/auth_dashboard/google_auth/google_auth_screen.dart';
import 'package:example/auth_dashboard/phone_auth/bloc/phone_auth_bloc.dart';
import 'package:example/auth_dashboard/phone_auth/phone_auth.dart';
import 'package:example/auth_dashboard/phone_auth/repository/phone_auth_repo.dart';
import 'package:firebase_auth_utility/firebase_auth_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthDashboardScreen extends StatelessWidget {
  const AuthDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Auth Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                  title: const Text('Phone'),
                  trailing:
                      const Icon(Icons.arrow_forward_ios, color: Colors.green),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BlocProvider(
                                create: (context) => LoginBloc(
                                  loginRepository: LoginRepositoryImpl(),
                                ),
                                child: const PhoneAuthScreen(),
                              )))),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                  title: const Text('Google'),
                  trailing:
                      const Icon(Icons.arrow_forward_ios, color: Colors.green),
                  onTap: () async {
                    final userCredential =
                        await FirebaseAuthUtil().signInWithGoogle();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GoogleAuthScreen(
                                userCredential: userCredential)));
                  }),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                  title: const Text('Email/ Password SignUp'),
                  trailing:
                      const Icon(Icons.arrow_forward_ios, color: Colors.green),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EmailSignupScreen()))),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                  title: const Text('Email/ Password Login'),
                  trailing:
                      const Icon(Icons.arrow_forward_ios, color: Colors.green),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EmailLoginScreen()))),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                  title: const Text('Meta Login'),
                  trailing:
                      const Icon(Icons.arrow_forward_ios, color: Colors.green),
                  onTap: () {
                    //.FirebaseAuthUtil().signInWithMeta();
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => const EmailLoginScreen()));
                  }),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                  title: const Text('Apple Login/ Signup'),
                  trailing:
                      const Icon(Icons.arrow_forward_ios, color: Colors.green),
                  onTap: () async {
                    final userCredential =
                        await FirebaseAuthUtil().signInWithApple();
                    if (userCredential.toString().isNotEmpty) {
                      print(userCredential);
                    }
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => GoogleAuthScreen(
                    //             userCredential: userCredential)));
                  }),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                  title: const Text('Microsoft Login'),
                  trailing:
                      const Icon(Icons.arrow_forward_ios, color: Colors.green),
                  onTap: () async {
                    final userCredential =
                        await FirebaseAuthUtil().signInWithMicrosoft();
                    if (userCredential.toString().isNotEmpty) {
                      print(userCredential);
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
