import 'package:flutter/material.dart';
import 'package:rhythmcare/screens/change_password_screen.dart';
import 'package:rhythmcare/screens/change_email_screen.dart';
import 'package:rhythmcare/screens/email_verify_screen.dart';
import 'package:rhythmcare/screens/loading_screen.dart';
import 'package:rhythmcare/screens/reset_password_screen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'navigation.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MaterialApp(
        title: 'RhythmCare',
        theme: ThemeData.light().copyWith(
          primaryColor: Colors.purple,
          scaffoldBackgroundColor: Colors.purple,
        ),
        home: LoadingScreen(), // check user has logged in or not
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
}
