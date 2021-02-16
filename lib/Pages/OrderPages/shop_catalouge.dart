import 'package:Khojbuy/Constants/colour.dart';
import 'package:flutter/material.dart';

class Catalouge extends StatelessWidget {
  final List<dynamic> menu;
  Catalouge(this.menu);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primaryColour,
        title: Text(
          'Khojbuy',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.shortestSide * 0.075),
        ),
      ),
      body: SingleChildScrollView(
        child: menu.length == 0
            ? Center(
                child: Text(
                  'The shop has no specific product list uploaded',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black87,
                      fontFamily: 'OpenSans',
                      fontSize: 16),
                ),
              )
            : ListView.builder(
                itemCount: menu.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                menu[index]['ItemName'],
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontFamily: 'OpenSans',
                                    fontSize: 14),
                              ),
                            ),
                            Text(
                              '₹ ' + menu[index]['Price'],
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontFamily: 'OpenSans',
                                  fontSize: 12),
                            ),
                          ],
                        ),
                        Container(
                          child: Text(
                            menu[index]['Detail'],
                            style: TextStyle(
                                color: Colors.black54,
                                fontFamily: 'OpenSans',
                                fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
      ),
    );
  }
}
