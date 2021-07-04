import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  static const routeName = 'change_password';

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  var oldPassword;
  var newPassword;

  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  TextEditingController passwordController = new TextEditingController();
  void changePassword() async {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();

      EasyLoading.show(status: 'processing...');

      try {
        if (oldPassword.toString() == newPassword.toString()) {
          throw Exception();
        }
      } catch (error) {
        EasyLoading.dismiss();

        Fluttertoast.showToast(
          msg: 'Your new password is the same as the original one!',
          toastLength: Toast.LENGTH_LONG,
        );
        return;
      }

      try {
        AuthCredential credential = EmailAuthProvider.credential(
            email: _firebaseAuth.currentUser!.email!, password: oldPassword!);
        await _firebaseAuth.currentUser!
            .reauthenticateWithCredential(credential);
      } catch (error) {
        EasyLoading.dismiss();

        String errorCode = (error as FirebaseAuthException).code;
        if (errorCode == 'wrong-password') {
          Fluttertoast.showToast(
            msg: 'Wrong original password. Please try again!',
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
        await _firebaseAuth.currentUser!
            .updatePassword(newPassword!)
            .then((value) {
          EasyLoading.dismiss();

          // print('success');
          Fluttertoast.showToast(
            msg: 'Your password has been reset.',
            toastLength: Toast.LENGTH_SHORT,
          );
          Navigator.pop(context);
        });
      } catch (error) {
        EasyLoading.dismiss();

        Fluttertoast.showToast(
          msg: 'Failed! Please try again later or contact support.',
          toastLength: Toast.LENGTH_LONG,
        );
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // user email address
                TextFormField(
                  decoration: InputDecoration(labelText: 'Enter your registered email address'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'original password cannot be empty';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    oldPassword = value;
                  },
                ),

                // new password
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'New Password (at least six characters)'),
                  obscureText: true,
                  controller: passwordController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'new password cannot be empty';
                    } else if (value.length < 6) {
                      return 'password must have at least six characters';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    newPassword = value;
                  },
                ),

                // confirm new password
                TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Confirm New Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value != passwordController.text) {
                      return 'password does not match';
                    }
                    return null;
                  },
                  onSaved: (value) {},
                ),

                Flexible(
                  child: SizedBox(
                    height: 50.0,
                  ),
                ),

                ElevatedButton(
                  child: Text('Reset Password'),
                  onPressed: () {
                    changePassword();
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
