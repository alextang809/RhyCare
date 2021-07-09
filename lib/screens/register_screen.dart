import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rhythmcare/components/record.dart';
import 'package:rhythmcare/navigation.dart';
import 'package:rhythmcare/screens/email_verify_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  // const LoginScreen({Key key}) : super(key: key);
  static const routeName = 'signup_screen';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var email;
  var password;

  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  TextEditingController passwordController = new TextEditingController();

  void signUp() async {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();

      EasyLoading.show(status: 'processing...');

      try {
        // print('Form is valid.');
        final userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        final user = userCredential.user;

        await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
          'userId': user.uid,
          'email': user.email,
          'google_sign_in': 'false',  // If a user can register, it is for sure that he hasn't signed in with Google before.
        });

        // print('Registered user: ${userCredential.user!.uid}');

        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // prefs.setString('email', email);

        EasyLoading.dismiss();

        Fluttertoast.showToast(
          msg: 'Please verify your email address!',
          toastLength: Toast.LENGTH_SHORT,
        );
        // sleep(Duration(seconds: 1));
        Navigator.of(context).pushReplacementNamed(EmailVerifyScreen.routeName);
      } catch (error) {
        EasyLoading.dismiss();
        
        print('$error');
        String errorCode = (error as FirebaseAuthException).code;
        if (errorCode == 'email-already-in-use') {
          Fluttertoast.showToast(
            msg: 'The email address already exists. If you are the owner of this email address, please use the "Forgot your password?" function on the Login page to reset a password!',
            toastLength: Toast.LENGTH_LONG,
          );
          Fluttertoast.showToast(
            msg: 'The email address already exists. If you are the owner of this email address, please use the "Forgot your password?" function on the Login page to reset a password!',
            toastLength: Toast.LENGTH_LONG,
          );
          Fluttertoast.showToast(
            msg: 'The email address already exists. If you are the owner of this email address, please use the "Forgot your password?" function on the Login page to reset a password!',
            toastLength: Toast.LENGTH_LONG,
          );
        } else if (errorCode == 'invalid-email') {
          Fluttertoast.showToast(
            msg: 'Please use a valid email address.',
            toastLength: Toast.LENGTH_LONG,
          );
        } else {
          Fluttertoast.showToast(
            msg: 'Register failed! Please try again later or contact support.',
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
        title: Text('Signup'),
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
                  height: 390.0,
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'email address cannot be empty';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            email = value;
                          },
                        ),

                        // password
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Password (at least six characters)'),
                          obscureText: true,
                          controller: passwordController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'password cannot be empty';
                            } else if (value.length < 6) {
                              return 'password must have at least six characters';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            password = value;
                          },
                        ),

                        // confirm password
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Confirm Password'),
                          obscureText: true,
                          validator: (value) {
                            if (value == null ||
                                value != passwordController.text) {
                              return 'password does not match';
                            }
                            return null;
                          },
                          onSaved: (value) {},
                        ),

                        SizedBox(
                          height: 30.0,
                        ),

                        ElevatedButton(
                          onPressed: () {
                            signUp();
                          },
                          child: Text('Register'),
                        ),

                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed(LoginScreen.routeName);
                          },
                          child: Text('< Go back to login'),
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
