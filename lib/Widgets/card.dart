import 'package:Khojbuy/Constants/colour.dart';
import 'package:Khojbuy/Pages/OrderPages/shop_list.dart';
import 'package:Khojbuy/Pages/RequestPages/categories_pages.dart';
import 'package:flutter/material.dart';

sendRequestCard(var height, var width, BuildContext context) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
    elevation: 12.0,
    margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
    child: Stack(
      fit: StackFit.loose,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24.0),
          child: Container(
              height: height * 0.25,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [primaryColour, secondaryColour],
                begin: Alignment.topLeft,
              )),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 14.0),
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: height * 0.27,
                          child: Text(
                            'HAVE SOMETHING IN MIND ?',
                            style: TextStyle(
                                fontSize: height * 0.0255,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'OpenSans'),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 14.0, top: 10.0),
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: height * 0.26,
                          child: Text(
                            'Let the retailers know about it and get queries',
                            style: TextStyle(
                                fontSize: height * 0.022,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'OpenSans'),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        alignment: Alignment.centerLeft,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          elevation: 24.0,
                          color: fourthColour.withOpacity(0.9),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CategoriesPage()),
                            );
                          },
                          child: Text(
                            'SEND REQUEST',
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: height * 0.03,
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                  Image.asset(
                    "assets/images/shopping.png",
                    height: height * 0.15,
                    width: width * 0.3,
                    fit: BoxFit.fitWidth,
                  ),
                ],
              )),
        ),
      ],
    ),
  );
}

categoryCard(BuildContext context, String category, String image) {
  var hf = MediaQuery.of(context).size.longestSide;
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ShopList(category)),
      );
    },
    child: Card(
      elevation: 12.0,
      child: Container(
        height: hf * 0.13,
        width: hf * 0.13,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              image,
              height: hf * 0.08,
              width: hf * 0.1,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 4.0,
              ),
              child: Text(
                category,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Opensans',
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w700),
              ),
            )
          ],
        ),
      ),
    ),
  );
}
