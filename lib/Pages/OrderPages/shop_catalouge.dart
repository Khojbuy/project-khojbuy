import 'package:Khojbuy/Constants/colour.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Khojbuy/Pages/OrderPages/image_viewer.dart';

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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            menu[index]['Image'] == ''
                                ? Container(
                                    height: 100,
                                    width: 100,
                                    margin:
                                        EdgeInsets.only(left: 16, bottom: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.no_photography_rounded,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ImageViewer(
                                                menu[index]['Image'])),
                                      );
                                    },
                                    child: Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      margin:
                                          EdgeInsets.only(left: 16, bottom: 6),
                                      child: CachedNetworkImage(
                                        imageUrl: menu[index]['Image'],
                                        fadeInCurve: Curves.easeIn,
                                        fit: BoxFit.fill,
                                        fadeOutDuration:
                                            Duration(microseconds: 100),
                                        progressIndicatorBuilder: (context, url,
                                                downloadProgress) =>
                                            Container(
                                                height: 10,
                                                child:
                                                    CircularProgressIndicator(
                                                        value: downloadProgress
                                                            .progress)),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                Container(
                                  height: 75,
                                  width:
                                      MediaQuery.of(context).size.shortestSide *
                                          0.5,
                                  child: Text(
                                    menu[index]['Detail'],
                                    maxLines: 5,
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontFamily: 'OpenSans',
                                        fontSize: 12),
                                  ),
                                ),
                              ],
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
                      ],
                    ),
                  );
                }),
      ),
    );
  }
}
