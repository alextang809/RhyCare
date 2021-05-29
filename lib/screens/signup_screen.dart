import 'package:flutter/material.dart';

import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  // const LoginScreen({Key key}) : super(key: key);
  static const routeName = '/signup';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _passwordController = new TextEditingController();

  void signIn() {

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
                  height: 330.0,
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
                            controller: _passwordController,
                            validator: (value) {
                              if (value == null || value.length <= 4) {
                                return 'invalid password';
                              }
                              return null;
                            },
                            onSaved: (value) {},
                          ),

                          // confirm password
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Confirm Password'),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value != _passwordController.text) {
                                return 'password not the same';
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
                            child: Text('Register'),
                          ),

                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
                            },
                            child: Text('< Go back to login'),
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
