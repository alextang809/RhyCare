import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:rhythmcare/navigation.dart';
import '../components/record.dart';

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

  Future<void> checkEmailVerified() async {
    await user!.reload();
    user = _firebaseAuth
        .currentUser; // call currentUser again, otherwise emailVerified is still false
    // print('33333');
    // print('${user!.emailVerified}');
    if (user!.emailVerified) {
      timer!.cancel();
      // print('44444');
      setState(() {
        // print('55555');
        verified = true;
      });
    }
  }

  Future<void> createEmptyRecords() async {
    // TODO: check behavior of this method
    final user = _firebaseAuth.currentUser;
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
      'email': user.email,
      'userId': user.uid,
    });

    await FirebaseFirestore.instance
        .collection('records')
        .doc(user.uid)
        .collection("user_records")
        .add(
          Record(
            date_time: '',
            height: '',
            weight: '',
            bmi: '',
          ).toJson(),
        );

    // TODO: add a progress indicator
  }

  @override
  void initState() {
    user = _firebaseAuth.currentUser;
    user!.sendEmailVerification();
    timer = Timer.periodic(Duration(seconds: 4), (timer) async {
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
              Navigator.of(context).pushReplacementNamed(Navigation.routeName);
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
              EasyLoading.show(status: 'just a moment...');
              await createEmptyRecords(); // TODO: check behavior
              EasyLoading.dismiss();
              Navigator.of(context).pushReplacementNamed(Navigation.routeName);
            },
            child: Text('Continue'),
          ),
        ],
      );
    }
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
            child: body(verified),
          ),
        ),
      ),
    );
  }
}
