import 'package:Khojbuy/Constants/colour.dart';
import 'package:Khojbuy/Services/authservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final formkey = new GlobalKey<FormState>();
  String name, city, phnNo;

  String verificationId, smsCode;
  bool codeSent = false;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          padding: EdgeInsets.all(10.0),
          height: height,
          width: width,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.longestSide * 0.2,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: height * 0.15,
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
                codeSent
                    ?
                    //after OTP sent
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PinCodeTextField(
                            appContext: context,
                            length: 6,
                            pastedTextStyle: TextStyle(
                              color: tertiaryColour,
                              fontWeight: FontWeight.bold,
                            ),
                            obscureText: true,
                            obscuringCharacter: '*',
                            animationType: AnimationType.fade,
                            validator: (v) {
                              if (v.length < 6 || v.length > 6) {
                                return "Enter an valid OTP";
                              } else {
                                return null;
                              }
                            },
                            pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(8.0),
                                activeColor: primaryColour,
                                inactiveColor: secondaryColour,
                                fieldHeight:
                                    MediaQuery.of(context).size.shortestSide *
                                        0.15,
                                fieldWidth:
                                    MediaQuery.of(context).size.shortestSide *
                                        0.1,
                                inactiveFillColor: fifthColour,
                                activeFillColor: Colors.white),
                            cursorColor: primaryColour,
                            animationDuration: Duration(milliseconds: 300),
                            textStyle: TextStyle(
                                fontSize: 20,
                                height: 1.6,
                                fontFamily: 'OpenSans'),
                            boxShadows: [
                              BoxShadow(
                                offset: Offset(0, 1),
                                color: Colors.black12,
                                blurRadius: 10,
                              )
                            ],
                            onChanged: (value) {
                              setState(() {
                                this.smsCode = value;
                              });
                            }),
                      )
                    :
                    //Details Input Page
                    Form(
                        key: formkey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                initialValue: name,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 15.0, 20.0, 15.0),
                                    hintText: "John Doe",
                                    labelText: "Enter your full name",
                                    border: new OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0)),
                                    labelStyle: TextStyle(
                                      color: primaryColour,
                                      fontFamily: 'OpenSans',
                                      fontSize: 16,
                                    ),
                                    hintStyle: TextStyle(
                                      fontFamily: 'OpenSans',
                                      fontSize: 16,
                                    )),
                                onSaved: (value) {
                                  setState(() {
                                    this.name = value;
                                  });
                                },
                                validator: (val) {
                                  if (val.length == 0) {
                                    return "Name cannot be empty";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButtonFormField(
                                  items: ["Angul", "Sambalpur"]
                                      .map((String category) {
                                    return new DropdownMenuItem(
                                        value: category,
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              category,
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ));
                                  }).toList(),
                                  decoration: InputDecoration(
                                      hintText: "Enter Your City",
                                      hintStyle: TextStyle(
                                        color: primaryColour,
                                        fontFamily: 'OpenSans',
                                        fontSize: 16,
                                      ),
                                      contentPadding: EdgeInsets.fromLTRB(
                                          20.0, 15.0, 20.0, 15.0),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(32.0)),
                                      fillColor: Colors.white),
                                  onChanged: (val) {
                                    setState(() {
                                      this.city = val;
                                    });
                                  }),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                initialValue: phnNo,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 15.0, 20.0, 15.0),
                                    hintText: "94372XXXXX",
                                    labelText: "Enter your contact number",
                                    border: new OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0)),
                                    labelStyle: TextStyle(
                                      color: primaryColour,
                                      fontFamily: 'OpenSans',
                                      fontSize: 16,
                                    ),
                                    hintStyle: TextStyle(
                                      fontFamily: 'OpenSans',
                                      fontSize: 16,
                                    )),
                                onSaved: (value) {
                                  setState(() {
                                    this.phnNo = '+91' + value;
                                  });
                                },
                                // ignore: missing_return
                                validator: (val) {
                                  if (val.length == 0 || val.length != 10) {
                                    return "Phone number is not validr";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            //City chooseing
                            // textBox("94372XXXXX", "Contact Number",
                            //   TextInputType.phone, phnNo) //Mobile Number
                          ],
                        )),
                //Button
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: RaisedButton(
                    onPressed: () {
                      if (!codeSent) {
                        formkey.currentState.validate();
                        formkey.currentState.save();
                        verifyPhone(phnNo);
                      } else {
                        createUser();
                      }
                    },

                    child: Text(
                      codeSent ? "Sign IN" : "Send OTP",
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    elevation: 20,
                    autofocus: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    color: secondaryColour, // validate phn no
                  ),
                ),
                codeSent
                    ? Container(
                        child: Container(
                          child: RichText(
                              text: TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      verifyPhone(phnNo);
                                    },
                                  text: 'RESEND OTP',
                                  style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      fontSize: 10,
                                      color: Colors.blue,
                                      fontStyle: FontStyle.italic))),
                        ),
                      )
                    : Container(),
                loading
                    ? Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }

  createUser() async {
    await AuthService().signInwithOTPSeller(
        smsCode, verificationId, context, name, city, phnNo);
  }

  Future<void> verifyPhone(String phnNo) async {
    setState(() {
      this.loading = true;
    });
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      AuthService().signInSeller(authResult, context, name, city, phnNo);
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) async {
      setState(() {
        this.codeSent = true;
        this.loading = false;
        print("code sent to " + phnNo);
      });
      this.verificationId = verId;
    };
    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phnNo,
      timeout: const Duration(seconds: 60),
      verificationCompleted: verified,
      verificationFailed: verificationFailed,
      codeSent: smsSent,
      codeAutoRetrievalTimeout: autoTimeout,
    );
  }
}
