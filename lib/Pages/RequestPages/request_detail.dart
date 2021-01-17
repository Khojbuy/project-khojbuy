import 'package:Khojbuy/Constants/colour.dart';
import 'package:Khojbuy/Pages/OrderPages/shop_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RequestDetail extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;

  RequestDetail(this.documentSnapshot);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.shortestSide;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primaryColour,
        title: Text(
          "REQUEST DETAILS",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.shortestSide * 0.07),
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.delete_forever_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('Request')
                    .doc(documentSnapshot.id)
                    .delete()
                    .then((value) => Navigator.of(context).pop());
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Row(
                  children: [
                    Text(
                      'REQUEST ID - ',
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.05),
                    ),
                    Text(
                      documentSnapshot.id,
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w500,
                          fontSize: width * 0.05),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 12.0, bottom: 12.0),
                child: Row(
                  children: [
                    Text(
                      'CATEGORY NAME - ',
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.05),
                    ),
                    Text(
                      documentSnapshot['Category'],
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w500,
                          fontSize: width * 0.05),
                    )
                  ],
                ),
              ),
              (documentSnapshot['Image']) != 'url'
                  ? Container(
                      height: MediaQuery.of(context).size.shortestSide * 0.55,
                      width: MediaQuery.of(context).size.shortestSide * 0.55,
                      decoration: BoxDecoration(
                          color: primaryColour.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Center(
                        child: Image.network(
                          documentSnapshot['Image'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'You had attached no image',
                        style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w700,
                            fontSize: width * 0.05),
                      ),
                    ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                child: Text(
                  'Here are the Seller Responses :- ',
                  style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w700,
                      fontSize: width * 0.06),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Request')
                        .doc(documentSnapshot.id)
                        .collection('SellerResponses')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: snapshot.data.documents.map<Widget>((doc) {
                          return Card(
                            elevation: 2,
                            child: ListTile(
                              dense: true,
                              title: Text(
                                doc['ShopName'],
                                style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16),
                              ),
                              subtitle: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      doc['Price'],
                                      style: TextStyle(
                                          fontFamily: 'OpenSans',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12),
                                    ),
                                    Text(
                                      doc['Remark'],
                                      style: TextStyle(
                                          fontFamily: 'OpenSans',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12),
                                    )
                                  ],
                                ),
                              ),
                              trailing: IconButton(
                                onPressed: () async {
                                  var query = await FirebaseFirestore.instance
                                      .collection('SellerData')
                                      .doc(doc.id)
                                      .get();
                                  print(query.data().toString());
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ShopPage(query.data())),
                                  );
                                },
                                icon: Icon(Icons.arrow_forward_ios_rounded),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
