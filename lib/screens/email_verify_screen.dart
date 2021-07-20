import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rhythmcare/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rhythmcare/navigation.dart';

class EmailVerifyScreen extends StatefulWidget {
  const EmailVerifyScreen({Key? key}) : super(key: key);

  static const routeName = 'verify_screen';

  @override
  _EmailVerifyScreenState createState() => _EmailVerifyScreenState();
}

class _EmailVerifyScreenState extends State<EmailVerifyScreen> {
  User? user;
  Timer? timer;
  bool verified = false;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  DateTime? currentBackPressTime;
  int popCount = 0;

  Future<void> checkEmailVerified() async {
    await user!.reload();
    user = _firebaseAuth
        .currentUser; // call currentUser again, otherwise emailVerified is still false
    // print('33333');
    // print('${user!.emailVerified}');
    if (user!.emailVerified) {
      timer!.cancel();
      updateUserInfo(); // TODO: potential bugs
      // print('44444');
      setState(() {
        // print('55555');
        verified = true;
      });
    }
  }

  static Future<void> updateUserInfo() async {
    EasyLoading.show(status: 'Just a moment...');
    final user = FirebaseAuth.instance.currentUser;
    // await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
    //   'userId': user.uid,
    //   'verified_email': user.email,
    //   'google_sign_in': 'false',
    // });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', 'VERIFIED');
    EasyLoading.dismiss();
  }

  @override
  void initState() {
    user = _firebaseAuth.currentUser;
    user!.sendEmailVerification();
    timer = Timer.periodic(Duration(seconds: 3), (timer) async {
      // print('11111');
      await checkEmailVerified();
      // print('22222');
    });
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  Widget body(bool verified) {
    if (!verified) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            'A verification email has been sent to\n${user!.email}',
            textAlign: TextAlign.center,
          ),
          TextButton(
            onPressed: () {
              timer!.cancel();
              // Fluttertoast.showToast(
              //   msg:
              //   'You will be auto signed out after one minute!',
              //   toastLength: Toast.LENGTH_LONG,
              // );
              Navigator.of(context)
                  .pushReplacementNamed(Navigation.p2RouteName);
            },
            child: Text('skip for now >'),
          )
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            'Your email has been verified!',
          ),
          ElevatedButton(
            onPressed: () async {
              await updateUserInfo();
              Navigator.of(context)
                  .pushReplacementNamed(Navigation.p2RouteName);
            },
            child: Text('Continue'),
          ),
        ],
      );
    }
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    popCount++;
    if (popCount >= 3) {
      return Future.value(false);
    }
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(microseconds: 10)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
        msg:
            'Please remain on this screen when verifying or press skip for now to verify later.',
        toastLength: Toast.LENGTH_SHORT,
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[200],
      appBar: AppBar(
        title: Text('Email Verification'),
        backgroundColor: Colors.teal[900],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: WillPopScope(
              child: body(verified),
              onWillPop: onWillPop,
            ),
          ),
        ),
      ),
    );
  }
}
