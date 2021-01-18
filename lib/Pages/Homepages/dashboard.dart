import 'package:Khojbuy/Constants/categories.dart';
import 'package:Khojbuy/Widgets/card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.longestSide;
    var width = MediaQuery.of(context).size.shortestSide;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: height * 0.25,
            child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: [
                sendRequestCard(height, width, context),
                sendOrderCard(height, width, context),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: height * 0.18,
            child: ListView.builder(
                itemCount: categories.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(4.0),
                    child: categoryCard(
                        context, categories[index], catImages[index]),
                  );
                }),
          ),
          Container(
            padding: EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                Text(
                  "Shops near me",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontFamily: 'Opensans',
                      fontSize: height * 0.042,
                      color: Colors.black,
                      fontWeight: FontWeight.w700),
                ),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('BuyerData')
                      .doc(FirebaseAuth.instance.currentUser.uid)
                      .get(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData ||
                        snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('SellerData')
                          .where('AddressCity',
                              isEqualTo: snapshot.data['City'])
                          //.where('PhotoURL', isNotEqualTo: 'url')
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snap) {
                        if (snap.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (!snap.hasData) {
                          return Container();
                        }
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snap.data.documents.length,
                            itemBuilder: (context, index) {
                              if (snap.data.documents[index]['PhotoURL'] ==
                                  'url') {
                                return Container();
                              }
                              return shopHomeCard(
                                  snap.data.documents[index], context);
                            });
                      },
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
