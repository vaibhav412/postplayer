import 'package:flutter/material.dart';
import 'package:post_player/screens/drawer_screen.dart';

class ContactPage extends StatelessWidget {
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
        backgroundColor: Colors.transparent.withOpacity(0.4),
        drawer: DrawerScreen(),
        appBar: AppBar(
          title: Text(
            'Contact Us',
            style: TextStyle(
              fontFamily: 'Montserrat',
            ),
          ),
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Container(
                height: 100,
                width: 100,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: Text(
                'Let\'s connect',
                style: TextStyle(
                  fontSize: 40,
                  fontFamily: 'Montserrat',
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Icon(
                    Icons.account_circle,
                    size: 30,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Text(
                      'Dheeraj Shrivastava',
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Icon(
                    Icons.call,
                    size: 30,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    '8808972801',
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Icon(
                    Icons.mail,
                    size: 30,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Text(
                      'jhansipost2016@gmail.com',
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 30,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Text(
                      'Avas Vikas, Jhansi',
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
