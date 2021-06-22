import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            'Settings Page',
            style: TextStyle(fontSize: 30.0),
          ),
          SizedBox(),
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
    );
  }
}
