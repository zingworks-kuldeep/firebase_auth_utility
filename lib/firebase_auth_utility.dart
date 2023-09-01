library firebase_auth_utility;

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_utility/local_notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthUtil {
  initializeApp({required options}) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: options,
    );
  }

  phoneAuthLogin(
      {required String mobileNumber,
      required verificationFailed(e),
      required codeSent(responseData)}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      if (mobileNumber.length == 10) {
        await auth.verifyPhoneNumber(
          phoneNumber: "+91${mobileNumber.toString()}",
          timeout: const Duration(seconds: 120),
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential);
          },
          verificationFailed: (FirebaseAuthException e) =>
              verificationFailed(e),
          codeSent: (String verificationId, int? resendToken) {
            Map responseData = {};
            responseData['verificationId'] = verificationId;
            responseData['resendToken'] = resendToken;
            codeSent(responseData);
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      }
    } on Exception catch (_) {}
  }

  Future<Map?> verifyFirebaseAuthOtp({required requestData}) {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: requestData['verificationId'],
        smsCode: requestData['otp']);

    return signInWithPhone(credential, requestData);
  }

  Future<Map?> signInWithPhone(
      PhoneAuthCredential credential, requestData) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        return {
          "studentId": userCredential.user!.uid,
          "mobileNo": requestData['mobileNo']
        };
      } else {
        return null;
      }
    } on FirebaseAuthException catch (_) {
      return null;
    }
  }

  // Google signin
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // Google logout if logged in
  Future<bool> signOutFromGoogle() async {
    if (await GoogleSignIn().isSignedIn()) {
      await GoogleSignIn().signOut();
      return true;
    }
    return true;
  }

  // Firebase Logout if logged in
  signOutFromFirebase() async {
    await FirebaseAuth.instance.signOut();
  }

  createUserByEmail({required String emailId, required String password}) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailId,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
        // print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
        // print('The account already exists for that email.');
      }
    } catch (e) {
      // print(e);
    }
    return '';
  }

  signInUserByEmail({required String emailId, required String password}) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailId,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
    } catch (e) {
      return 'error in sign In User By Email -> $e';
    }
    return '';
  }

  // // SignIn With Meta
  // Future<UserCredential> signInWithMeta() async {
  //   final LoginResult loginResult = await FacebookAuth.instance
  //       .login(permissions: ['email', 'public_profile', 'user_birthday']);
  //
  //   // Create a credential from the access token
  //   final OAuthCredential facebookAuthCredential =
  //       FacebookAuthProvider.credential(loginResult.accessToken!.token);
  //
  //   // Once signed in, return the UserCredential
  //   return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  // }

  // SignIn with Apple
  signInWithApple() async {
    try {
      final appleProvider = AppleAuthProvider();
      return await FirebaseAuth.instance.signInWithProvider(appleProvider);
    } on Exception catch (e) {
      return 'error in apple login -> $e';
    }
  }

  // Login with Microsoft
  signInWithMicrosoft() async {
    final MicrosoftAuthProvider microsoftProvider = MicrosoftAuthProvider();
    microsoftProvider.addScope("openid");
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithProvider(microsoftProvider);
      return userCredential;
    } on FirebaseAuthException catch (exception) {
      debugPrint("exception->${exception.message}");
    }
    return '';
  }

  // Push Notification
  registerNotification() async {
    final FirebaseMessaging _messaging = await FirebaseMessaging.instance;

    NotificationSettings settings = await _messaging.requestPermission(
        alert: true, badge: true, provisional: false, sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      LocalNotificationService().init((String? payload) {
        // if (payload != null) {
        //   Map data = json.decode(payload);
        //   // NotificationNavigation().notificationTapped(data);
        // }
      });

      FirebaseMessaging.instance.getToken().then((token) {
        print("Token android:$token");
      });

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;

        String? payload = json.encode(message.data);
        LocalNotificationService().showNotification(notification.hashCode,
            notification!.title, notification.body, payload);
      });
    } else {
      print('User declined or has not accepted permission');
    }

    // Background notification handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}
