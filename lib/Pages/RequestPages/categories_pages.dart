import 'package:Khojbuy/Constants/categories.dart';
import 'package:Khojbuy/Constants/colour.dart';
import 'package:Khojbuy/Pages/OrderPages/shop_list.dart';
import 'package:Khojbuy/Pages/RequestPages/add_request.dart';
import 'package:Khojbuy/Widgets/info_dialouge.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class CategoriesPage extends StatelessWidget {
  final int counter;
  CategoriesPage(this.counter);
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.shortestSide;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: primaryColour,
          actions: [
            IconButton(
                icon: Icon(
                  Icons.info_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        if (counter == 0) {
                          return InfoDailouge('ORDER',
                              'This option of placing orders helps you to place orders directly to the shop and contact the shopkeeper with all the proceedings, this reduces all your your task of waiting near shops');
                        }
                        return InfoDailouge('REQUEST',
                            'This option of sending request helps you to send any query or product to all the sellers of a particular category, you will get requests from sellers about availabilty and price. So, saving your time in checking different stores for the same');
                      });
                })
          ],
          title: Text(
            "Khojbuy",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.shortestSide * 0.1),
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      counter == 0
                          ? 'Choose the category where you want to place order'
                          : 'Choose the category where you want to send request',
                      style: TextStyle(
                          color: primaryColour,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.08),
                    ),
                  )),
              Expanded(
                flex: 5,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: 16,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () async {
                          if (counter == 0) {
                            DocumentSnapshot snap = await FirebaseFirestore
                                .instance
                                .collection('BuyerData')
                                .doc(FirebaseAuth.instance.currentUser.uid)
                                .get();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShopList(
                                      categories[index].toString(),
                                      snap.data()['City'])),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddRequestPage(
                                      categories[index].toString())),
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 2,
                            color: secondaryColour.withOpacity(0.15),
                            child: ListTile(
                                dense: true,
                                title: Text(
                                  categories[index].toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: primaryColour,
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.bold,
                                      fontSize: width * 0.06),
                                )),
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        ));
  }
}
