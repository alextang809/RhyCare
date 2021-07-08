import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:rhythmcare/screens/change_password_screen.dart';
import 'package:rhythmcare/screens/change_email_screen.dart';
import 'email_verify_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../navigation.dart';

import 'login_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  bool? _signedInWithGoogle;
  User? user = FirebaseAuth.instance.currentUser;
  Color? buttonColor = Colors.purple[50];

  Widget emailStatus() {
    if (!user!.emailVerified) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.cancel_rounded,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 5.0,
                ),
                Container(
                  child: Flexible(
                    child: Text(
                      'Please verify your email before using other services. If not verified, your account could be removed after exiting this app and you would need to register a new account. Press "Refresh" if you have verified.',
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, ChangeEmailScreen.routeName)
                        .then((value) => setState(() {
                              user = _firebaseAuth.currentUser;
                              // print('${user!.email}');
                            }));
                  },
                  child: Text(
                    'Change your email?',
                    style: TextStyle(
                      fontSize: 14.0,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  child: Text('Verify'),
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, EmailVerifyScreen.routeName);
                  },
                ),
                ElevatedButton(
                  child: Text('Refresh'),
                  onPressed: () async {
                    EasyLoading.show();
                    await user!.reload();
                    user = _firebaseAuth.currentUser;
                    if (user!.emailVerified) {
                      // await FirebaseFirestore.instance
                      //     .collection('users')
                      //     .doc(user!.uid)
                      //     .set({
                      //   'userId': user!.uid,
                      //   'verified_email': user!.email,
                      //   'google_sign_in': 'false',
                      // });
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString('email', 'VERIFIED');
                      EasyLoading.dismiss();
                      Navigator.pushNamedAndRemoveUntil(context, Navigation.p2RouteName, (route) => false);
                    }
                    EasyLoading.dismiss();
                    setState(() {});
                  },
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      if (_signedInWithGoogle!) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
              SizedBox(
                width: 5.0,
              ),
              Flexible(
                child: Text(
                  'Your have signed in with Google',
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
              SizedBox(
                width: 5.0,
              ),
              Flexible(
                child: Text(
                  'Your email has been verified',
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        );
      }
    }
  }

  Widget changeEmailAddress(BuildContext context) {
    // user will only be allowed to change email address if he has not verified it
    double screen_width = MediaQuery.of(context).size.width;

    if (false) {
      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, ChangeEmailScreen.routeName)
              .then((value) => setState(() {
                    user = _firebaseAuth.currentUser;
                    // print('${user!.email}');
                  }));
        },
        child: Container(
          width: double.infinity,
          color: Colors.purple[50],
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          margin: EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('EMAIL'),
              SizedBox(
                width: 5.0,
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: screen_width * 0.5,
                    child: Text(
                      '${user!.email}',
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        color: Colors.purple[50],
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 13.0),
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('EMAIL'),
            SizedBox(
              width: 5.0,
            ),
            Row(
              children: <Widget>[
                Container(
                  width: screen_width * 0.5,
                  child: Text(
                    '${user!.providerData[0].email}',
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  // @override
  // void initState() {
  // User? user = FirebaseAuth.instance.currentUser;
  // user!.reload().then((value) {
  //   setState(() {});
  // });
  //   super.initState();
  // }

  Widget body() {
    if (_signedInWithGoogle == null) {
      SharedPreferences.getInstance().then((prefs) {
        _signedInWithGoogle = (prefs.get('google') == 'true');
        Future.delayed(Duration(milliseconds: 150)).then((value) {
          setState(() {});
        });
      });
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.purple,
        ),
      );
    } else {
      double screen_height = MediaQuery.of(context).size.height;
      return SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Settings Page',
                style: TextStyle(fontSize: 30.0),
              ),
              SizedBox(
                height: screen_height * 0.1,
              ),
              Column(
                children: <Widget>[
                  changeEmailAddress(context),
                  Container(
                    child: emailStatus(),
                    color: Colors.transparent,
                  ),
                  Visibility(
                    visible: !_signedInWithGoogle!,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                                context, ChangePasswordScreen.routeName)
                            .then((value) => setState(() {
                                  user = _firebaseAuth.currentUser;
                                }));
                      },
                      child: Container(
                        width: double.infinity,
                        color: buttonColor,
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 8.0),
                        margin: EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Change Password'),
                            Icon(Icons.arrow_forward_ios_rounded),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screen_height * 0.2,
              ),
              ElevatedButton(
                onPressed: () async {
                  EasyLoading.show(status: 'signing out...');

                  print(_signedInWithGoogle);
                  print('22222222222222');
                  // print(GoogleSignIn().currentUser);
                  if (_signedInWithGoogle!) {
                    await googleSignIn.signOut();
                    (await SharedPreferences.getInstance()).remove('google');
                  }
                  await _firebaseAuth.signOut().then((value) async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.remove('email');
                    EasyLoading.dismiss();

                    Navigator.of(context)
                        .pushReplacementNamed(LoginScreen.routeName);
                  });
                },
                child: Text('Sign out'),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return body();
  }
}
