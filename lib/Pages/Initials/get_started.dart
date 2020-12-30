import 'package:Khojbuy/Constants/colour.dart';
import 'package:Khojbuy/Pages/Homepages/home.dart';
import 'package:Khojbuy/Pages/Initials/sign_in.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../Widgets/dialouge.dart';

class GetStartedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  Text(
                    "Khojbuy",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        color: primaryColour),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    "Connects the entire market to your fingertips ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: secondaryColour),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 26),
                child: Image.asset('assets/images/getstarted.jpg'),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(80)),
              ),
            ),
            Container(
              padding: EdgeInsets.all(30),
              child: InkWell(
                child: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignInPage()),
                    );
                  },
                  elevation: 10,
                  backgroundColor: primaryColour,
                  label: Text(
                    "SIGN IN",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans',
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            RichText(
                text: TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                        );
                      },
                    text: 'SKIP LOGIN',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 12,
                      fontFamily: 'OpenSans',
                    ))),
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: 'By creating an account, you are agreeing to our\n',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'OpenSans',
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return DialougePop(mdFileName: "tnc.md");
                                  });
                            },
                          text: 'Terms & Conditions',
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 12,
                            fontFamily: 'OpenSans',
                          )),
                      TextSpan(text: " and "),
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return DialougePop(
                                        mdFileName: "privacy.md");
                                  });
                            },
                          text: 'Privacy Policy',
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 12,
                            fontFamily: 'OpenSans',
                          ))
                    ]))
          ],
        ),
      ),
    );
  }
}
