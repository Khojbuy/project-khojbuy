import 'package:Khojbuy/Constants/colour.dart';
import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Text("MY ORDERS",
              style: TextStyle(
                  color: primaryColour,
                  fontSize: 20,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold))),
    );
  }
}
