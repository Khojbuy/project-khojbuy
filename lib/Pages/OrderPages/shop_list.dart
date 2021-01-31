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
                                height:
                                    MediaQuery.of(context).size.longestSide *
                                        0.2,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Card(
                                  elevation: 4.0,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      if (index.isEven)
                                        image(snapshot.data.documents[index]
                                            ['PhotoURL'])
                                      else if (index.isOdd)
                                        Container()
                                      else
                                        Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              snapshot.data
                                                  .documents[index]['ShopName']
                                                  .toString()
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: 'OpenSans',
                                                  fontWeight: FontWeight.bold),
                                              maxLines: 1,
                                              overflow: TextOverflow.fade,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .shortestSide *
                                                  0.45,
                                              child: Text(
                                                snapshot.data
                                                    .documents[index]['DealsIn']
                                                    .toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: 'OpenSans',
                                                    fontWeight:
                                                        FontWeight.w500),
                                                softWrap: true,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      if (index.isOdd)
                                        image(snapshot.data.documents[index]
                                            ['PhotoURL'])
                                      else if (index.isEven)
                                        Container()
                                      else
                                        Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                    ],
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

  image(String url) {
    return (url == 'url')
        ? CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 50,
            child: Image.asset(
              "assets/images/shop.png",
              fit: BoxFit.contain,
            ),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.network(
              url,
              fit: BoxFit.cover,
              height: 120,
              width: 120,
            ),
          );
  }
}
