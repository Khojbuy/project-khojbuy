import 'package:Khojbuy/Constants/colour.dart';
import 'package:Khojbuy/Pages/Initials/get_started.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

disclaimer(var width, BuildContext context) {
  return Center(
      child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: 'To send requests to all the sellers, ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: 'OpenSans',
              ),
              children: <TextSpan>[
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GetStartedPage()));
                      },
                    text: 'SIGN IN',
                    style: TextStyle(
                      color: primaryColour,
                      fontSize: 14,
                      fontFamily: 'OpenSans',
                    )),
              ])));
}
