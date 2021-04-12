import 'package:Khojbuy/Constants/colour.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageViewer extends StatelessWidget {
  final String url;
  ImageViewer(this.url);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColour,
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Center(
              child: CachedNetworkImage(
        imageUrl: url,
        fadeInCurve: Curves.easeIn,
        height: MediaQuery.of(context).size.shortestSide * 0.8,
        width: double.infinity,
        fit: BoxFit.fill,
        fadeOutDuration: Duration(microseconds: 100),
        progressIndicatorBuilder: (context, url, downloadProgress) => Container(
            height: 10,
            child: CircularProgressIndicator(value: downloadProgress.progress)),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ))),
    );
  }
}
