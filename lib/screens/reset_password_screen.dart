import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  static const routeName = 'change_password';

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: SafeArea(
        child: ElevatedButton(
          child: Text('Reset Password'),
          onPressed: () async {
            await _firebaseAuth.sendPasswordResetEmail(email: _firebaseAuth.currentUser!.email!);
          },
        ),
      ),
    );
  }
}
