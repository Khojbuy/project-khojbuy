import 'package:Khojbuy/Constants/colour.dart';
import 'package:Khojbuy/Widgets/dialouge.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('BuyerData')
                .doc(FirebaseAuth.instance.currentUser.uid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return CircularProgressIndicator(
                  backgroundColor: fifthColour,
                );
              }
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      title: Text(
                        snapshot.data['Name'],
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.data['Contact'].toString().substring(3) +
                                '  |  ' +
                                snapshot.data['City'],
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.bold),
                          ),
                          snapshot.data['Email'] != ''
                              ? Text(
                                  snapshot.data['Email'],
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54,
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.bold),
                                )
                              : Container()
                        ],
                      ),
                      trailing: FlatButton(
                        child: Text(
                          'Edit',
                          style: TextStyle(
                              fontSize: 18,
                              color: primaryColour.withOpacity(0.8),
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          editData(snapshot.data, context);
                        },
                      ),
                    ),
                  ),
                  listItem(
                      Icons.question_answer_rounded, 'FAQs', 'faq.md', context),
                  listItem(Icons.privacy_tip_rounded, 'Privacy Policy',
                      'privacy.md', context),
                  listItem(Icons.details_rounded, 'Terms and Conditions',
                      'tnc.md', context)
                ],
              );
            },
          ),
        ],
      )),
    );
  }
}

listItem(IconData iconData, String head, String path, BuildContext context) {
  return InkWell(
    onTap: () {
      showDialog(
          context: context,
          builder: (context) {
            return DialougePop(mdFileName: path);
          });
    },
    child: ListTile(
      leading: Icon(
        iconData,
        color: primaryColour,
      ),
      title: Text(
        head,
        style: TextStyle(
            color: primaryColour,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w700,
            fontSize: 16),
      ),
    ),
  );
}

editData(info, context) {
  final formkey = new GlobalKey<FormState>();
  String name = info['Name'], phnNo = info['Contact'], email = info['Email'];
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        insetPadding: EdgeInsets.all(20),
        elevation: 20,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Container(
          height: MediaQuery.of(context).size.longestSide * 0.4,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Form(
                key: formkey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "EDIT PROFILE",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'OpenSans',
                            fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: TextFormField(
                        initialValue: info['Name'],
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'OpenSans',
                            fontSize: 16),
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          hintText: 'Name',
                          hintStyle: TextStyle(
                              color: Colors.black54,
                              fontFamily: 'OpenSans',
                              fontSize: 16),
                        ),
                        onChanged: (value) {
                          setState(() {
                            name = value;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: TextFormField(
                        initialValue: info['Contact'].toString().substring(3),
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'OpenSans',
                            fontSize: 16),
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: 'Phone Number',
                          hintStyle: TextStyle(
                              color: Colors.black54,
                              fontFamily: 'OpenSans',
                              fontSize: 16),
                        ),
                        onChanged: (value) {
                          setState(() {
                            phnNo = value;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: TextFormField(
                        initialValue: info['Email'],
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'OpenSans',
                            fontSize: 16),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Email Address',
                          hintStyle: TextStyle(
                              color: Colors.black54,
                              fontFamily: 'OpenSans',
                              fontSize: 16),
                        ),
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.longestSide * 0.06,
                    ),
                    FlatButton(
                      padding: EdgeInsets.all(0),
                      color: Theme.of(context).buttonColor,
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('BuyerData')
                            .doc(FirebaseAuth.instance.currentUser.uid)
                            .update({
                          'Name': name,
                          'Contact': phnNo,
                          'Email': email
                        }).then((value) => Navigator.of(context).pop());
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        alignment: Alignment.center,
                        height: 50,
                        width: double.infinity,
                        child: Text(
                          "SAVE",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Opensans',
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.button.color,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    },
  );
}
