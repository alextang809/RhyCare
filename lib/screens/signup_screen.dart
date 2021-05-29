import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  // const LoginScreen({Key key}) : super(key: key);
  static const routeName = '/signup';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var email;
  var password;

  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  TextEditingController passwordController = new TextEditingController();

  void signUp() async {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();

      try {
        print('Form is valid.');
        final user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        print('Registered user: ${user.user!.uid}');
        Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
      } catch (error) {
        print('$error');
        String errorCode = (error as FirebaseAuthException).code;
        if (errorCode == 'email-already-in-use') {
          Fluttertoast.showToast(
            msg: 'The email address already exists! Please login.',
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
              Image.asset(
                'images/icon.png',
                width: 100.0,
              ),

              SizedBox(
                height: 50.0,
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
                              return 'email cannot be empty';
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
                          controller: passwordController,
                          validator: (value) {
                            if (value == null || value.length < 6) {
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
