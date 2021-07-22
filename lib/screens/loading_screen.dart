import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'login_screen.dart';
import '../navigation.dart';

class LoadingScreen extends StatefulWidget {
  static const routeName = 'loading_screen';

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final colorizeColors = [
    Colors.purple,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.red,
  ];

  @override
  void initState() {
    super.initState();
    Future<void> initialization = initializeApp();
    initialization.timeout(
      Duration(seconds: 30),
      onTimeout: () {
        Fluttertoast.showToast(
          msg:
              'Loading is taking longer than normal... You may want to check your Internet connection or try again later.',
          toastLength: Toast.LENGTH_LONG,
        );
        Fluttertoast.showToast(
          msg:
              'Loading is taking longer than normal... You may want to check your Internet connection or try again later.',
          toastLength: Toast.LENGTH_LONG,
        );
      },
    );
  }

  Future<void> initializeApp() async {
    try {
      await Firebase.initializeApp();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var email = prefs.getString('email');
      // print(email);
      if (email != null) {
        FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
        await _firebaseAuth.currentUser!.reload();
      }

      await Future.delayed(Duration(seconds: 2));
      // print(email);
      if (email == null) {
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      } else {
        Navigator.pushReplacementNamed(context, Navigation.p0RouteName);
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: error.toString(),
        toastLength: Toast.LENGTH_SHORT,
      );
      Fluttertoast.showToast(
        msg:
            'Sorry, an error just occurred. Please check your Internet connection and try again later.',
        toastLength: Toast.LENGTH_LONG,
      );
      await Future.delayed(Duration(seconds: 5));
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.orange[50],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Image.asset(
                'images/app_icon_round.png',
                height: 200.0,
                width: 200.0,
              ),
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            AnimatedTextKit(
              animatedTexts: [
                ColorizeAnimatedText(
                  'Rhythm Care',
                  colors: colorizeColors,
                  speed: Duration(milliseconds: 500),
                  textStyle: TextStyle(
                    fontFamily: 'Otomanopee_One',
                    color: Colors.purple,
                    fontSize: 32.0,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * 0.3,
            ),
            SpinKitPouringHourglass(
              color: Colors.blue,
              size: 60.0,
            ),
          ],
        ),
      ),
    );
  }
}
