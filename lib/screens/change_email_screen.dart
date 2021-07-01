import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rhythmcare/screens/email_verify_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:rhythmcare/navigation.dart';

class ChangeEmailScreen extends StatefulWidget {
  const ChangeEmailScreen({Key? key}) : super(key: key);

  static const routeName = 'change_email';

  @override
  _ChangeEmailScreenState createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  var newEmail;
  var password;

  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  void resetEmail() async {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();

      EasyLoading.show(status: 'processing...');

      try {
        if (newEmail.toString() ==
            _firebaseAuth.currentUser!.email!.toString()) {
          throw Exception();
        }
      } catch (error) {
        EasyLoading.dismiss();

        Fluttertoast.showToast(
          msg: 'Your new email address is the same as the current one!',
          toastLength: Toast.LENGTH_LONG,
        );
        return;
      }

      try {
        AuthCredential credential = EmailAuthProvider.credential(
            email: _firebaseAuth.currentUser!.email!, password: password!);
        await _firebaseAuth.currentUser!
            .reauthenticateWithCredential(credential);
      } catch (error) {
        EasyLoading.dismiss();

        String errorCode = (error as FirebaseAuthException).code;
        if (errorCode == 'wrong-password') {
          Fluttertoast.showToast(
            msg: 'Wrong password. Please try again!',
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

      try {
        await _firebaseAuth.currentUser!.updateEmail(newEmail!).then((value) {
          EasyLoading.dismiss();

          // print('success');
          Fluttertoast.showToast(
            msg: 'Your email address has been updated.',
            toastLength: Toast.LENGTH_SHORT,
          );
          Navigator.pop(context);
        });
      } catch (error) {
        EasyLoading.dismiss();

        String errorCode = (error as FirebaseAuthException).code;
        if (errorCode == 'email-already-in-use') {
          Fluttertoast.showToast(
            msg: 'This email address already exists.',
            toastLength: Toast.LENGTH_LONG,
          );
        } else if (errorCode == 'invalid-email') {
          Fluttertoast.showToast(
            msg: 'Please use a valid email address.',
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
      backgroundColor: Colors.purple[100],
      appBar: AppBar(
        title: Text('Change Email'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // password
                TextFormField(
                  decoration: InputDecoration(labelText: 'Login Password'),
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

                // new email address
                TextFormField(
                  decoration: InputDecoration(labelText: 'New Email Address'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'email address cannot be empty';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    newEmail = value;
                  },
                ),

                Flexible(
                  child: SizedBox(
                    height: 50.0,
                  ),
                ),

                ElevatedButton(
                  child: Text('Update Email'),
                  onPressed: () {
                    resetEmail();
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
