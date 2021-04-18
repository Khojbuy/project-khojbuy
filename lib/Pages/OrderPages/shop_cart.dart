import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopCart extends StatefulWidget {
  final QueryDocumentSnapshot documentSnapshot;
  ShopCart(this.documentSnapshot);
  @override
  _ShopCartState createState() => _ShopCartState(documentSnapshot);
}

class _ShopCartState extends State<ShopCart> {
  QueryDocumentSnapshot documentSnapshot;
  _ShopCartState(this.documentSnapshot);
  SharedPreferences preferences;

  prefsInit() async {
    preferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: prefsInit(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            color: Colors.blue,
          );
        },
      ),
    );
  }
}
