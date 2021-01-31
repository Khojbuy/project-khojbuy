import 'package:Khojbuy/Constants/colour.dart';
import 'package:flutter/material.dart';

class Notifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primaryColour,
        title: Text(
          "Notifications",
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.shortestSide * 0.07),
        ),
      ),
      body: Center(
        child: Text(
          'You have no notifications as of now.\n Keep Exploring',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black87, fontFamily: 'OpenSans', fontSize: 20),
        ),
      ),
    );
  }
}
