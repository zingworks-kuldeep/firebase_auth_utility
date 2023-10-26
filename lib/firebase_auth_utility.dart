library firebase_auth_utility;

import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_utility/local_notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthUtil {
  /// Initialize the firebase project.
  /// Provide the Firebase_Option
  initializeApp({required options}) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: options,
    );
  }

  /// Phone authentication by phone number
  phoneAuthLogin(
      {required String countryCode,
      required String mobileNumber,
      required Duration? timeout,
      required Function(FirebaseAuthException e) verificationFailed,
      required Function(Map responseData) codeSent}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    int? resendToken;
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: "+$countryCode${mobileNumber.toString()}",
        timeout: timeout ?? const Duration(seconds: 120),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) => verificationFailed(e),
        codeSent: (String verificationId, int? resendToken) {
          Map responseData = {};
          responseData['verificationId'] = verificationId;
          responseData['resendToken'] = resendToken;
          codeSent(responseData);
        },
        forceResendingToken: resendToken,
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on Exception catch (e) {
      return e.toString();
    }
  }

  /// Verify firebase auth otp
  Future<dynamic> verifyFirebaseAuthOtp({required requestData}) {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: requestData['verificationId'],
        smsCode: requestData['otp']);

    return signInWithPhone(credential, requestData);
  }

  /// Sign In with phone
  Future<dynamic> signInWithPhone(
      PhoneAuthCredential credential, requestData) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        return userCredential;
      } else {
        return null;
      }
    } on FirebaseAuthException catch (e) {
      return e.toString();
    }
  }

  /// Sign In with google
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

  /// Google logout if logged in
  Future<bool> signOutFromGoogle() async {
    if (await GoogleSignIn().isSignedIn()) {
      await GoogleSignIn().signOut();
      return true;
    }
    return true;
  }

  /// Firebase Logout if logged in
  signOutFromFirebase() async {
    await FirebaseAuth.instance.signOut();
  }

  /// Login with Email
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
      return e.toString();
    }
    return '';
  }

  /// Sign In with email
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

  /// Sign In with apple
  signInWithApple() async {
    if (Platform.isIOS) {
      try {
        final appleProvider = AppleAuthProvider();
        return await FirebaseAuth.instance.signInWithProvider(appleProvider);
      } on Exception catch (e) {
        return 'error in apple login -> $e';
      }
    }
  }

  /// Login with Microsoft
  signInWithMicrosoft() async {
    final MicrosoftAuthProvider microsoftProvider = MicrosoftAuthProvider();
    microsoftProvider.addScope("openid");
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithProvider(microsoftProvider);
      return userCredential;
    } on FirebaseAuthException catch (exception) {
      debugPrint("exception->${exception.message}");
      return exception.toString();
    }
  }

  /// Push Notification
  registerNotification() async {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
        alert: true, badge: true, provisional: false, sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      LocalNotificationService().init((String? payload) {});

      FirebaseMessaging.instance.getToken().then((token) {});

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;

        String? payload = json.encode(message.data);
        LocalNotificationService().showNotification(notification.hashCode,
            notification!.title, notification.body, payload);
      });
    } else {
      // print('User declined or has not accepted permission');
    }

    // Background notification handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}
