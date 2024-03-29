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
                sensitivity: 1.0,
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
                    child: Text('Swipe Up',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w600))),
                body: Stack(
                  children: [
                    StoryView(
                      progressPosition: ProgressPosition.top,
                      repeat: true,
                      controller: storyController,
                      storyItems: storyItems,
                      onComplete: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Positioned(
                      top: 50,
                      left: 20,
                      child: Text(
                        storyList.data()['name'] +
                            '\n' +
                            storyList.data()['category'],
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: 'OpenSans',
                            color: Colors.white,
                            fontSize: 16),
                      ),
                    )
                  ],
                ))));
  }
}
