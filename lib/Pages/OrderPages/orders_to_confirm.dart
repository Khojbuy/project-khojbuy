import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

orderToConfirm(BuildContext context) {
  return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Order')
          .where('Customer', isEqualTo: FirebaseAuth.instance.currentUser.uid)
          .where('Status', isEqualTo: 'waiting')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data.documents.toString() == "[]") {
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
                    title: Text(doc['SellerName']),
                    subtitle: Text("You had ordered " +
                        doc['Items'].length.toString() +
                        " items"),
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
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text(documentSnapshot.id.toString())],
    ),
  );
}
