import 'package:flutter/material.dart';

import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  // const LoginScreen({Key key}) : super(key: key);
  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  void signIn() {

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
              Image.asset(
                'images/icon.png',
                width: 100.0,
              ),

              SizedBox(
                height: 50.0,
              ),

              Card(
                child: Container(
                  height: 270.0,
                  width: 300.0,
                  padding: EdgeInsets.all(10.0),
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          // user name
                          TextFormField(
                            decoration: InputDecoration(labelText: 'User Name'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'user name cannot be empty';
                              }
                              return null;
                            },
                            onSaved: (value) {},
                          ),

                          // password
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.length <= 4) {
                                return 'invalid password';
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
                              signIn();
                            },
                            child: Text('Sign IN'),
                          ),

                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed(SignupScreen.routeName);
                            },
                            child: Text('Register an account >'),
                          ),
                        ],
                      ),
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
