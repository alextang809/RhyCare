import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/record_screen.dart';
import 'navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  print(email);
  runApp(
    MaterialApp(
      title: 'RhythmCare',
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.purple,
        scaffoldBackgroundColor: Colors.purple,
      ),
      home: email == null ? LoginScreen() : Navigation(),  // check user has logged in or not
      routes: {
        LoginScreen.routeName: (context) => LoginScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        Navigation.routeName: (context) => Navigation(),
        // HomeScreen.routeName: (context) => HomeScreen(),
        // RecordScreen.routeName: (context) => RecordScreen(),
      },
    ),
  );
}
