import 'package:Khojbuy/Constants/colour.dart';
import 'package:Khojbuy/Pages/OrderPages/shop_list.dart';

import 'package:Khojbuy/Pages/RequestPages/categories_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

sendRequestCard(var height, var width, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CategoriesPage(1)),
        );
      },
      child: Image.asset(
        'assets/images/request.png',
        height: height * 0.15,
        width: width * 0.88,
        //fit: BoxFit.contain,
      ),
    ),
  );
}

sendOrderCard(var height, var width, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CategoriesPage(0)),
        );
      },
      child: Image.asset(
        'assets/images/order.png',
        height: height * 0.15,
        width: width * 0.88,
        //fit: BoxFit.contain,
      ),
    ),
  );
}

categoryCard(BuildContext context, String category, String image) {
  var hf = MediaQuery.of(context).size.longestSide;
  return InkWell(
    onTap: () async {
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection('BuyerData')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .get();

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ShopList(category, snap.data()['City'])),
      );
    },
    child: Card(
      elevation: 2.0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              image,
              height: hf * 0.055,
              width: hf * 0.055,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 2.0,
                vertical: 3.0,
              ),
              child: Text(
                category,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 11,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

shopHomeCard(shopDetail, BuildContext context) {
  return Card(
    elevation: 2.0,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: ListTile(
        onTap: () {
          /*  Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ShopPage(shopDetail)),
          ); */
        },
        leading: Container(
          width: 100,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(shopDetail['PhotoURL']))),
        ),
        title: Text(
          shopDetail['ShopName'],
          style: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 14,
              fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          shopDetail['DealsIn'],
          style: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 10,
              fontWeight: FontWeight.w600),
        ),
      ),
    ),
  );
}
