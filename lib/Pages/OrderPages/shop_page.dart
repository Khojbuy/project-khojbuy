import 'package:Khojbuy/Constants/colour.dart';
import 'package:Khojbuy/Pages/OrderPages/add_order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class ShopPage extends StatefulWidget {
  final shopDetails;

  ShopPage(this.shopDetails);

  @override
  _ShopPageState createState() => _ShopPageState(shopDetails);
}

class _ShopPageState extends State<ShopPage> {
  final shopDetails;
  _ShopPageState(this.shopDetails);
  bool star = false;
  int rate = 0;
  String review = '';

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
              fontSize: MediaQuery.of(context).size.shortestSide * 0.1),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (widget.shopDetails['PhotoURL'] == 'url')
                  ? Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 80,
                        child: Image.asset(
                          "assets/images/shop.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                  : Container(
                      height: 210,
                      width: 210,
                      padding: const EdgeInsets.only(top: 40.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(40.0),
                          child: PinchZoom(
                            maxScale: 4.0,
                            zoomedBackgroundColor:
                                Colors.black.withOpacity(0.3),
                            resetDuration: Duration(microseconds: 100),
                            image: Image.network(
                              widget.shopDetails['PhotoURL'],
                              fit: BoxFit.contain,
                              height: 200,
                              width: 200,
                            ),
                          )),
                    ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    dataTile("SHOP NAME - ", widget.shopDetails['ShopName'],
                        context),
                    dataTile(
                        "CITY - ", widget.shopDetails['AddressCity'], context),
                    dataTile(
                        "CATEGORY - ", widget.shopDetails['Category'], context),
                    dataTile(
                        'DEALS IN - ', widget.shopDetails['DealsIn'], context),
                    widget.shopDetails['Other'] == ''
                        ? Container()
                        : dataTile(
                            'SPECIAL - ', widget.shopDetails['Other'], context),
                    widget.shopDetails['Delivery']
                        ? dataTile(
                            '', 'Home Delivery Service Available', context)
                        : Container()
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RaisedButton(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        textColor: Colors.white,
                        child: Text(
                          "PLACE ORDER",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'OpenSans'),
                        ),
                        color: primaryColour.withOpacity(0.9),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AddOrderPage(widget.shopDetails)),
                          );
                        }),
                    RaisedButton(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        textColor: Colors.white,
                        child: Text(
                          "CONTACT US",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'OpenSans'),
                        ),
                        color: primaryColour.withOpacity(0.9),
                        onPressed: () async {
                          final Uri feedback = Uri(
                            scheme: 'tel',
                            path: widget.shopDetails['PhoneNo'],
                          );
                          var url = feedback.toString();
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch';
                          }
                        }),
                    RaisedButton(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        textColor: Colors.white,
                        child: Text(
                          "RATE US",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'OpenSans'),
                        ),
                        color: primaryColour.withOpacity(0.9),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  backgroundColor: Colors.white,
                                  elevation: 20,
                                  insetAnimationCurve: Curves.decelerate,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
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
                                                widget.shopDetails['ShopName']
                                                    .toString()
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
                                            keyboardType: TextInputType.text,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 20,
                                                color: Colors.black87),
                                            decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.fromLTRB(
                                                        20.0, 15.0, 20.0, 0.0),
                                                hintText: 'Enter your review',
                                                hintStyle: TextStyle(
                                                    fontFamily: 'OpenSans',
                                                    color: Colors.blueGrey)),
                                            minLines: 1,
                                            onChanged: (value) {
                                              setState(() {
                                                review = value;
                                              });
                                            },
                                            onSaved: (newVal) {
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
                                                  Navigator.of(context).pop();
                                                },
                                                elevation: 0.5,
                                                color: Colors.white,
                                                child: Text(
                                                  'NOT NOW',
                                                  style: TextStyle(
                                                      fontFamily: 'OpenSans',
                                                      fontSize: 20,
                                                      color: Colors.black87),
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
                                                final inst = FirebaseFirestore
                                                    .instance
                                                    .collection('SellerData');
                                                if (rate == 0) {
                                                  inst
                                                      .doc(shopDetails.id)
                                                      .collection('Review')
                                                      .doc(FirebaseAuth.instance
                                                          .currentUser.uid)
                                                      .set({
                                                    'rating': rate,
                                                    'comment': review
                                                  });
                                                }

                                                inst
                                                    .doc(shopDetails.id)
                                                    .collection('Review')
                                                    .get()
                                                    .then((value) {
                                                  int sum = 0;
                                                  for (var i = 0;
                                                      i < value.docs.length;
                                                      i++) {
                                                    sum +=
                                                        value.docs[i]['rating'];
                                                  }
                                                  sum =
                                                      sum ~/ value.docs.length;
                                                  print(sum.toString());
                                                  inst
                                                      .doc(shopDetails.id)
                                                      .update({'Rating': sum});
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
                        }),
                  ],
                ),
              ),
              /*  */
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('SellerData')
                        .doc(widget.shopDetails.id)
                        .collection('Review')
                        .snapshots(),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                      return Column(
                        children: [
                          Container(
                            child: Text(
                              'What customers think about this shop',
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                              ),
                            ),
                          ),
                          ListView.builder(
                              itemCount: snapshot.data.documents.length,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (cntxt, index) {
                                if (snapshot.data.documents[index]['comment'] ==
                                    '') {
                                  return Container();
                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 14.0,
                                        right: 10.0,
                                        top: 8.0,
                                        bottom: 8.0),
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
                                        )
                                      ],
                                    ),
                                  );
                                }
                              }),
                        ],
                      );
                    },
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

dataTile(String field, String detail, BuildContext context) {
  return Padding(
    padding:
        const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0, right: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          field,
          style: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.shortestSide * 0.05),
        ),
        Expanded(
          child: Text(
            detail,
            softWrap: true,
            style: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.shortestSide * 0.04),
          ),
        )
      ],
    ),
  );
}
