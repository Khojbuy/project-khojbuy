import 'package:Khojbuy/Constants/colour.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

orderToConfirm(BuildContext context) {
  return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Order')
          .where('Customer', isEqualTo: FirebaseAuth.instance.currentUser.uid)
          //.orderBy('Time', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data.documents.toString() == "[]") {
          print(snapshot.data.toString());
          return Center(
            child: Text(
              "You have no orders in this status",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          );
        }

        if (snapshot.hasData) {
          return Column(
            children: snapshot.data.documents.map<Widget>((doc) {
              String stat;
              if (doc['Status'] == 'received') {
                stat = 'Not Responded by Seller';
              } else if (doc['Status'] == 'waiting') {
                stat = 'Confirm the order';
              } else if (doc['Status'] == 'to pack') {
                stat = 'Seller is working on your order';
              } else {
                stat = 'Order is completed';
              }
              var fontSize = MediaQuery.of(context).size.shortestSide * 0.069;

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => orderDetailsPage(doc, context)),
                  );
                },
                child: Card(
                  margin:
                      new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  elevation: 20,
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    title: Text(
                      doc['SellerName'],
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: fontSize),
                    ),
                    subtitle: Text(
                      "You had ordered " +
                          doc['Items'].length.toString() +
                          " items",
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                          fontSize: fontSize * 0.6),
                    ),
                    trailing: Text(
                      stat,
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w600,
                          color: primaryColour.withOpacity(0.8),
                          fontSize: fontSize * 0.52),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      });
}

orderDetailsPage(DocumentSnapshot documentSnapshot, BuildContext context) {
  return Container(
    padding: EdgeInsets.all(12.0),
    color: secondaryColour,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text(documentSnapshot.id.toString())],
    ),
  );
}
