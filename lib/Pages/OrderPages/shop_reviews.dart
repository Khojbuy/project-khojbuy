import 'package:Khojbuy/Constants/colour.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class Catalouge extends StatefulWidget {
  final id;
  final shopName;
  Catalouge(this.id, this.shopName);

  @override
  _CatalougeState createState() => _CatalougeState(id, shopName);
}

class _CatalougeState extends State<Catalouge> {
  final id, shopName;
  _CatalougeState(this.id, this.shopName);
  var rate;
  bool star;
  String review;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: primaryColour,
          title: Text(
            'Khojbuy',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.shortestSide * 0.075),
          ),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                              text: TextSpan(
                                  text: "Shop Reviews",
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'OpenSans'))),
                          InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      backgroundColor: Colors.white,
                                      elevation: 20,
                                      insetAnimationCurve: Curves.decelerate,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: SizedBox(
                                        height: MediaQuery.of(context)
                                                .size
                                                .longestSide *
                                            0.3,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              child: Text(
                                                'RATE ' +
                                                    widget.shopName
                                                        .toUpperCase(),
                                                style: TextStyle(
                                                    fontFamily: 'OpenSans',
                                                    fontSize: 20,
                                                    color: Colors.black87),
                                              ),
                                            ),
                                            SmoothStarRating(
                                              starCount: 5,
                                              allowHalfRating: false,
                                              size: 32,
                                              rating: rate.toDouble(),
                                              color: primaryColour,
                                              onRated: (rating) {
                                                setState(() {
                                                  print(rating.toString());
                                                  rate = rating.toInt();
                                                  star = true;
                                                });
                                              },
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12.0),
                                              child: TextFormField(
                                                autocorrect: true,
                                                initialValue: review,
                                                keyboardType:
                                                    TextInputType.text,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontFamily: 'OpenSans',
                                                    fontSize: 20,
                                                    color: Colors.black87),
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.fromLTRB(
                                                            20.0,
                                                            15.0,
                                                            20.0,
                                                            0.0),
                                                    hintText:
                                                        'Enter your review',
                                                    hintStyle: TextStyle(
                                                        fontFamily: 'OpenSans',
                                                        color:
                                                            Colors.blueGrey)),
                                                minLines: 1,
                                                onChanged: (newVal) {
                                                  setState(() {
                                                    review = newVal;
                                                  });
                                                },
                                              ),
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                RaisedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    elevation: 0.5,
                                                    color: Colors.white,
                                                    child: Text(
                                                      'NOT NOW',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'OpenSans',
                                                          fontSize: 20,
                                                          color:
                                                              Colors.black87),
                                                    )),
                                                Text(
                                                  '|',
                                                  style: TextStyle(
                                                      fontFamily: 'OpenSans',
                                                      fontSize: 30,
                                                      color: Colors.black87),
                                                ),
                                                RaisedButton(
                                                  elevation: 0.5,
                                                  color: Colors.white,
                                                  onPressed: () async {
                                                    print(review);
                                                    final inst =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'SellerData');
                                                    if (rate != 0) {
                                                      inst
                                                          .doc(id)
                                                          .collection('Review')
                                                          .doc(FirebaseAuth
                                                              .instance
                                                              .currentUser
                                                              .uid)
                                                          .set({
                                                        'rating': rate,
                                                        'comment': review
                                                      });
                                                    }

                                                    inst
                                                        .doc(id)
                                                        .collection('Review')
                                                        .get()
                                                        .then((value) {
                                                      int sum = 0;
                                                      for (var i = 0;
                                                          i < value.docs.length;
                                                          i++) {
                                                        sum += value.docs[i]
                                                            ['rating'];
                                                      }
                                                      sum = sum ~/
                                                          value.docs.length;
                                                      print(sum.toString());
                                                      inst.doc(id).update(
                                                          {'Rating': sum});
                                                    });

                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    'SUBMIT',
                                                    style: TextStyle(
                                                        fontFamily: 'OpenSans',
                                                        fontSize: 20,
                                                        color: Colors.black87),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Add a review",
                                  style: TextStyle(
                                      color: primaryColour,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'OpenSans')),
                            ),
                          ),
                        ]),
                    Padding(
                        padding: EdgeInsets.all(8.0),
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('SellerData')
                              .doc(id)
                              .collection('Review')
                              .snapshots(),
                          builder: (BuildContext context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.hasError) {
                              return Container(
                                child: Text('Check Your Network Connection'),
                              );
                            }
                            if (snapshot.data.documents.toString() == '[]') {
                              return Container(
                                child: Text(
                                    'There are no reviews yet. Be the first one to rate this shop'),
                              );
                            }
                            return ListView.builder(
                                itemCount: snapshot.data.documents.length,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (cntxt, index) {
                                  if (snapshot.data.documents[index]
                                          ['comment'] ==
                                      '') {
                                    return Container();
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        left: 4.0,
                                        right: 4.0,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SmoothStarRating(
                                            isReadOnly: true,
                                            color: primaryColour,
                                            rating: snapshot
                                                .data.documents[index]['rating']
                                                .toDouble(),
                                            size: 20,
                                          ),
                                          Container(
                                            child: Text(
                                              snapshot.data.documents[index]
                                                  ['comment'],
                                              style: TextStyle(
                                                  fontFamily: 'OpenSans',
                                                  fontSize: 12),
                                            ),
                                          ),
                                          Divider(
                                            thickness: 0.5,
                                            color:
                                                Colors.black87.withOpacity(0.7),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                });
                          },
                        ))
                  ],
                ))));
  }
}
