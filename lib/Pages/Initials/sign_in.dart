import 'package:Khojbuy/Constants/colour.dart';
import 'package:animated_button/animated_button.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final formkey = new GlobalKey<FormState>();
  String name, phnNo;
  String verificationId, smsCode;
  bool codeSent = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(10.0),
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset(
                  'assets/images/logo.png',
                  height: height * 0.35,
                  width: width,
                ),
              ),
              Text(
                'Login to Khojbuy',
                style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans'),
              ),
              Form(
                  key: formkey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      TextFormField(), //First Name
                      TextFormField(), //Second Name
                      DropdownButtonFormField(
                          items: null, onChanged: null), //City chooseing
                      TextFormField(), //Mobile Number
                    ],
                  )),
              AnimatedButton(
                onPressed: () {},
                duration: 50,
                child: Text(
                  "Send OTP",
                  style: TextStyle(
                      fontFamily: 'OpenSans',
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                color: secondaryColour,
                enabled: true, // validate phn no
                shape: BoxShape.rectangle,
              )
            ],
          ),
        ),
      ),
    );
  }
}
