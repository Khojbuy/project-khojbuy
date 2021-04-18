import 'package:Khojbuy/Constants/colour.dart';
import 'package:Khojbuy/Pages/OrderPages/add_order.dart';
import 'package:Khojbuy/Pages/OrderPages/image_viewer.dart';
import 'package:Khojbuy/Pages/OrderPages/shop_cart.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';

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
    var menu = widget.shopDetails['Menu'];
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
        actions: [
          IconButton(
              icon: Icon(
                Icons.shopping_bag_rounded,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ShopCart(widget.shopDetails)),
                );
              })
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                      fontWeight: FontWeight.bold, fontFamily: 'OpenSans'),
                ),
                color: primaryColour.withOpacity(0.9),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddOrderPage(widget.shopDetails, [])),
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
                      fontWeight: FontWeight.bold, fontFamily: 'OpenSans'),
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
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.shopDetails['ShopName'],
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.shopDetails['Category'],
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OpenSans')),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.only(left: 8.0, right: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(widget.shopDetails['Rating'].toString(),
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'OpenSans')),
                        SizedBox(
                          width: 2,
                        ),
                        Icon(
                          Icons.star_rounded,
                          color: primaryColour,
                          size: 25,
                        )
                      ],
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 200,
                    child: Text(widget.shopDetails['AddressLocation'],
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans')),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: RichText(
                        text: TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                final query =
                                    widget.shopDetails['AddressLocation'] +
                                        ' ,' +
                                        widget.shopDetails['AddressCity'];
                                List<Location> locations =
                                    await locationFromAddress(query);
                                //print(locations[0].longitude);
                                final String googleMapslocationUrl =
                                    "https://www.google.com/maps/search/?api=1&query=${locations[0].latitude},${locations[0].longitude}";
                                final String encodedURl =
                                    Uri.encodeFull(googleMapslocationUrl);

                                if (await canLaunch(encodedURl)) {
                                  await launch(encodedURl);
                                } else {
                                  print('Could not launch $encodedURl');
                                  throw 'Could not launch $encodedURl';
                                }
                              },
                            text: "Map",
                            style: TextStyle(
                                color: primaryColour,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'OpenSans'))),
                  ),
                ],
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    clipBehavior: Clip.antiAlias,
                    borderRadius: BorderRadius.circular(12),
                    child: widget.shopDetails['PhotoURL'] != 'url'
                        ? Container(
                            height: 165,
                            child: PinchZoom(
                                maxScale: 4.0,
                                image: CachedNetworkImage(
                                  fit: BoxFit.contain,
                                  imageUrl: widget.shopDetails['PhotoURL'],
                                  fadeInCurve: Curves.easeIn,
                                  fadeOutDuration: Duration(microseconds: 100),
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                )),
                          )
                        : Image.asset(
                            "assets/images/shop.png",
                            height: 165,
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 8.0, right: 10.0, bottom: 2.0),
                child: Text(
                  "Deals in: ",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans'),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(bottom: 8.0, right: 10.0, top: 2.0),
                child: Text(
                  widget.shopDetails['DealsIn'],
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans'),
                ),
              ),
              widget.shopDetails['Other'] == ''
                  ? Container()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, right: 10.0, bottom: 2.0),
                          child: Text(
                            "Other Offers: ",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'OpenSans'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 8.0, right: 10.0, top: 2.0),
                          child: Text(
                            widget.shopDetails['Other'],
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'OpenSans'),
                          ),
                        ),
                      ],
                    ),
              widget.shopDetails['Delivery']
                  ? Padding(
                      padding: const EdgeInsets.only(
                          bottom: 8.0, right: 10.0, top: 2.0),
                      child: Text(
                        "We have home delivery facilty",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans'),
                      ),
                    )
                  : Container(),
              InkWell(
                onTap: () {
                  // Navigate to the todo of the reviwes
                  /* Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Catalouge(shopDetails['Menu'])),
                  ); */
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                        text: TextSpan(
                            text: "Check the Shop's Reviews",
                            style: TextStyle(
                                color: primaryColour,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'OpenSans'))),
                    Icon(
                      Icons.arrow_right_rounded,
                      color: Colors.black87,
                      size: 24,
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: RichText(
                    text: TextSpan(
                        text: "Product Catalouge",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans'))),
              ),
              SingleChildScrollView(
                child: menu.length == 0
                    ? Center(
                        child: Text(
                          'The shop has no specific product list uploaded',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black87,
                              fontFamily: 'OpenSans',
                              fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: menu.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    menu[index]['Image'] == ''
                                        ? Container(
                                            height: 100,
                                            width: 100,
                                            margin: EdgeInsets.only(
                                                left: 16, bottom: 6),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.blue.withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.no_photography_rounded,
                                                color: Colors.white,
                                                size: 40,
                                              ),
                                            ),
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ImageViewer(menu[index]
                                                            ['Image'])),
                                              );
                                            },
                                            child: Container(
                                              height: 100,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                color: Colors.blue
                                                    .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(16.0),
                                              ),
                                              margin: EdgeInsets.only(
                                                  left: 16, bottom: 6),
                                              child: CachedNetworkImage(
                                                imageUrl: menu[index]['Image'],
                                                fadeInCurve: Curves.easeIn,
                                                fit: BoxFit.fill,
                                                fadeOutDuration:
                                                    Duration(microseconds: 100),
                                                progressIndicatorBuilder: (context,
                                                        url,
                                                        downloadProgress) =>
                                                    Container(
                                                        height: 10,
                                                        child: CircularProgressIndicator(
                                                            value:
                                                                downloadProgress
                                                                    .progress)),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text(
                                            menu[index]['ItemName'],
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontFamily: 'OpenSans',
                                                fontSize: 14),
                                          ),
                                        ),
                                        Container(
                                          height: 75,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .shortestSide *
                                              0.5,
                                          child: Text(
                                            menu[index]['Detail'],
                                            maxLines: 5,
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontFamily: 'OpenSans',
                                                fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '₹ ' + menu[index]['Price'],
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontFamily: 'OpenSans',
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
              ),
              /* Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
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
                                    borderRadius: BorderRadius.circular(20)),
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.longestSide *
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
                                              print(review);
                                              final inst = FirebaseFirestore
                                                  .instance
                                                  .collection('SellerData');
                                              if (rate != 0) {
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
                                                sum = sum ~/ value.docs.length;
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
                  ],
                ),
              ),
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
                      return ListView.builder(
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
                                  left: 4.0,
                                  right: 4.0,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      color: Colors.black87.withOpacity(0.7),
                                    ),
                                  ],
                                ),
                              );
                            }
                          });
                    },
                  )) */
            ],
          ),
        ),
      ),
    );
  }
}
