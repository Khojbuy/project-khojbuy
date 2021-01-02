import 'package:Khojbuy/Pages/Initials/get_started.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

disclaimer(var width, BuildContext context) {
  return Container(
    child: Center(
        child: RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: "For sending request, please",
          style: TextStyle(
              color: Colors.blue,
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
              fontSize: width * 0.9),
          children: <TextSpan>[
            TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => GetStartedPage()),
                    );
                  },
                text: 'LOG IN',
                style: TextStyle(
                  color: Colors.blue,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.1,
                )),
          ]),
    )),
  );
}
