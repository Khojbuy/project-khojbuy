import 'package:Khojbuy/Constants/categories.dart';
import 'package:Khojbuy/Constants/colour.dart';
import 'package:Khojbuy/Pages/RequestPages/add_request.dart';
import 'package:flutter/material.dart';

class CategoriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.shortestSide;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: primaryColour,
          title: Text(
            "Khojbuy",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.shortestSide * 0.1),
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Choose the category where you want to send request',
                      style: TextStyle(
                          color: primaryColour,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.1),
                    ),
                  )),
              Expanded(
                flex: 3,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: 16,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddRequestPage(
                                    categories[index].toString())),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 2,
                            color: secondaryColour.withOpacity(0.15),
                            child: ListTile(
                                dense: true,
                                title: Text(
                                  categories[index].toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: primaryColour,
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.bold,
                                      fontSize: width * 0.06),
                                )),
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        ));
  }
}
