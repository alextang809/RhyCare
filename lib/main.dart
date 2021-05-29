import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      title: 'RhythmCare',
      initialRoute: LoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (context) => LoginScreen(),
        SignupScreen.routeName: (context) => SignupScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
      },
    ),
  );
}
