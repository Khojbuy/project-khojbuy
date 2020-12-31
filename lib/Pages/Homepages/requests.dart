import 'package:Khojbuy/Constants/colour.dart';
import 'package:flutter/material.dart';

class RequestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Text("MY REQUESTS",
              style: TextStyle(
                  color: primaryColour,
                  fontSize: 20,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold))),
    );
  }
}
