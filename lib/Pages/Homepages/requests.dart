import 'package:Khojbuy/Pages/RequestPages/request_sent.dart';
import 'package:flutter/material.dart';

class RequestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: requestList(context),
    );
  }
}
