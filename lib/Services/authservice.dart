import 'package:Khojbuy/Pages/Controlpage/home.dart';
import 'package:Khojbuy/Pages/Initials/get_started.dart';
import 'package:Khojbuy/Services/userinfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  handleAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserInformation().init();
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

  signInSeller(AuthCredential authCredential, BuildContext context, String name,
      String city, String phnNo) async {
    FirebaseAuth.instance.signInWithCredential(authCredential).then((value) {
      FirebaseFirestore.instance
          .collection('BuyerData')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .set({
        'Name': name,
        'City': city,
        'Contact': phnNo,
      }).then((value) {
        print(name + 'added');
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    });
  }

  signInwithOTPSeller(String smsCode, String verId, BuildContext context,
      String name, String city, String phnNo) {
    AuthCredential authCredential =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: smsCode);
    signInSeller(authCredential, context, name, city, phnNo);
  }
}
