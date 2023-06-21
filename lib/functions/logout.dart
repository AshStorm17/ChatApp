import 'package:chat_app/authentication/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future logOut(BuildContext context) async {
  FirebaseAuth auth = FirebaseAuth.instance;

  try {
    await auth.signOut().then((value) {
      Navigator.pushNamedAndRemoveUntil(
          context, LoginScreen.routeName, (route) => false);
    });
  } catch (e) {
    print("error");
  }
}
