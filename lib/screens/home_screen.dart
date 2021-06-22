import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rhythmcare/services/add_record.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
String text = "";

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const routeName = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Image.asset('images/icon.png'),
            ),
            SizedBox(
              height: 100.0,
            ),
            TextField(
              onChanged: (value) {
                text = value;
                print(text);
              },
            ),
            TextButton(
              onPressed: () async {
                // await AddUserRecord().addUserRecord(text);  // TODO: to implement this function to add a record to the database
                // Navigator.pop(context);
              },
              child: Text(
                "Add Record",
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();

                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('email');

                Navigator.of(context)
                    .pushReplacementNamed(LoginScreen.routeName);
              },
              child: Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }
}
