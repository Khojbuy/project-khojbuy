import 'package:Khojbuy/Pages/OrderPages/orders_to_confirm.dart';
import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: orderToConfirm(context),
    );
  }
}
