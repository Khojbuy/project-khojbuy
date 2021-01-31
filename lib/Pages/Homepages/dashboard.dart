import 'package:Khojbuy/Constants/categories.dart';
import 'package:Khojbuy/Pages/OrderPages/shop_page.dart';
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
            padding: EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Text(
              "SHOP BY CATEGORY",
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'OpenSans',
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: height * 0.25,
            child: GridView.count(
              scrollDirection: Axis.horizontal,
              crossAxisCount: 2,
              children: List.generate(
                  16,
                  (index) => categoryCard(
                      context, categories[index], catImages[index])),
            ),
          ),
          Container(
              padding: EdgeInsets.only(top: 20.0),
              child: Column(children: [
                Text(
                  "Shops near me".toUpperCase(),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'OpenSans',
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
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
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snap.data.documents.length,
                              itemBuilder: (context, index) {
                                if (snap.data.documents[index]['PhotoURL'] ==
                                        'url' ||
                                    snap.data.documents[index]["Priority"] ==
                                        false) {
                                  return Container();
                                }
                                return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ShopPage(
                                                snap.data.documents[index])),
                                      );
                                    },
                                    child: Container(
                                      height: MediaQuery.of(context)
                                              .size
                                              .longestSide *
                                          0.2,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 4.0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                      child: Card(
                                        elevation: 4.0,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            if (index.isEven)
                                              image(snap.data.documents[index]
                                                  ['PhotoURL'])
                                            else if (index.isOdd)
                                              Container()
                                            else
                                              Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    snap
                                                        .data
                                                        .documents[index]
                                                            ["ShopName"]
                                                        .toString()
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontFamily: 'OpenSans',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.fade,
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .shortestSide *
                                                            0.45,
                                                    child: Text(
                                                      snap
                                                          .data
                                                          .documents[index]
                                                              ['DealsIn']
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontFamily:
                                                              'OpenSans',
                                                          fontWeight:
                                                              FontWeight.w500),
                                                      softWrap: true,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            if (index.isOdd)
                                              image(snap.data.documents[index]
                                                  ['PhotoURL'])
                                            else if (index.isEven)
                                              Container()
                                            else
                                              Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ));
                              });
                        });
                  },
                )
              ]))
        ],
      ),
    );
  }
}

image(String url) {
  return (url == 'url')
      ? CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 50,
          child: Image.asset(
            "assets/images/shop.png",
            fit: BoxFit.contain,
          ),
        )
      : ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Image.network(
            url,
            fit: BoxFit.cover,
            height: 120,
            width: 120,
          ),
        );
}
