import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rhythmcare/services/add_record.dart';

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
    return Scaffold(
      backgroundColor: Colors.purple[100],
      appBar: AppBar(
        title: Text('RhythmCare Home Screen'),
        backgroundColor: Colors.purple[900],
      ),
      body: SafeArea(
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
                  await AddUserRecord().addUserRecord(text);
                  Navigator.pop(context);
                },
                child: Text(
                  "Add User",
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
                },
                child: Text('Sign out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
