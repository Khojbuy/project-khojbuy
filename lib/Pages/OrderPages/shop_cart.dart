import 'package:Khojbuy/Constants/colour.dart';
import 'package:Khojbuy/Pages/OrderPages/add_order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopCart extends StatefulWidget {
  final QueryDocumentSnapshot documentSnapshot;
  ShopCart(this.documentSnapshot);
  @override
  _ShopCartState createState() => _ShopCartState(documentSnapshot);
}

class _ShopCartState extends State<ShopCart> {
  QueryDocumentSnapshot documentSnapshot;
  _ShopCartState(this.documentSnapshot);
  SharedPreferences preferences;

  prefsInit() async {
    preferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: prefsInit(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (preferences == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<String> cartItems =
                preferences.getStringList(documentSnapshot['ShopName']);
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: primaryColour,
                  centerTitle: false,
                  title: Container(
                      child: Text(
                    "Cart for " + documentSnapshot['ShopName'],
                    softWrap: true,
                    maxLines: 4,
                  )),
                ),
                bottomNavigationBar: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton.icon(
                        onPressed: () {
                          List<Map<String, dynamic>> temp = [];
                          for (var item in cartItems) {
                            temp.add({
                              'ItemName': item,
                              'Amount': '1',
                              'Availability': false,
                              'Price': 0,
                            });
                          }
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AddOrderPage(documentSnapshot, temp)),
                          );
                        },
                        icon: Icon(
                          Icons.playlist_add_check_outlined,
                          color: primaryColour,
                          size: 30,
                        ),
                        label: Text(
                          "Place Order",
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 18,
                              color: primaryColour),
                        )),
                    Text(
                      '|',
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 18,
                          color: primaryColour),
                    ),
                    TextButton.icon(
                        onPressed: () {
                          setState(() {
                            preferences.remove(documentSnapshot['ShopName']);
                          });
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.clear_rounded,
                          color: primaryColour,
                          size: 30,
                        ),
                        label: Text(
                          "Clear Cart",
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 18,
                              color: primaryColour),
                        )),
                  ],
                ),
                body: SafeArea(
                  child: cartItems != null
                      ? ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: cartItems.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    (index + 1).toString() +
                                        '.  ' +
                                        cartItems[index],
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontFamily: 'OpenSans',
                                        fontSize: 14),
                                  ),
                                  ElevatedButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          cartItems.removeAt(index);
                                          preferences.setStringList(
                                              documentSnapshot['ShopName'],
                                              cartItems);
                                        });
                                      },
                                      icon: Icon(Icons.delete),
                                      style: ElevatedButton.styleFrom(
                                          primary: primaryColour),
                                      label: Text("Remove"))
                                ],
                              ),
                            );
                          })
                      : Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Go to shop catalouge to go through the items and choose your favourite ones",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                    fontFamily: 'OpenSans'),
                              ),
                            ),
                          ),
                        ),
                ));
          }
        });
  }
}
