import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rhythmcare/navigation.dart';
import 'package:rhythmcare/screens/reset_password_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  // const LoginScreen({Key key}) : super(key: key);
  static const routeName = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var email;
  var password;

  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  void signIn() async {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();

      EasyLoading.show(status: 'processing...');

      try {
        // print('Form is valid.');
        final user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        // print('Signed in: ${user.user!.uid}');

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', email);

        EasyLoading.dismiss();

        Navigator.of(context).pushReplacementNamed(Navigation.routeName);
      } catch (error) {
        EasyLoading.dismiss();

        print('$error');
        String errorCode = (error as FirebaseAuthException).code;
        if (errorCode == 'invalid-email') {
          Fluttertoast.showToast(
            msg: 'Please use a valid email address.',
            toastLength: Toast.LENGTH_LONG,
          );
        } else if (errorCode == 'user-not-found' ||
            errorCode == 'wrong-password') {
          Fluttertoast.showToast(
            msg: 'Fail to login: please check your email address or password.',
            toastLength: Toast.LENGTH_LONG,
          );
        } else {
          Fluttertoast.showToast(
            msg: 'Login failed! Please try again later or contact support.',
            toastLength: Toast.LENGTH_LONG,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[200],
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.teal[900],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // icon
              Text(
                'Rhythm Care',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Flexible(
                child: SizedBox(
                  height: 50.0,
                ),
              ),

              Card(
                child: Container(
                  height: 330.0,
                  width: 300.0,
                  padding: EdgeInsets.all(10.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        // user name
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Email'),
                          keyboardType: TextInputType.emailAddress,
                          // autofillHints: [AutofillHints.email],
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter email address';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            email = value;
                          },
                        ),

                        // password
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter password';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            password = value;
                          },
                        ),

                        SizedBox(
                          height: 10.0,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, ResetPasswordScreen.routeName);
                              },
                              child: Text(
                                'Forgot your password?',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 20.0,
                        ),

                        ElevatedButton(
                          onPressed: () {
                            signIn();
                          },
                          child: Text('Login'),
                        ),

                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed(RegisterScreen.routeName);
                          },
                          child: Text('Register an account >'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
