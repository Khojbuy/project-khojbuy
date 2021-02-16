import 'package:Khojbuy/Constants/colour.dart';
import 'package:Khojbuy/Pages/Initials/get_started.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

orderToConfirm(BuildContext context) {
  return FirebaseAuth.instance.currentUser == null
      ? Center(
          child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: 'To place orders to your favorite shops, ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'OpenSans',
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GetStartedPage()));
                          },
                        text: 'SIGN IN',
                        style: TextStyle(
                          color: primaryColour,
                          fontSize: 14,
                          fontFamily: 'OpenSans',
                        )),
                  ])))
      : StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Order')
              .where('Customer',
                  isEqualTo: FirebaseAuth.instance.currentUser.uid)
              //.orderBy('Time', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData ||
                snapshot.data.documents.toString() == "[]") {
              print(snapshot.data.toString());
              return Center(
                child: Text(
                  "You have no orders placed yet",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              );
            }

            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  children: snapshot.data.documents.map<Widget>((doc) {
                    String stat;
                    if (doc['Status'] == 'received') {
                      stat = 'Not Responded by Seller';
                    } else if (doc['Status'] == 'waiting') {
                      stat = 'Confirm the order';
                    } else if (doc['Status'] == 'to pack') {
                      stat = 'Seller is working on your order';
                    } else {
                      stat = 'Order is completed';
                    }
                    var fontSize =
                        MediaQuery.of(context).size.shortestSide * 0.069;

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  orderDetailsPage(doc, context)),
                        );
                      },
                      child: Card(
                        margin: new EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 6.0),
                        elevation: 20,
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          title: Text(
                            doc['SellerName'],
                            style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: fontSize * 0.7),
                          ),
                          subtitle: Text(
                            "You had ordered " +
                                doc['Items'].length.toString() +
                                " items",
                            style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                                fontSize: fontSize * 0.55),
                          ),
                          trailing: Text(
                            stat,
                            style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.w600,
                                color: primaryColour.withOpacity(0.8),
                                fontSize: fontSize * 0.48),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          });
}

orderDetailsPage(DocumentSnapshot documentSnapshot, BuildContext context) {
  var width = MediaQuery.of(context).size.shortestSide;
  return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primaryColour,
        title: Text(
          "Khojbuy",
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.shortestSide * 0.085),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Order ID - ',
                      style: TextStyle(
                          fontFamily: 'OpenSans',
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
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date - ',
                      style: TextStyle(
                          fontFamily: 'OpenSans',
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
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Shop Name - ',
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    Text(
                      documentSnapshot['SellerName'],
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w500,
                          fontSize: 12),
                    )
                  ],
                ),
              ),
              documentSnapshot['Status'] == 'received'
                  ? Padding(
                      padding:
                          EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
                      child: ListTile(
                        title: Text(
                          'Item Name',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        trailing: Text(
                          'Quantity',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.only(left: 26, top: 10.0),
                      child: Text(
                        "Item List",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
              (documentSnapshot['Status'] == 'received')
                  ? ListView.builder(
                      itemCount: documentSnapshot['Items'].length,
                      padding: EdgeInsets.only(
                          left: 12.0, right: 12.0, top: 4.0, bottom: 10.0),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var items = documentSnapshot['Items'];
                        return ListTile(
                          dense: true,
                          title: Text(
                            items[index]['ItemName'],
                            maxLines: 2,
                            softWrap: true,
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          trailing: Text(
                            items[index]['Amount'],
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        );
                      })
                  : ListView.builder(
                      padding: EdgeInsets.all(12.0),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: documentSnapshot['Items'].length,
                      itemBuilder: (context, index) {
                        var items = documentSnapshot['Items'];
                        return ListTile(
                          dense: true,
                          title: Text(
                            items[index]['ItemName'],
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                items[index]['Amount'],
                                style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                              ),
                              items[index]['Availability']
                                  ? Text(
                                      '₹' + items[index]['Price'].toString(),
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600),
                                    )
                                  : Text(
                                      "Marked Unavailable",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600),
                                    ),
                            ],
                          ),
                        );
                      },
                    ),
              SizedBox(
                height: MediaQuery.of(context).size.shortestSide * 0.02,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your Remarks  -   ",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          fontFamily: "OpenSans"),
                    ),
                    Text(
                      documentSnapshot["BuyerRemark"] == ''
                          ? 'You had no remarks'
                          : documentSnapshot["BuyerRemark"],
                      softWrap: true,
                      maxLines: 5,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: "OpenSans"),
                    ),
                  ],
                ),
              ),
              (documentSnapshot['Status'] == 'received' ||
                      documentSnapshot['SellerRemark'] == '')
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Seller Remarks  -  ",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                fontFamily: "OpenSans"),
                          ),
                          Text(
                            documentSnapshot["SellerRemark"],
                            softWrap: true,
                            maxLines: 5,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                fontFamily: "OpenSans"),
                          ),
                        ],
                      ),
                    ),
              (documentSnapshot['Status'] == 'waiting')
                  ? Center(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        child: RaisedButton(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                            textColor: Colors.white,
                            child: Text(
                              "CONFIRM FOR PACKING",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'OpenSans'),
                            ),
                            color: primaryColour.withOpacity(0.9),
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('Order')
                                  .doc(documentSnapshot.id)
                                  .update({'Status': 'to pack'});
                              Navigator.of(context).pop();
                            }),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ));
}
