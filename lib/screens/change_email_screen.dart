import 'package:block_ui/block_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rhythmcare/constants.dart';
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

  // String verified_email = FirebaseAuth.instance.currentUser!.emailVerified ? FirebaseAuth.instance.currentUser!.email! : '';

  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  void resetEmail() async {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();

      if (newEmail.toString() ==
          _firebaseAuth.currentUser!.email!.toString()) {
        Fluttertoast.showToast(
          msg: 'Your new email address is the same as the current one!',
          toastLength: Toast.LENGTH_LONG,
        );
        return;
      }

      EasyLoading.show(status: 'Processing...');
      BlockUi.show(
        context,
        backgroundColor: Colors.transparent,
        child: Container(),
      );

      try {
        AuthCredential credential = EmailAuthProvider.credential(
            email: _firebaseAuth.currentUser!.email!, password: password!);
        await _firebaseAuth.currentUser!
            .reauthenticateWithCredential(credential);
      } catch (error) {
        await Future.delayed(Duration(milliseconds: 100));
        EasyLoading.dismiss();
        BlockUi.hide(context);

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
          final user = _firebaseAuth.currentUser;
          FirebaseFirestore.instance.collection('users').doc(user!.uid).set(
            {
              // 'userId': user.uid,
              'email': newEmail,
              // 'google_sign_in': 'false',
            },
            SetOptions(merge: true),
          ).timeout(kTimeoutDuration, onTimeout: () {
            EasyLoading.dismiss();
            BlockUi.hide(context);
            Fluttertoast.showToast(
              msg: kTimeoutMsg,
              toastLength: Toast.LENGTH_LONG,
            );
            Navigator.pushNamedAndRemoveUntil(context, Navigation.p2RouteName, (route) => false);
          });

          EasyLoading.dismiss();
          // BlockUi.hide(context);

          // print('success');
          Fluttertoast.showToast(
            msg: 'Your email address has been updated.',
            toastLength: Toast.LENGTH_SHORT,
          );
          Navigator.pushNamedAndRemoveUntil(context, Navigation.p2RouteName, (route) => false);
        });
      } catch (error) {
        EasyLoading.dismiss();
        BlockUi.hide(context);

        String errorCode = (error as FirebaseAuthException).code;
        if (errorCode == 'email-already-in-use') {
          Fluttertoast.showToast(
            msg: 'The email address already exists. If you are the owner of this email address, please sign out and use the "Forgot your password?" function on the Login page to reset a password!',
            toastLength: Toast.LENGTH_LONG,
          );
          Fluttertoast.showToast(
            msg: 'The email address already exists. If you are the owner of this email address, please sign out and use the "Forgot your password?" function on the Login page to reset a password!',
            toastLength: Toast.LENGTH_LONG,
          );
          Fluttertoast.showToast(
            msg: 'The email address already exists. If you are the owner of this email address, please sign out and use the "Forgot your password?" function on the Login page to reset a password!',
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
                    if (value == null || value.isEmpty) {
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
                    if (value == null || value.isEmpty) {
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
