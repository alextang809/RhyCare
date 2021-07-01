import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rhythmcare/screens/change_password_screen.dart';
import 'package:rhythmcare/screens/change_email_screen.dart';
import 'email_verify_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  Color? buttonColor = Colors.purple[50];

  Widget emailStatus() {
    if (!user!.emailVerified) {
      return Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  Icons.cancel_rounded,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text('Please verify your email before using other services'),
              ],
            ),
            ElevatedButton(
              child: Text('Verify Email'),
              onPressed: () {
                Navigator.pushReplacementNamed(
                    context, EmailVerifyScreen.routeName);
              },
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
            SizedBox(
              width: 5.0,
            ),
            Text('Your email has been verified'),
          ],
        ),
      );
    }
  }

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
          GestureDetector(
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
              height: 40.0,
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('EMAIL'),
                  Row(
                    children: [
                      Text('${user!.email}'),
                      Icon(Icons.arrow_forward_ios_rounded),
                    ],
                  ),
                ],
              ),
            ),
          ),
          emailStatus(),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, ChangePasswordScreen.routeName)
                  .then((value) => setState(() {
                        user = _firebaseAuth.currentUser;
                      }));
            },
            child: Container(
              width: double.infinity,
              color: buttonColor,
              height: 40.0,
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Change Password'),
                  Icon(Icons.arrow_forward_ios_rounded),
                ],
              ),
            ),
          ),
          SizedBox(),
          ElevatedButton(
            onPressed: () async {
              await _firebaseAuth.signOut();

              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('email');

              Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
            },
            child: Text('Sign out'),
          ),
        ],
      ),
    );
  }
}
