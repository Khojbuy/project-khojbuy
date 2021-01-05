import 'package:Khojbuy/Constants/colour.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.shortestSide;
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
              return userCard(
                  snapshot.data["Name"],
                  snapshot.data["Contact"].toString().substring(3),
                  snapshot.data["City"],
                  width);
            },
          ),
        ],
      )),
    );
  }

  userCard(String name, String phnNo, String city, var width) {
    return Container(
      margin: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: primaryColour,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 2.0,
          ),
        ],
      ),
      height: width * 0.3,
      child: ListTile(
        contentPadding: EdgeInsets.only(
          left: width * 0.05,
          right: width * 0.1,
          //top: width * 0.05,
          //bottom: width * 0.05
        ),
        enabled: true,
        dense: true,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  color: primaryColour,
                  fontSize: width * 0.08),
            ),
            Text(
              phnNo,
              style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  color: primaryColour.withOpacity(0.8),
                  fontSize: width * 0.05),
            ),
            /*  Text(
                          city,
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.bold,
                              color: primaryColour.withOpacity(0.8),
                              fontSize: width * 0.05),
                        ) */
          ],
        ),
        leading: Icon(
          Icons.person,
          size: width * 0.2,
          color: secondaryColour,
        ),
      ),
    );
  }
}
