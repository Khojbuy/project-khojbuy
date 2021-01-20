import 'package:Khojbuy/Constants/categories.dart';
import 'package:Khojbuy/Widgets/card.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.longestSide;
    var width = MediaQuery.of(context).size.shortestSide;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: height * 0.25,
            child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: [
                sendRequestCard(height, width, context),
                sendOrderCard(height, width, context),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(
              "SHOP BY CATEGORY",
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'OpenSans',
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            height: height * 0.5,
            child: GridView.count(
              crossAxisCount: 4,
              children: List.generate(
                16,
                (index) =>
                    categoryCard(context, categories[index], catImages[index]),
              ),
            ),
          )

          /* Container(
            padding: EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                Text(
                  "Shops near me",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontFamily: 'Opensans',
                      fontSize: height * 0.042,
                      color: Colors.black,
                      fontWeight: FontWeight.w700),
                ),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('BuyerData')
                      .doc(FirebaseAuth.instance.currentUser.uid)
                      .get(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData ||
                        snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('SellerData')
                          .where('AddressCity',
                              isEqualTo: snapshot.data['City'])
                          //.where('PhotoURL', isNotEqualTo: 'url')
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snap) {
                        if (snap.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (!snap.hasData) {
                          return Container();
                        }
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snap.data.documents.length,
                            itemBuilder: (context, index) {
                              if (snap.data.documents[index]['PhotoURL'] ==
                                  'url') {
                                return Container();
                              }
                              return shopHomeCard(
                                  snap.data.documents[index], context);
                            });
                      },
                    );
                  },
                ),
              ],
            ),
          ) */
        ],
      ),
    );
  }
}
