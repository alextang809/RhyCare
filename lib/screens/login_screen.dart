import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rhythmcare/navigation.dart';
import 'package:rhythmcare/screens/reset_password_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  // const LoginScreen({Key key}) : super(key: key);
  static const routeName = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var email;
  var password;
  AuthCredential? credential;
  bool newUser = false;

  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  Future<void> signIn() async {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();

      EasyLoading.show(status: 'processing...');

      try {
        // print('Form is valid.');
        final userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        print('Signed in: ${userCredential.user!.providerData}');

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', email);

        EasyLoading.dismiss();

        if (!userCredential.user!.emailVerified) {
          prefs.remove('email');
          Navigator.of(context).pushReplacementNamed(Navigation.p2RouteName);
        } else {
          Navigator.of(context).pushReplacementNamed(Navigation.p0RouteName);
        }
      } catch (error) {
        EasyLoading.dismiss();

        print('$error');
        String errorCode = (error as FirebaseAuthException).code;
        if (errorCode == 'invalid-email') {
          Fluttertoast.showToast(
            msg: 'Please use a valid email address.',
            toastLength: Toast.LENGTH_LONG,
          );
        } else if (errorCode == 'user-not-found' ||
            errorCode == 'wrong-password') {
          Fluttertoast.showToast(
            msg: 'Please check your email address or password.',
            toastLength: Toast.LENGTH_LONG,
          );
        } else {
          Fluttertoast.showToast(
            msg: 'Login failed! Please try again later or contact support.',
            toastLength: Toast.LENGTH_LONG,
          );
        }
      }
    }
  }

  Future<void> signInWithGoogle() async {
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    User? user;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    EasyLoading.show();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    EasyLoading.dismiss();

    print('111111111111');
    print(googleSignInAccount);

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      print('google signed in');

      try {
        EasyLoading.show();
        final UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential!);
        newUser = userCredential.additionalUserInfo!.isNewUser;

        // print('auth signed in');

        user = userCredential.user;
        bool merge = false;

        // AuthCredential ac = AuthCredential(providerId: 'password', signInMethod: 'password');

        // user!.linkWithCredential(ac);
        //
        print(user!.providerData);
        // print(googleSignIn.currentUser == null);

        if (user.providerData.length > 1) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get()
              .then((snapshot) {
            newUser = snapshot.get('google_sign_in').toString() == 'false';
            // print('11111111111111: $newUser');
          });
          if (newUser) {
            EasyLoading.dismiss();
            // print('show alert!');
            await Alert(
              context: context,
              type: AlertType.warning,
              title: "Existing Email",
              desc:
                  "The email address linked to your Google account has been registered with and verified before. If you are sure you are the owner of this email address, press Merge to merge the data from your previous account. If you don't intend to do these, press Cancel or anywhere else to cancel this login!",
              buttons: [
                DialogButton(
                  child: Text(
                    "Merge",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () {
                    merge = true;
                    Navigator.pop(context);
                  },
                  color: Color.fromRGBO(208, 204, 204, 1.0),
                ),
                DialogButton(
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  color: Color.fromRGBO(19, 161, 5, 1.0),
                  onPressed: () => Navigator.pop(context),
                  gradient: LinearGradient(colors: [
                    Color.fromRGBO(116, 116, 191, 1.0),
                    Color.fromRGBO(52, 138, 199, 1.0)
                  ]),
                )
              ],
            ).show();

            if (merge) {
              EasyLoading.show(status: 'processing...');
              // await user.unlink('password');

              // String googleEmail = user.providerData[0].email!;
              // await _firebaseAuth.signOut();
              // try {
              //   final dummyCredential = await FirebaseAuth.instance
              //       .createUserWithEmailAndPassword(
              //           email: googleEmail,
              //           password: "%90yrSGn58>jXshufanN*nZTO|a5Z@S9i%?x?QN=gL+");
              //   await FirebaseAuth.instance.signOut();
              //   await _firebaseAuth.signInWithCredential(credential!);
              // } on FirebaseAuthException catch (e) {
              //   print('$e');
              //   await _firebaseAuth.signInWithCredential(credential!);
              // }

              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .set(
                {
                  // 'userId': user.uid,
                  // 'email': user.providerData[0].email,
                  'google_sign_in': 'true',
                },
                SetOptions(merge: true),
              );

              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('email', user.providerData[0].email!);
              prefs.setString('google', 'true');
              EasyLoading.dismiss();

              Navigator.pushReplacementNamed(context, Navigation.p0RouteName);
            } else {
              EasyLoading.show();
              await googleSignIn.signOut();
              await user.unlink('google.com');
              await _firebaseAuth
                  .signOut(); // pay attention to the order of these 3 lines!
              EasyLoading.dismiss();
              Navigator.pushReplacementNamed(context, LoginScreen.routeName);
            }
          } else {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('email', user.providerData[0].email!);
            prefs.setString('google', 'true');
            EasyLoading.dismiss();

            Navigator.pushReplacementNamed(context, Navigation.p0RouteName);
          }
        } else {
          // user's google account's email address has never been registered with before or has been registered with but not verified
          // TODO: add shared_preferences

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('email', user.providerData[0].email!);
          prefs.setString('google', 'true');

          // print('work');
          if (newUser) {
            print('working');
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .set(
              {
                'userId': user.uid,
                'email': user.providerData[0].email,
                'google_sign_in': 'true',
              },
            );

            // try {
            //   user.unlink('password').then((value) => print('unlink succeed!'));
            // } catch (e) {
            //   print('unlink failed!');
            // }

            // String googleEmail = user.providerData[0].email!;
            // print('1111111111: $googleEmail');
            // await _firebaseAuth.signOut();
            // print('22222222');
            // try {
            //   final dummyCredential = await FirebaseAuth.instance
            //       .createUserWithEmailAndPassword(
            //           email: googleEmail,
            //           password: "%90yrSGn58>jXshufanN*nZTO|a5Z@S9i%?x?QN=gL+");
            //   print('33333333333');
            //   await FirebaseAuth.instance.signOut();
            //   print('44444444444');
            //   await _firebaseAuth.signInWithCredential(credential!);
            //   print('55555555555');
            // } on FirebaseAuthException catch (e) {
            //   print('66666666666');
            //   print('77777777777777777777: $e');
            //   await _firebaseAuth.signInWithCredential(credential!);
            //   print('88888888888');
            // }
          }

          // await _firebaseAuth.signInWithCredential(credential!);

          EasyLoading.dismiss();

          Navigator.pushReplacementNamed(context, Navigation.p0RouteName);
        }
      } on FirebaseAuthException catch (e) {
        // TODO: handle these errors
        EasyLoading.dismiss();
        if (e.code == 'account-exists-with-different-credential') {
          print(e.email);
        } else if (e.code == 'invalid-credential') {
          print('invalid-credential');
        }
      } catch (e) {
        EasyLoading.dismiss();
        print(e);
      }
    }
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
                  height: 330.0,
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
                          // autofillHints: [AutofillHints.email],
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter email address';
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

                        SizedBox(
                          height: 10.0,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, ResetPasswordScreen.routeName);
                              },
                              child: Text(
                                'Forgot your password?',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 20.0,
                        ),

                        ElevatedButton(
                          onPressed: () async {
                            await signIn();
                          },
                          child: Text('Login'),
                        ),

                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed(RegisterScreen.routeName);
                          },
                          child: Text('Register an account >'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Flexible(
                child: SizedBox(
                  height: 10.0,
                ),
              ),

              SignInButton(
                Buttons.Google,
                onPressed: () async {
                  await signInWithGoogle();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
