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

  // Future<bool> checkGoogleSignIn(String email) async {
  //   try {
  //     await _firebaseAuth.signInWithEmailAndPassword(
  //         email: email,
  //         password: '%90yrSGn58>jXshufanN*nZTO|a5Z@S9i%?x?QN=gL+');
  //     await _firebaseAuth.signOut();
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'wrong-password') {
  //       return false;
  //     } else {
  //       Fluttertoast.showToast(
  //         msg: 'Failed! Please try again later or contact support.',
  //         toastLength: Toast.LENGTH_LONG,
  //       );
  //       throw Exception('ErrorAndFinish');
  //     }
  //   }
  //   Fluttertoast.showToast(
  //     msg: "User not found or you used Sign In with Google before.",
  //     toastLength: Toast.LENGTH_LONG,
  //   );
  //   return true;
  // }

  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  Future<void> sendPasswordResetEmail() async {
    final form = formKey.currentState;
    bool google = false;
    if (form!.validate()) {
      form.save();

      EasyLoading.show(status: 'processing...');

      // try {
      //   await checkGoogleSignIn(email).then((value) {
      //     google = value;
      //   });
      //   if (google) {
      //     EasyLoading.dismiss();
      //     return;
      //   }
      // } catch (e) {
      //   print('$e');
      //   return;
      // }

      try {
        await _firebaseAuth.sendPasswordResetEmail(email: email);
        EasyLoading.dismiss();
        Fluttertoast.showToast(
          msg:
              'A password reset email has been sent to your email address.',
          toastLength: Toast.LENGTH_LONG,
        );
        Navigator.pop(context);
      } catch (error) {
        EasyLoading.dismiss();

        String errorCode = (error as FirebaseAuthException).code;
        if (errorCode == 'invalid-email' || errorCode == 'user-not-found') {
          Fluttertoast.showToast(
            msg: 'User not found or you used Sign In with Google before.',
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
        title: Text('Forgot Password'),
        backgroundColor: Colors.teal[900],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Text(
                  "NOTE: If you have only used your Google account to sign in before, we do not recommend resetting your password by entering your Google account's email address. However, you can use this function to set a password and login later using both Google account and your email address. Your records will be the same no matter which way you use to login.",
                ),
              ),
              SizedBox(
                height: 100.0,
              ),
              Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // original password
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Enter your registered email address'),
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

                    SizedBox(
                      height: 50.0,
                    ),

                    ElevatedButton(
                      child: Text('Send Password Reset Email'),
                      onPressed: () async {
                        await sendPasswordResetEmail();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
