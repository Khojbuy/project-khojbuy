import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StoryPage extends StatefulWidget {
  final QueryDocumentSnapshot storyList;
  StoryPage(this.storyList);
  @override
  _StoryPageState createState() => _StoryPageState(storyList);
}

class _StoryPageState extends State<StoryPage> {
  QueryDocumentSnapshot storyList;
  _StoryPageState(this.storyList);
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //appBar: AppBar(),
        //backgroundColor: Colors.black,
        body: Center(
      child: Text(storyList['name']),
    )
        /* PageView.builder(
          controller: _pageController,
          itemBuilder: (context, index) {
            return Stack(
              fit: StackFit.loose,
              children: [CachedNetworkImage(imageUrl: null)],
            );
          }), */
        );
  }
}
