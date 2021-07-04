import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  static const routeName = 'forgot_reset_password';

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  var email;

  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  void sendPasswordResetEmail() async {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();

      EasyLoading.show(status: 'processing...');

      try {
        await _firebaseAuth.sendPasswordResetEmail(email: email);
        EasyLoading.dismiss();
        Fluttertoast.showToast(
          msg: 'A password reset email has been sent to your registered email address.',
          toastLength: Toast.LENGTH_LONG,
        );
        Navigator.pop(context);
      } catch (error) {
        EasyLoading.dismiss();

        String errorCode = (error as FirebaseAuthException).code;
        if (errorCode == 'invalid-email' || errorCode == 'user-not-found') {
          Fluttertoast.showToast(
            msg: 'User not found. Please enter a valid email address!',
            toastLength: Toast.LENGTH_LONG,
          );
        } else {
          Fluttertoast.showToast(
            msg: 'Failed! Please try again later or contact support.',
            toastLength: Toast.LENGTH_LONG,
          );
        }
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[200],
      appBar: AppBar(
        title: Text('Change Password'),
        backgroundColor: Colors.teal[900],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // original password
                TextFormField(
                  decoration: InputDecoration(labelText: 'Your registered email address'),
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

                Flexible(
                  child: SizedBox(
                    height: 50.0,
                  ),
                ),

                ElevatedButton(
                  child: Text('Reset Password'),
                  onPressed: () {
                    sendPasswordResetEmail();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
