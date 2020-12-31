import 'package:Khojbuy/Constants/colour.dart';
import 'package:Khojbuy/Services/authservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('BuyerData')
                .doc(FirebaseAuth.instance.currentUser.uid)
                .get(),
            builder: (context, snapshot) {
              print(snapshot);
              if (snapshot.connectionState != ConnectionState.done) {
                return CircularProgressIndicator(
                  backgroundColor: fifthColour,
                );
              }
              return Column(
                children: [
                  Text(snapshot.data["Name"]),
                  Text(snapshot.data["Contact"].toString().substring(3)),
                  Text(snapshot.data["City"])
                ],
              );
            },
          )
        ],
      )),
    );
  }
}
