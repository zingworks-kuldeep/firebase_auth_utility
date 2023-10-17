import 'package:firebase_auth/firebase_auth.dart';

abstract class LoginRepository {
  Future<Map?> verifyFirebaseAuthOtp(requestData);
}

class LoginRepositoryImpl implements LoginRepository {
  @override
  Future<Map?> verifyFirebaseAuthOtp(requestData) {
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
    } on FirebaseAuthException catch (e) {
      return null;
    }
  }
}
