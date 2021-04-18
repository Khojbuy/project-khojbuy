import 'dart:convert';

import 'package:Khojbuy/Constants/colour.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Khojbuy/Pages/OrderPages/image_viewer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Catalouge extends StatefulWidget {
  final QueryDocumentSnapshot shopDetails;
  final List<dynamic> menu;
  Catalouge(this.menu, this.shopDetails);

  @override
  _CatalougeState createState() => _CatalougeState(menu, shopDetails);
}

class _CatalougeState extends State<Catalouge> {
  List<dynamic> menu;
  QueryDocumentSnapshot shopDetails;
  _CatalougeState(this.menu, this.shopDetails);

  @override
  Widget build(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('Item added to the cart!'),
      action: SnackBarAction(
        onPressed: () {},
        label: 'Checkout your cart for ${widget.shopDetails['ShopName']} ',
      ),
    );
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
        child: widget.menu.length == 0
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
                itemCount: widget.menu.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            widget.menu[index]['Image'] == ''
                                ? Container(
                                    height: 100,
                                    width: 100,
                                    margin:
                                        EdgeInsets.only(left: 16, bottom: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(16.0),
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
                                            builder: (context) => ImageViewer(
                                                widget.menu[index]['Image'])),
                                      );
                                    },
                                    child: Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      margin:
                                          EdgeInsets.only(left: 16, bottom: 6),
                                      child: CachedNetworkImage(
                                        imageUrl: widget.menu[index]['Image'],
                                        fadeInCurve: Curves.easeIn,
                                        fit: BoxFit.fill,
                                        fadeOutDuration:
                                            Duration(microseconds: 100),
                                        progressIndicatorBuilder: (context, url,
                                                downloadProgress) =>
                                            Container(
                                                height: 10,
                                                child:
                                                    CircularProgressIndicator(
                                                        value: downloadProgress
                                                            .progress)),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    widget.menu[index]['ItemName'],
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontFamily: 'OpenSans',
                                        fontSize: 14),
                                  ),
                                ),
                                Container(
                                  height: 75,
                                  width:
                                      MediaQuery.of(context).size.shortestSide *
                                          0.5,
                                  child: Text(
                                    widget.menu[index]['Detail'],
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
                              '₹ ' + widget.menu[index]['Price'],
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontFamily: 'OpenSans',
                                  fontSize: 12),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await addItemtoCart(widget.menu[index]['ItemName'],
                                widget.shopDetails['ShopName']);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: primaryColour,
                            elevation: 10,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                            ),
                          ),
                          child: Text(
                            "Add to Cart",
                            style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: 12,
                                color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  );
                }),
      ),
    );
  }

  addItemtoCart(String itemName, String shopName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String cart = jsonDecode(preferences.get((shopName)));
    cart = cart + "{$itemName : 1}";
    preferences.setString(shopName, jsonEncode(cart));
    print(preferences.getString(shopName));
  }
}
