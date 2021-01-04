import 'package:Khojbuy/Constants/colour.dart';
import 'package:Khojbuy/Widgets/info_dialouge.dart';
import 'package:Khojbuy/Widgets/notice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddRequestPage extends StatefulWidget {
  final String category;
  AddRequestPage(this.category);
  @override
  _AddRequestPageState createState() => _AddRequestPageState(this.category);
}

class _AddRequestPageState extends State<AddRequestPage> {
  final String category;
  _AddRequestPageState(this.category);
  String remarks;
  String item;
  String imgURL;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.shortestSide;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primaryColour,
        title: Text(
          "SEND REQUEST",
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
                Icons.info_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return InfoDailouge('REQUEST',
                          'This option of sending request helps you to send any query or product to all the sellers of a particular category, you will get requests from sellers about availabilty and price. So, saving your time in checking different stores for the same');
                    });
              })
        ],
      ),
      body: Container(
          padding: EdgeInsets.all(10.0),
          child: (FirebaseAuth.instance.currentUser.uid == null)
              ? disclaimer(width, context)
              : SingleChildScrollView(
                  child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Category :-  " + category,
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text('Enter the details of your request',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 4.0),
                          child: TextFormField(
                            initialValue: remarks,
                            keyboardType: TextInputType.text,
                            maxLines: 3,
                            decoration: InputDecoration(
                                hintText: "e.g - 50 green gel pens",
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32.0)),
                                fillColor: Colors.white),
                            onChanged: (value) {
                              setState(() {
                                remarks = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ]))),
    );
  }
}
