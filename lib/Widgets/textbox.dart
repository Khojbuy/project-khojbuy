import 'package:Khojbuy/Constants/colour.dart';
import 'package:flutter/material.dart';

Widget textBox(
    String hint, String label, TextInputType type, dynamic variable) {
  return StatefulBuilder(builder: (context, function) {
    return TextFormField(
      initialValue: variable,
      keyboardType: type,
      decoration: InputDecoration(
          hintText: hint,
          labelText: label,
          border:
              new OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
          labelStyle: TextStyle(
            color: primaryColour,
            fontFamily: 'OpenSans',
            fontSize: 14,
          ),
          hintStyle: TextStyle(
            color: Colors.grey,
            fontFamily: 'OpenSans',
            fontSize: 14,
          )),
      onChanged: (value) {
        variable = value;
      },
    );
  });
}
