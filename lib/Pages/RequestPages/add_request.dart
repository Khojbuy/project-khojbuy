import 'package:Khojbuy/Constants/colour.dart';

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
  List<Map<String, dynamic>> list = [];
  String itemName, amount, remark;
  _AddRequestPageState(this.category);
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
              fontSize: MediaQuery.of(context).size.shortestSide * 0.1),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: (FirebaseAuth.instance.currentUser.uid == null)
            ? disclaimer(width, context)
            : Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
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
                      Container(
                        height: MediaQuery.of(context).size.longestSide * 0.2,
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: primaryColour.withOpacity(0.2)),
                        child: Column(
                          children: [
                            Text(
                              'Enter the item and amount here',
                              style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16),
                            ),
                            Row(
                              children: [
                                Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        initialValue: itemName,
                                        decoration: InputDecoration(
                                            hintText: 'Item Name',
                                            hintStyle: TextStyle(
                                                fontFamily: 'OpenSans',
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w600)),
                                        onChanged: (value) {
                                          setState(() {
                                            itemName = value;
                                          });
                                        },
                                      ),
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        initialValue: amount,
                                        decoration: InputDecoration(
                                            hintText: 'Quantity',
                                            hintStyle: TextStyle(
                                                fontFamily: 'OpenSans',
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w600)),
                                        onChanged: (value) {
                                          setState(() {
                                            amount = value;
                                          });
                                        },
                                      ),
                                    )),
                              ],
                            ),
                            RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                child: Text(
                                  "Enter",
                                  style: TextStyle(fontFamily: 'OpenSans'),
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (amount != '' && itemName != '') {
                                      list.add({
                                        'ItemName': itemName,
                                        'Amount': amount
                                      });

                                      itemName = '';
                                    }
                                  });
                                })
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Here are the items in your list',
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              dense: true,
                              title: Text(
                                list[index]['ItemName'],
                                style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                              subtitle: Text(list[index]['Amount'],
                                  style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18)),
                              trailing: InkWell(
                                  onTap: () {
                                    setState(() {
                                      list.removeAt(index);
                                    });
                                    print(list);
                                  },
                                  child: Icon(
                                    Icons.delete,
                                  )),
                            );
                          }),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 32.0, horizontal: 12.0),
                        child: TextFormField(
                          initialValue: remark,
                          keyboardType: TextInputType.text,
                          maxLines: 5,
                          decoration: InputDecoration(
                              hintText: "Delivery before 8pm",
                              labelText: "Additional details(if any)",
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0)),
                              fillColor: Colors.white),
                          onChanged: (value) {
                            setState(() {
                              remark = value;
                            });
                          },
                        ),
                      ),
                      RaisedButton(
                          elevation: 8.0,
                          color: primaryColour,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "SEND REQUEST",
                              style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  color: Colors.white,
                                  fontSize: 24),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              //send request - firebase
                              list.clear();
                            });
                          })
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
