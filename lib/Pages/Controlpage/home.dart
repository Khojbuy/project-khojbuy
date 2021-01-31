import 'package:Khojbuy/Constants/colour.dart';
import 'package:Khojbuy/Pages/Homepages/dashboard.dart';
import 'package:Khojbuy/Pages/Homepages/notification.dart';
import 'package:Khojbuy/Pages/Homepages/orders.dart';
import 'package:Khojbuy/Pages/Homepages/profile.dart';
import 'package:Khojbuy/Pages/Homepages/requests.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

List<dynamic> pageList = [
  DashboardPage(),
  OrdersPage(),
  RequestPage(),
  ProfilePage()
];

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _index = 0;
  double gap = 10;
  var padding = EdgeInsets.symmetric(horizontal: 18, vertical: 5);
  PageController _pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primaryColour,
        title: Text(
          "Khojbuy",
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.shortestSide * 0.1),
        ),
        leading: Container(
          padding: EdgeInsets.all(6.0),
          child: Image.asset(
            'assets/images/logo.png',
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
                icon: Icon(
                  Icons.notifications,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Notifications()),
                  );
                }),
          )
        ],
      ),
      body: PageView.builder(
          itemCount: 4,
          controller: _pageController,
          onPageChanged: (page) {
            pageChanged(page);
          },
          itemBuilder: (context, position) {
            return pageList[position];
          }),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.longestSide * 0.08,
          decoration: BoxDecoration(color: primaryColour, boxShadow: [
            BoxShadow(
              spreadRadius: -10,
              blurRadius: 60,
              color: Colors.black.withOpacity(0.4),
              offset: Offset(0, 25),
            )
          ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: GNav(
              curve: Curves.fastOutSlowIn,
              duration: Duration(milliseconds: 500),
              tabs: [
                tabButton("Home", Icons.home_filled),
                tabButton("Order", Icons.shopping_bag_rounded),
                tabButton("Request", Icons.shopping_cart_rounded),
                tabButton("Profile", Icons.person_rounded)
              ],
              selectedIndex: _index,
              onTabChange: (index) {
                pageChanged(index);
                _pageController.jumpToPage(index);
              },
            ),
          ),
        ),
      ),
    );
  }

  pageChanged(int index) {
    setState(() {
      _index = index;
    });
  }

  tabButton(String name, IconData iconData) {
    return GButton(
      gap: gap,
      icon: iconData,
      iconColor: Colors.white,
      iconActiveColor: fifthColour,
      text: name,
      textColor: Colors.white,
      textStyle: TextStyle(fontFamily: 'OpenSans', color: Colors.white),
      backgroundColor: secondaryColour.withOpacity(0.5),
      iconSize: 24,
      padding: padding,
    );
  }
}
