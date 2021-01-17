import 'package:Khojbuy/Pages/RequestPages/request_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

requestList(BuildContext context) {
  return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Request')
          .where('Customer', isEqualTo: FirebaseAuth.instance.currentUser.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data.documents.toString() == "[]") {
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
                  MaterialPageRoute(builder: (context) => RequestDetail(doc)),
                );
              },
              child: Card(
                margin:
                    new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                elevation: 20,
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  title: Text(doc['Item'],
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: fontSize * 0.65)),
                  subtitle: Text(
                    doc['Category'],
                    style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                        fontSize: fontSize * 0.55),
                  ),
                ),
              ),
            );
          }).toList()),
        );
      });
}
