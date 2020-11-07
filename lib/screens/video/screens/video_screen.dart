import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoScreen extends StatefulWidget {
  final String id;
  final String title;

  VideoScreen({this.id, this.title});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _controller = YoutubePlayerController(
      initialVideoId: widget.id,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
      ),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
        // drawer: DrawerScreen(),
        backgroundColor: Colors.transparent.withOpacity(0.4),
        appBar: AppBar(
          centerTitle: true,
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
                  child: Image.asset(
                    'assets/images/live.png',
                    height: 22,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Stack(
          children: [
            ListView(
              children: [
                Card(
                  margin: EdgeInsets.only(top: 40.0, left: 20, right: 20),
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        YoutubePlayer(
                          controller: _controller,
                          liveUIColor: Color(0xff072ac8),
                          showVideoProgressIndicator: true,
                          progressColors: ProgressBarColors(
                              handleColor: Color(0xff072ac8),
                              playedColor: Color(0xff072ac8)),
                          onReady: () {
                            print('Player is ready.');
                          },
                        ),
                        Divider(
                          height: 50,
                          indent: 20,
                          endIndent: 20,
                          thickness: 2.0,
                          color: Color(0xff072ac8),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text(
                            widget.title,
                            style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Divider(
                          height: 50,
                          indent: 20,
                          endIndent: 20,
                          thickness: 2.0,
                          color: Color(0xff072ac8),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
          ),
        );
      },
    );
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
