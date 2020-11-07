import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:post_player/common/page_routes.dart';
import 'package:post_player/screens/about.dart';
import 'package:post_player/screens/contact.dart';
import 'package:post_player/screens/add_banner.dart';
import 'package:post_player/screens/add_photo.dart';

class DrawerScreen extends StatefulWidget {
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  bool show;
  int phoneNumber;

  Future<void> getDataAndCheckUser() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    if (firebaseUser != null) {
      await Firestore.instance
          .collection("users")
          .document(firebaseUser.uid)
          .get()
          .then((value) {
        print(value.data);
        phoneNumber = value.data['Phone Number'];
      });
      print(phoneNumber);
      if (phoneNumber == 0002051970) {
        setState(() {
          show = true;
        });
      } else {
        setState(() {
          show = false;
        });
      }
    } else {
      setState(() {
        show = false;
      });
    }
  }

  @override
  void initState() {
    getDataAndCheckUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          createDrawerHeader(),
          SizedBox(
            height: 25,
          ),
          createDrawerBodyItem(
            icon: Icons.home,
            text: 'Home',
            onTap: () =>
                Navigator.pushReplacementNamed(context, PageRoutes.home),
          ),
          createDrawerBodyItem(
            icon: Icons.account_circle,
            text: 'About Us',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AboutPage(),
                ),
              );
            },
          ),
          createDrawerBodyItem(
            icon: Icons.contact_phone,
            text: 'Contact Us',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContactPage(),
                ),
              );
            },
          ),
          Divider(),
          if (show == true)
            createDrawerBodyItem(
              icon: Icons.add,
              text: 'Add a Photo',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddPhotoPage(),
                  ),
                );
              },
            ),
          if (show == true)
            createDrawerBodyItem(
              icon: Icons.add,
              text: 'Add a Banner',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddBannerPage(),
                  ),
                );
              },
            ),
          Spacer(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              children: [
                Text(
                  'App version 1.0.0',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget createDrawerHeader() {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(20),
    // color: Color(0xfff3f5ff),
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage("assets/images/backimage.jpeg"),
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(
            Colors.transparent.withOpacity(0.4), BlendMode.srcOver),
      ),
    ),
    child: Center(
      child: Column(
        children: <Widget>[
          Container(
            width: 100,
            height: 100,
            margin: EdgeInsets.only(top: 40, bottom: 30),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(150),
                ),
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget createDrawerBodyItem(
    {IconData icon, String text, GestureTapCallback onTap}) {
  return ListTile(
    contentPadding: EdgeInsets.only(left: 20),
    title: Row(
      children: <Widget>[
        Icon(
          icon,
          size: 22,
          color: Colors.amberAccent[400],
        ),
        Padding(
          padding: EdgeInsets.only(left: 12.0),
          child: Text(
            text,
            style: TextStyle(fontSize: 18, fontFamily: 'Montserrat'),
          ),
        )
      ],
    ),
    onTap: onTap,
  );
}
