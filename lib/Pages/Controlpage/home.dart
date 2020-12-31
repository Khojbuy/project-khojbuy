import 'package:Khojbuy/Services/authservice.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        child: Text("LOGOUT"),
        onPressed: AuthService().signOut(context),
      ),
    );
  }
}
