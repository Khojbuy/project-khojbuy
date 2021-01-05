import 'package:Khojbuy/Constants/colour.dart';
import 'package:Khojbuy/Pages/OrderPages/add_order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShopPage extends StatelessWidget {
  final QueryDocumentSnapshot shopDetails;
  ShopPage(this.shopDetails);
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
              (shopDetails['PhotoURL'] == 'url')
                  ? Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 80,
                        child: Image.asset(
                          "assets/images/shop.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40.0),
                        child: Image.network(
                          shopDetails['PhotoURL'],
                          fit: BoxFit.cover,
                          height: 200,
                          width: 200,
                        ),
                      ),
                    ),
              RaisedButton(
                  child: Text("Place Order"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddOrderPage(shopDetails)),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
