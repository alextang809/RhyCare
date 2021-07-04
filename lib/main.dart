import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rhythmcare/screens/change_password_screen.dart';
import 'package:rhythmcare/screens/change_email_screen.dart';
import 'package:rhythmcare/screens/email_verify_screen.dart';
import 'package:rhythmcare/screens/reset_password_screen.dart';
import 'package:rhythmcare/screens/setting_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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
  // print(email);
  if (email != null) {
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    await _firebaseAuth.currentUser!.reload();
  }
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
        EmailVerifyScreen.routeName: (context) => EmailVerifyScreen(),
        ChangePasswordScreen.routeName: (context) => ChangePasswordScreen(),
        ChangeEmailScreen.routeName: (context) => ChangeEmailScreen(),
        ResetPasswordScreen.routeName: (context) => ResetPasswordScreen(),
        // HomeScreen.routeName: (context) => HomeScreen(),
        // RecordScreen.routeName: (context) => RecordScreen(),
      },
      builder: EasyLoading.init(),
    ),
  );
}
