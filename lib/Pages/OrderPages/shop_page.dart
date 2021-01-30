import 'package:Khojbuy/Constants/colour.dart';
import 'package:Khojbuy/Pages/OrderPages/add_order.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopPage extends StatelessWidget {
  final shopDetails;
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
                  : Padding(
                      padding: const EdgeInsets.only(top: 40.0),
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    dataTile("SHOP NAME - ", shopDetails['ShopName'], context),
                    dataTile("CITY - ", shopDetails['AddressCity'], context),
                    dataTile("CATEGORY - ", shopDetails['Category'], context),
                    dataTile('DEALS IN - ', shopDetails['DealsIn'], context),
                    dataTile('SPECIAL - ', shopDetails['Other'], context),
                    shopDetails['Delivery']
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
                                    AddOrderPage(shopDetails)),
                          );
                        }),
                    RaisedButton(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        textColor: Colors.white,
                        child: Text(
                          "CONTACT SHOP",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'OpenSans'),
                        ),
                        color: primaryColour.withOpacity(0.9),
                        onPressed: () async {
                          final Uri feedback = Uri(
                            scheme: 'tel',
                            path: shopDetails['PhoneNo'],
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
              )

              /*   RaisedButton(
                  child: Text("Place Order"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddOrderPage(shopDetails)),
                    );
                  }) */
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
