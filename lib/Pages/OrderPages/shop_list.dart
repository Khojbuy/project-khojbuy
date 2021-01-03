import 'package:Khojbuy/Constants/colour.dart';
import 'package:Khojbuy/Pages/OrderPages/shop_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShopList extends StatelessWidget {
  final String category;
  ShopList(this.category);
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.shortestSide;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primaryColour,
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
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Choose the category where you want to send request',
                    style: TextStyle(
                        color: primaryColour,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.05),
                  ),
                )),
            Expanded(
              flex: 3,
              child: FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('SellerData')
                      .where("Category", isEqualTo: category)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ShopPage(
                                          snapshot.data.documents[index])),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                child: Card(
                                  elevation: 2,
                                  color: secondaryColour.withOpacity(0.1),
                                  child: ListTile(
                                    dense: true,
                                    title: Text(
                                      snapshot.data.documents[index]
                                          ['ShopName'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: primaryColour,
                                          fontFamily: 'OpenSans',
                                          fontWeight: FontWeight.bold,
                                          fontSize: width * 0.05),
                                    ),
                                    subtitle: Text(
                                      snapshot.data.documents[index]['DealsIn'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: primaryColour,
                                          fontFamily: 'OpenSans',
                                          fontWeight: FontWeight.bold,
                                          fontSize: width * 0.03),
                                    ),
                                  ),
                                ),
                              ));
                        });
                    //Text(
                    // snapshot.data.documents[0]['AddressCity'].toString());
                  }),
            )
          ],
        ),
      ),
    );
  }
}
