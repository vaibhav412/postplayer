// ignore: avoid_web_libraries_in_flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:post_player/screens/drawer_screen.dart';
import 'package:post_player/screens/photo_page.dart';
import 'package:post_player/screens/video/screens/home_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/HomePage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/backimage.jpeg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent.withOpacity(0.4),
        drawer: DrawerScreen(),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 1,
                ),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 50,
                    ),
                    Column(
                      children: [
                        Text(
                          'Post Player',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        Text(
                          'Jhansi Post Exclusive',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    launch('https://www.facebook.com/creativedheeraj/live/');
                  },
                  child: Image.asset(
                    'assets/images/live.png',
                    height: 22,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            TabBar(
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.white,
              ),
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.white,
              labelStyle: TextStyle(
                  fontSize: 17,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700),
              unselectedLabelStyle: TextStyle(
                fontSize: 17,
                fontFamily: 'Montserrat',
              ),
              tabs: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(width: 1, color: Colors.white),
                  ),
                  child: Text(
                    'Photos',
                    style: TextStyle(fontFamily: 'Montserrat'),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(width: 1, color: Colors.white),
                  ),
                  child: Text(
                    'Videos',
                    style: TextStyle(fontFamily: 'Montserrat'),
                  ),
                ),
              ],
              controller: _tabController,
            ),
            SizedBox(
              height: 18,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  PhotosPage(),
                  HomeScreen(),
                ],
                controller: _tabController,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 104,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: MyBlinkingText(),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    _buildPhoto(context)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoto(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('bannerphoto')
          .orderBy('createdOn', descending: true)
          .limit(1)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        final photos = snapshot.data.documents;
        String photourl;
        for (var photo in photos) {
          final url = photo.data['url'];
          photourl = url;
        }
        return Container(
          height: 75,
          width: double.infinity,
          child: Image.network(
            photourl,
            fit: BoxFit.fill,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent loadingProgress) {
              if (loadingProgress == null) return child;
              return Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes
                        : null,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class MyBlinkingText extends StatefulWidget {
  @override
  _MyBlinkingTextState createState() => _MyBlinkingTextState();
}

class _MyBlinkingTextState extends State<MyBlinkingText>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    _animationController =
        new AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController,
      child: Text(
        "HIGHLIGHTS",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.red,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
