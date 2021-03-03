import 'package:Khojbuy/Constants/colour.dart';
import 'package:Khojbuy/Pages/Initials/get_started.dart';
import 'package:Khojbuy/Pages/RequestPages/request_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

requestList(BuildContext context) {
  return FirebaseAuth.instance.currentUser == null
      ? Center(
          child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: 'To send requests to all the sellers, ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'OpenSans',
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GetStartedPage()));
                          },
                        text: 'SIGN IN',
                        style: TextStyle(
                          color: primaryColour,
                          fontSize: 14,
                          fontFamily: 'OpenSans',
                        )),
                  ])))
      : StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Request')
              .where('Customer',
                  isEqualTo: FirebaseAuth.instance.currentUser.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData ||
                snapshot.data.documents.toString() == "[]") {
              print(snapshot.data.toString());
              return Center(
                child: Text(
                  "You have no requests in any category",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              );
            }
            return SingleChildScrollView(
              child: Column(
                  children: snapshot.data.documents.map<Widget>((doc) {
                var fontSize = MediaQuery.of(context).size.shortestSide * 0.069;
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RequestDetail(doc)),
                    );
                  },
                  child: Card(
                    margin: new EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 6.0),
                    elevation: 20,
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      title: Text(doc['Item'],
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 14)),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            doc['Category'],
                            style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                                fontSize: 12),
                          ),
                          (doc['Status'] == 'completed')
                              ? Text(
                                  doc['Status'],
                                  style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.w500,
                                      color: primaryColour,
                                      fontSize: fontSize * 0.55),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList()),
            );
          });
}
