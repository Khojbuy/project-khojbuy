import 'package:Khojbuy/Constants/colour.dart';
import 'package:Khojbuy/Pages/OrderPages/shop_page.dart';
import 'package:Khojbuy/Widgets/info_dialouge.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShopList extends StatelessWidget {
  final String category;
  ShopList(this.category, this.city);
  final String city;

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
                      return InfoDailouge('ORDER',
                          'This option of placing orders helps you to place orders directly to the shop and contact the shopkeeper with all the proceedings, this reduces all your your task of waiting near shops');
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
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Choose the shop where you want to place order',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.06),
                  ),
                )),
            Expanded(
              flex: 5,
              child: FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('SellerData')
                      .where("Category", isEqualTo: category)
                      .where("AddressCity", isEqualTo: city)
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
                                  color: primaryColour.withOpacity(0.3),
                                  child: ListTile(
                                    dense: true,
                                    title: Text(
                                      snapshot.data.documents[index]
                                          ['ShopName'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'OpenSans',
                                          fontWeight: FontWeight.bold,
                                          fontSize: width * 0.05),
                                    ),
                                    subtitle: Text(
                                      snapshot.data.documents[index]['DealsIn'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black,
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
