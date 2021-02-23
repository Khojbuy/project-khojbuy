import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/story_view.dart';
import 'package:swipe_up/swipe_up.dart';
import 'package:url_launcher/url_launcher.dart';

class StoryPage extends StatefulWidget {
  final QueryDocumentSnapshot storyList;
  StoryPage(this.storyList);
  @override
  _StoryPageState createState() => _StoryPageState(storyList);
}

class _StoryPageState extends State<StoryPage> {
  QueryDocumentSnapshot storyList;
  _StoryPageState(this.storyList);
  final StoryController storyController = new StoryController();

  @override
  Widget build(BuildContext context) {
    List<StoryItem> storyItems = [];
    for (var item in storyList.data()['stories']) {
      storyItems.add(StoryItem.pageImage(
          url: item['url'],
          imageFit: BoxFit.cover,
          duration: Duration(seconds: 15),
          caption: storyList.data()['name'].toString(),
          controller: storyController));
    }
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
            child: SwipeUp(
          color: Colors.white,
          showArrow: true,
          animate: true,
          expand: true,
          sensitivity: 0.5,
          onSwipe: () async {
            final String phnNo = storyList.data()['contact'];
            final String url =
                'https://api.whatsapp.com/send?phone=$phnNo&text=I%20want%20to%20find%20out%20about%20your%20products';
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          },
          child: Material(
              color: Colors.transparent,
              child: Text('Swipe Up', style: TextStyle(color: Colors.white))),
          body: StoryView(
            progressPosition: ProgressPosition.top,
            repeat: true,
            controller: storyController,
            storyItems: storyItems,
            onComplete: () {
              Navigator.of(context).pop();
            },
          ),
        )));
  }
}
