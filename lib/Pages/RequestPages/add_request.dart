import 'dart:io';

import 'package:Khojbuy/Constants/colour.dart';

import 'package:Khojbuy/Widgets/info_dialouge.dart';
import 'package:Khojbuy/Widgets/notice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddRequestPage extends StatefulWidget {
  final String category;
  AddRequestPage(this.category);
  @override
  _AddRequestPageState createState() => _AddRequestPageState(this.category);
}

class _AddRequestPageState extends State<AddRequestPage> {
  final String category;
  final requestkey = GlobalKey<ScaffoldState>();
  _AddRequestPageState(this.category);
  bool loading = false;
  String remarks;
  String item;
  String imgURL;
  File image;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.shortestSide;
    return Scaffold(
      key: requestkey,
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
          child: (FirebaseAuth.instance.currentUser == null)
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
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                    'Add an image (if any for reference}',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SafeArea(
                                            child: Container(
                                              child: new Wrap(
                                                children: <Widget>[
                                                  new ListTile(
                                                      leading: new Icon(
                                                          Icons.photo_library),
                                                      title:
                                                          new Text('Gallery'),
                                                      onTap: () {
                                                        imgfromGallery();
                                                        Navigator.of(context)
                                                            .pop();
                                                      }),
                                                  new ListTile(
                                                    leading: new Icon(
                                                        Icons.photo_camera),
                                                    title: new Text('Camera'),
                                                    onTap: () {
                                                      imgfromCam();
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  child: Container(
                                    height: MediaQuery.of(context)
                                            .size
                                            .shortestSide *
                                        0.4,
                                    width: MediaQuery.of(context)
                                            .size
                                            .shortestSide *
                                        0.4,
                                    decoration: BoxDecoration(
                                        color: primaryColour.withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    child: Center(
                                      child: (image == null)
                                          ? Icon(Icons.camera_alt_rounded)
                                          : Image.file(
                                              image,
                                              fit: BoxFit.contain,
                                            ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: loading
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : RaisedButton(
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
                                    onPressed: () async {
                                      if (remarks == null) {
                                        requestkey.currentState
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                          'Add details of the request to send it',
                                          style:
                                              TextStyle(fontFamily: 'OpenSans'),
                                        )));
                                        return;
                                      }
                                      setState(() {
                                        loading = true;
                                      });

                                      DocumentSnapshot snap =
                                          await FirebaseFirestore.instance
                                              .collection('BuyerData')
                                              .doc(FirebaseAuth
                                                  .instance.currentUser.uid)
                                              .get();

                                      String name = snap.data()['Name'];
                                      String city = snap.data()['City'];

                                      QuerySnapshot snapshot =
                                          await FirebaseFirestore.instance
                                              .collection('SellerData')
                                              .where('AddressCity',
                                                  isEqualTo: city)
                                              .where('Category',
                                                  isEqualTo: category)
                                              .get()
                                              .whenComplete(
                                                  () => print('data fetched'));

                                      String imgurl;
                                      if (image == null) {
                                        imgurl = 'url';
                                      } else {
                                        await FirebaseStorage.instance
                                            .ref()
                                            .child(
                                                "Request/$city/$name/$category/$remarks")
                                            .putFile(image);
                                        imgurl = await FirebaseStorage.instance
                                            .ref()
                                            .child(
                                                "Request/$city/$name/$category/$remarks")
                                            .getDownloadURL();
                                      }

                                      print("Image Added");
                                      CollectionReference collectionReference =
                                          FirebaseFirestore.instance
                                              .collection('Request');

                                      collectionReference.add({
                                        'CustomerName': name,
                                        'Customer': FirebaseAuth
                                            .instance.currentUser.uid,
                                        'City': city,
                                        'Category': category,
                                        'Status': 'active',
                                        'Item': remarks,
                                        'Image': imgurl,
                                        'Time': Timestamp.now(),
                                      }).then((value) {
                                        for (var i = 0;
                                            i < snapshot.docs.length;
                                            i++) {
                                          collectionReference
                                              .doc(value.id)
                                              .update({snapshot.docs[i].id: 0});
                                        }
                                        Navigator.of(context).pop();
                                      });
                                    }),
                          ),
                        )
                      ],
                    ),
                  )
                ]))),
    );
  }

  imgfromCam() async {
    PickedFile img = await ImagePicker()
        .getImage(source: ImageSource.camera, maxHeight: 150, maxWidth: 150);
    int size = await File(img.path).length();
    print(size);
    setState(() {
      image = File(img.path);
    });
  }

  imgfromGallery() async {
    PickedFile img = await ImagePicker()
        .getImage(source: ImageSource.gallery, maxHeight: 150, maxWidth: 150);
    int size = await File(img.path).length();
    print(size);
    setState(() {
      image = File(img.path);
    });
  }
}
