import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  User get user => _auth.currentUser!;

  Future<bool> signInWithGoogle() async {
    bool result = false;
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      UserCredential userCredential =
      await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        if (userCredential.additionalUserInfo!.isNewUser) {
          // add the data to fire base
          print('New user');
          // await _firestore.collection('users').doc(user.uid).set(
          //     {
          //       'fullName' : user.displayName,
          //       'user_id' : user.uid,
          //       'email':user.email,
          //       'login_method':'Google',
          //
          //     }
          //
          // );
        }
        result = true;
      }
      return result;

    } catch (e) {
      print(e);
    }
    return result;

  }
  void signOut() async {
    try {
      _auth.signOut();
      GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.disconnect();
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('can not signOut as : $e');
    }
  }

}

