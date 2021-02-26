import 'package:Khojbuy/Constants/categories.dart';
import 'package:Khojbuy/Pages/OrderPages/shop_page_data.dart';
import 'package:Khojbuy/Pages/Story/story_page.dart';

import 'package:Khojbuy/Widgets/card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
getToken() async {
  String token = await _firebaseMessaging.getToken();
  print(token);
  FirebaseFirestore.instance
      .collection('BuyerData')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .update({'FCM': token});
}

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.longestSide;
    var width = MediaQuery.of(context).size.shortestSide;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              final String city = snapshot.data['City'];
              if (snapshot.data['FCM'] == '') {
                getToken();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBuilder(
                    stream:
                        FirebaseFirestore.instance.collection(city).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (!snap.hasData) {
                        return Container();
                      }
                      final shopList = snap.data.documents;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text(
                              "Advertisements",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'OpenSans',
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            height: 140,
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: shopList.length,
                                itemBuilder: (context, index) {
                                  if (shopList[index]['stories'].toString() !=
                                      '[]') {
                                    final list = shopList[index]['stories'];

                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  StoryPage(shopList[index])),
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                              padding:
                                                  EdgeInsets.only(top: 6.0),
                                              height: 90,
                                              width: 60,
                                              child: Material(
                                                type: MaterialType.canvas,
                                                shadowColor: Colors.blueGrey,
                                                elevation: 6.0,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0)),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  child: CachedNetworkImage(
                                                    width: 100,
                                                    fadeInCurve: Curves.easeIn,
                                                    fadeOutDuration: Duration(
                                                        microseconds: 100),
                                                    progressIndicatorBuilder: (context,
                                                            url,
                                                            downloadProgress) =>
                                                        Center(
                                                            heightFactor: 10,
                                                            child: CircularProgressIndicator(
                                                                value: downloadProgress
                                                                    .progress)),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        Center(
                                                            child: Icon(
                                                                Icons.error)),
                                                    fit: BoxFit.fitWidth,
                                                    imageUrl: list[0]['url'],
                                                  ),
                                                ),
                                              )),
                                          Container(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            width: 100,
                                            height: 50,
                                            child: Text(
                                              shopList[index]['name'],
                                              maxLines: 2,
                                              softWrap: true,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontFamily: 'OpenSans',
                                                  fontSize: 16,
                                                  color: Colors.black87),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                }),
                          ),
                        ],
                      );
                    },
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 4.0),
                    child: Text(
                      "Shop by category",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                          fontSize: 24,
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
                  Padding(
                    padding: EdgeInsets.only(left: 10.0, top: 10.0),
                    child: Text(
                      "Recommended Shops",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('SellerData')
                          .where('AddressCity', isEqualTo: city)
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snap) {
                        if (snap.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (!snap.hasData) {
                          return Container();
                        }
                        return Container(
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snap.data.documents.length,
                              itemBuilder: (context, index) {
                                if (snap.data.documents[index]
                                            ['PhotoURL'] ==
                                        'url' ||
                                    snap.data.documents[index]["Priority"] ==
                                        false ||
                                    !snap.data.documents[index]['display']) {
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
                                      decoration: BoxDecoration(),
                                      child: Card(
                                        elevation: 4.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            image(snap.data.documents[index]
                                                ['PhotoURL']),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 8.0,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
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
                                                              ["ShopName"]
                                                          .toString()
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontFamily:
                                                              'OpenSans',
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      maxLines: 3,
                                                      textAlign: TextAlign.left,
                                                    ),
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
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontSize: 10,
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
                                          ],
                                        ),
                                      ),
                                    ));
                              }),
                        );
                      })
                ],
              );
            },
          ),
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
          child: CachedNetworkImage(
            imageUrl: url,
            height: 100,
            width: 100,
            fadeInCurve: Curves.easeIn,
            fadeOutDuration: Duration(microseconds: 100),
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Container(
                    height: 50,
                    child: CircularProgressIndicator(
                        value: downloadProgress.progress)),
            errorWidget: (context, url, error) => Icon(Icons.error),
            fit: BoxFit.cover,
          ));
}
