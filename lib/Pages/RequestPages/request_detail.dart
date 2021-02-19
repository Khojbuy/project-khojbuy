import 'package:Khojbuy/Constants/colour.dart';
import 'package:Khojbuy/Pages/OrderPages/shop_page_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class RequestDetail extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;

  RequestDetail(this.documentSnapshot);

  @override
  Widget build(BuildContext context) {
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
          documentSnapshot['Status'] == 'active'
              ? IconButton(
                  tooltip: 'Archive your request',
                  icon: Icon(
                    Icons.archive_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('Request')
                        .doc(documentSnapshot.id)
                        .update({'Status': 'completed'}).then(
                            (value) => Navigator.of(context).pop());
                  })
              : Container()
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Request ID - ',
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    Text(
                      documentSnapshot.id,
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w500,
                          fontSize: 12),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date - ',
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    Text(
                      documentSnapshot['Time']
                          .toDate()
                          .toString()
                          .substring(0, 10),
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w500,
                          fontSize: 12),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Item Requested - ',
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    Container(
                      child: Text(
                        documentSnapshot['Item'].toString(),
                        softWrap: true,
                        style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w500,
                            fontSize: 12),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Row(
                  children: [
                    Text(
                      'Category - ',
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    Text(
                      documentSnapshot['Category'],
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w500,
                          fontSize: 12),
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
                          child: PinchZoom(
                              maxScale: 4.0,
                              zoomedBackgroundColor:
                                  Colors.black.withOpacity(0.3),
                              resetDuration: Duration(microseconds: 100),
                              image: CachedNetworkImage(
                                imageUrl: documentSnapshot['Image'],
                                fadeInCurve: Curves.easeIn,
                                fadeOutDuration: Duration(microseconds: 100),
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ))),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'You had attached no image',
                        style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w700,
                            fontSize: 14),
                      ),
                    ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                child: Text(
                  'Here are the Seller Responses :- ',
                  style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w700,
                      fontSize: 14),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 18.0),
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
                        physics: NeverScrollableScrollPhysics(),
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
                                    fontSize: 14),
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
                                  FirebaseFirestore.instance
                                      .collection('SellerData')
                                      .doc(doc.id)
                                      .snapshots()
                                      .listen((event) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ShopPage(event)),
                                    );
                                  });
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
