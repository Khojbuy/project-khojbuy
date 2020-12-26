import 'package:Khojbuy/Pages/Homepages/home.dart';
import 'package:Khojbuy/Pages/Initials/get_started.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  handleAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Home();
          } else {
            return GetStartedPage();
          }
        });
  }

  signOut(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GetStartedPage()),
    );
  }

  signInSeller(
    AuthCredential authCredential,
    BuildContext context,
  ) async {
    FirebaseAuth.instance.signInWithCredential(authCredential).then((value) {
      FirebaseFirestore.instance
          .collection("BuyerData")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .get()
          .then((doc) {
        if (doc.exists) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GetStartedPage()),
          );
        }
      });
    });
  }

  signInwithOTPSeller(String smsCode, String verId, BuildContext context) {
    AuthCredential authCredential =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: smsCode);
    signInSeller(authCredential, context);
  }
}
