import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:post_player/screens/drawer_screen.dart';
import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AddBannerPage extends StatefulWidget {
  @override
  _AddBannerPageState createState() => _AddBannerPageState();
}

class _AddBannerPageState extends State<AddBannerPage> {
  bool showspinner = false;

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
        appBar: AppBar(
          title: Text(
            "Add Banner Photo",
            style: TextStyle(
              fontFamily: 'Montserrat',
            ),
          ),
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        drawer: DrawerScreen(),
        body: ModalProgressHUD(
          inAsyncCall: showspinner,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: FlatButton(
                  onPressed: () {
                    getImage(context);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Upload Banner Photo',
                      style: TextStyle(
                          color: Colors.black, fontFamily: 'Montserrat'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future getImage(BuildContext context) async {
    // Get image from gallery.
    // ignore: deprecated_member_use

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        // ignore: deprecated_member_use
        var image = await ImagePicker.pickImage(source: ImageSource.gallery);
        setState(() {
          showspinner = true;
        });
        await _uploadImageToFirebase(image, context);
        setState(() {
          showspinner = false;
        });
        showDialogBox(context);
      }
    } on SocketException catch (_) {
      print('not connected');
      showDialogBox2(context);
    }
  }
}

Future<void> _uploadImageToFirebase(File image, BuildContext context) async {
  try {
    // Make random image name.
    int randomNumber = Random().nextInt(10000000);
    String imageLocation = 'bannerphotos/image$randomNumber.jpg';

    // Upload image to firebase.
    final StorageReference storageReference =
        FirebaseStorage().ref().child(imageLocation);
    final StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    _addPathToDatabase(imageLocation, context);
  } catch (e) {
    print(e.message);
    showDialog(
        builder: (context) {
          return AlertDialog(
            content: Text(e.message),
          );
        },
        context: null);
  }
}

Future<void> _addPathToDatabase(String text, BuildContext context) async {
  try {
    // Get image URL from firebase
    final ref = FirebaseStorage().ref().child(text);
    var imageString = await ref.getDownloadURL();
    await Firestore.instance.collection('bannerphoto').document().setData({
      'url': imageString,
      'location': text,
      'createdOn': FieldValue.serverTimestamp()
    });
  } catch (e) {
    print(e.message);
    showDialog(
        builder: (context) {
          return AlertDialog(
            content: Text(e.message),
          );
        },
        context: null);
  }
}

void showDialogBox(BuildContext context) {
  var popup = AlertDialog(
    content: SingleChildScrollView(
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text('Your photo has been successfully added'),
          ),
          SizedBox(
            height: 20,
          ),
          RaisedButton(
            focusElevation: 0,
            highlightElevation: 0,
            splashColor: Colors.white.withOpacity(0.1),
            padding: EdgeInsets.symmetric(vertical: 20),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            color: Color(0xFF4F51C0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              'Okay',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    ),
  );
  // ignore: non_constant_identifier_names
  showDialog(context: context, builder: (BuildContext) => popup);
}

void showDialogBox2(BuildContext context) {
  var popup = AlertDialog(
    content: SingleChildScrollView(
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
                'Failed to add photo. Please check your internet connection.'),
          ),
          SizedBox(
            height: 30,
          ),
          RaisedButton(
            focusElevation: 0,
            highlightElevation: 0,
            splashColor: Colors.white.withOpacity(0.1),
            padding: EdgeInsets.symmetric(vertical: 20),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.redAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              'Okay',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    ),
  );
  // ignore: non_constant_identifier_names
  showDialog(context: context, builder: (BuildContext) => popup);
}
