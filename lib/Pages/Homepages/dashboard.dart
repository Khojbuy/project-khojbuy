import 'package:Khojbuy/Constants/categories.dart';
import 'package:Khojbuy/Widgets/card.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.longestSide;
    var width = MediaQuery.of(context).size.shortestSide;
    return SingleChildScrollView(
      child: Column(
        children: [
          sendRequestCard(height, width, context),
          Container(
            height: height * 0.2,
            child: ListView.builder(
                itemCount: categories.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(4.0),
                    child: categoryCard(
                        context, categories[index], catImages[index]),
                  );
                }),
          ),
          Container(
            padding: EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                Text(
                  "Shops near me",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontFamily: 'Opensans',
                      fontSize: height * 0.042,
                      color: Colors.black,
                      fontWeight: FontWeight.w700),
                ),
                SingleChildScrollView(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 10,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return Container(
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/getstarted.jpg',
                                height: 100,
                                width: 100,
                                fit: BoxFit.contain,
                              ),
                              Text("Shop Name")
                            ],
                          ),
                        );
                      }),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
