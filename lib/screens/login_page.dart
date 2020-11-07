import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:post_player/common/platform_exception_alert_dialog.dart';
import 'package:post_player/screens/model/user_info.dart';
import 'package:post_player/services/auth.dart';
import 'package:provider/provider.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final _formKey = GlobalKey<FormState>();

  String firstName;
  String lastName;
  int phoneNumber;
  bool showspinner = false;

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> setData(Map<String, dynamic> data, String uid) async {
    final reference = Firestore.instance.document('users/$uid');
    await reference.setData(data);
  }

  Future<void> signIn(BuildContext context) async {
    if (_validateAndSaveForm()) {
      setState(() {
        showspinner = true;
      });
      try {
        final auth = Provider.of<AuthBase>(context, listen: false);
        final userInfo = UserInfo(
            firstName: firstName, lastName: lastName, phoneNumber: phoneNumber);
        await auth.signInAnonymously();
        String userId = await auth.currentUser();
        await setData(userInfo.toMap(), userId);
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Sign in failed',
          exception: e,
        ).show(context);
      } finally {
        setState(() {
          showspinner = false;
        });
      }
    }
  }

  Future<void> skipSignIn() async {
    setState(() {
      showspinner = true;
    });
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInAnonymously();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Sign in failed',
        exception: e,
      ).show(context);
    } finally {
      setState(() {
        showspinner = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showspinner,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 40.0,
                        right: 40.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Log In',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 35.0,
                                color: Color(0xff072ac8),
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            onSaved: (value) => firstName = value,
                            decoration: InputDecoration(
                              hintText: 'First Name',
                              hintStyle: TextStyle(
                                fontFamily: 'Montserrat',
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide:
                                      BorderSide(color: Color(0xff072ac8))),
                            ),
                            cursorColor: Color(0xff072ac8),
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'First Name can not be empty';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          TextFormField(
                            onSaved: (value) => lastName = value,
                            decoration: InputDecoration(
                              hintText: 'Last Name',
                              hintStyle: TextStyle(
                                fontFamily: 'Montserrat',
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide:
                                      BorderSide(color: Color(0xff072ac8))),
                            ),
                            cursorColor: Color(0xff072ac8),
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Last Name can not be empty';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          TextFormField(
                            onSaved: (value) =>
                                phoneNumber = int.tryParse(value),
                            decoration: InputDecoration(
                              hintText: 'Phone Number',
                              hintStyle: TextStyle(
                                fontFamily: 'Montserrat',
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide:
                                      BorderSide(color: Color(0xff072ac8))),
                            ),
                            cursorColor: Color(0xff072ac8),
                            maxLength: 10,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Phone Number can not be empty';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            color: Color(0xff072ac8),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Montserrat'),
                              ),
                            ),
                            onPressed: () => signIn(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      height: 35,
                      margin: EdgeInsets.only(right: 40.0, top: 20),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Color(0xff072ac8), width: 1.25),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: FlatButton(
                        child: Text(
                          'Skip',
                          style: TextStyle(
                              color: Color(0xff072ac8),
                              fontSize: 15.0,
                              fontFamily: 'Montserrat'),
                        ),
                        onPressed: skipSignIn,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
