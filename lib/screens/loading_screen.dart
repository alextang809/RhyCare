import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'login_screen.dart';
import '../navigation.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  void initializeApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    // print(email);
    if (email != null) {
      FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
      await _firebaseAuth.currentUser!.reload();
    }

    await Future.delayed(Duration(seconds: 1));
    if (email == null) {
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    } else {
      Navigator.pushReplacementNamed(context, Navigation.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: double.infinity,
            ),
            Expanded(
              flex: 22,
              child: Image.asset(
                'images/icon.png',
                scale: 4.0,
              ),
            ),
            Expanded(
              flex: 14,
              child: SpinKitCubeGrid(
                color: Colors.teal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
