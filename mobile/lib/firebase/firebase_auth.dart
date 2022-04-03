// Check auth state of Firebase
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

import '../helpers/toast_controller.dart';

Future<bool> checkAuth() async {
  try {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      showToast("Signed in successfully");
      return true;
    } else {
      showToast("Signed out successfully");
      return false;
    }
  } catch (e) {
    showToast(e.toString());
  }
  return false;
}

// Sign up with given email and password
Future<void> signUp(email, password) async {
  try {
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  } on FirebaseAuthException catch (e) {
    log(e.toString());
    if(e.code == 'email-already-in-use') {
      showToast("The email address is already in use by another account.");
    }
  }
}

// Sign in with given email and password
Future<void> signIn(email, password) async {
  try {
    UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  } on FirebaseAuthException catch (e) {
    log(e.toString());
    if(e.code == 'user-not-found') {
      showToast("User is not found, please sign-up first");
    }

  }
}

// Sign out from Firebase
Future<void> signOut() async {
  try {
    FirebaseAuth.instance.signOut();
  } catch (e) {
    showToast(e.toString());
  }
}
