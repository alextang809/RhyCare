import 'package:block_ui/block_ui.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rhythmcare/constants.dart';
import 'package:rhythmcare/screens/change_function_screen.dart';
import 'package:rhythmcare/screens/change_password_screen.dart';
import 'package:rhythmcare/screens/change_email_screen.dart';
import 'email_verify_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../navigation.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'login_screen.dart';
import 'reminder_screen.dart';
import '../services/notification.dart' as nt;

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  bool? _signedInWithGoogle;
  User? user = FirebaseAuth.instance.currentUser;
  Color? buttonColor = Colors.purple[50];

  Widget emailStatus() {
    if (!user!.emailVerified) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.cancel_rounded,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 5.0,
                ),
                Container(
                  child: Flexible(
                    child: Text(
                      'Please verify your email before using other services. If not verified, your account could be removed after exiting this app and you would need to register a new account. Press "Refresh" if you have verified.',
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, ChangeEmailScreen.routeName)
                        .then((value) => setState(() {
                              user = _firebaseAuth.currentUser;
                              // print('${user!.email}');
                            }));
                  },
                  child: Text(
                    'Change your email?',
                    style: TextStyle(
                      fontSize: 14.0,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  child: Text('Verify'),
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, EmailVerifyScreen.routeName);
                  },
                ),
                ElevatedButton(
                  child: Text('Refresh'),
                  onPressed: () async {
                    EasyLoading.show();
                    await user!.reload();
                    user = _firebaseAuth.currentUser;
                    if (user!.emailVerified) {
                      // await FirebaseFirestore.instance
                      //     .collection('users')
                      //     .doc(user!.uid)
                      //     .set({
                      //   'userId': user!.uid,
                      //   'verified_email': user!.email,
                      //   'google_sign_in': 'false',
                      // });
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString('email', 'VERIFIED');
                      EasyLoading.dismiss();
                      Navigator.pushNamedAndRemoveUntil(
                          context, Navigation.p2RouteName, (route) => false);
                    }
                    EasyLoading.dismiss();
                    setState(() {});
                  },
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      if (_signedInWithGoogle!) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
              SizedBox(
                width: 5.0,
              ),
              Flexible(
                child: Text(
                  'Your have signed in with Google',
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
              SizedBox(
                width: 5.0,
              ),
              Flexible(
                child: Text(
                  'Your email has been verified',
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        );
      }
    }
  }

  Widget changeEmailAddress(BuildContext context) {
    // user will only be allowed to change email address if he has not verified it
    double screenWidth = MediaQuery.of(context).size.width;

    if (false) {
      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, ChangeEmailScreen.routeName)
              .then((value) => setState(() {
                    user = _firebaseAuth.currentUser;
                    // print('${user!.email}');
                  }));
        },
        child: Container(
          width: double.infinity,
          color: Colors.purple[50],
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          margin: EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('EMAIL'),
              SizedBox(
                width: 5.0,
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: screenWidth * 0.5,
                    child: Text(
                      '${user!.email}',
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        color: Colors.purple[50],
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 13.0),
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('EMAIL'),
            SizedBox(
              width: 5.0,
            ),
            Row(
              children: <Widget>[
                Container(
                  width: screenWidth * 0.75,
                  child: Text(
                    '${user!.providerData[0].email}',
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  // @override
  // void initState() {
  // User? user = FirebaseAuth.instance.currentUser;
  // user!.reload().then((value) {
  //   setState(() {});
  // });
  //   super.initState();
  // }

  Widget body() {
    if (_signedInWithGoogle == null) {
      SharedPreferences.getInstance().then((prefs) {
        _signedInWithGoogle = (prefs.get('google') == 'true');
        Future.delayed(Duration(milliseconds: 150)).then((value) {
          if (this.mounted) {
            setState(() {});
          }
        });
      });
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.purple,
        ),
      );
    } else {
      // double screen_height = MediaQuery.of(context).size.height;
      return SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  changeEmailAddress(context),
                  Container(
                    child: emailStatus(),
                    color: Colors.transparent,
                  ),
                  Visibility(
                    visible: !_signedInWithGoogle!,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                                context, ChangePasswordScreen.routeName)
                            .then((value) => setState(() {
                                  user = _firebaseAuth.currentUser;
                                }));
                      },
                      child: Container(
                        width: double.infinity,
                        color: buttonColor,
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 8.0),
                        margin: EdgeInsets.symmetric(vertical: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Change Password'),
                            Icon(Icons.arrow_forward_ios_rounded),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (!user!.emailVerified) {
                        Fluttertoast.showToast(
                          msg: 'Please verify your email address first!',
                          toastLength: Toast.LENGTH_SHORT,
                        );
                        return;
                      }
                      Navigator.pushNamed(
                              context, ChangeFunctionScreen.routeName)
                          //     .then((value) => setState(() {
                          //   user = _firebaseAuth.currentUser;
                          // }))
                          ;
                    },
                    child: Container(
                      width: double.infinity,
                      color: buttonColor,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Functions'),
                          Icon(Icons.arrow_forward_ios_rounded),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (!user!.emailVerified) {
                        Fluttertoast.showToast(
                          msg: 'Please verify your email address first!',
                          toastLength: Toast.LENGTH_SHORT,
                        );
                        return;
                      }
                      Navigator.pushNamed(
                          context, ReminderScreen.routeName)
                      //     .then((value) => setState(() {
                      //   user = _firebaseAuth.currentUser;
                      // }))
                          ;
                    },
                    child: Container(
                      width: double.infinity,
                      color: buttonColor,
                      padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Reminder'),
                          Icon(Icons.arrow_forward_ios_rounded),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  await signOut();
                },
                child: Text('Sign out'),
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<bool> confirmSignOut() async {
    bool confirmSignOut = false;

    await Alert(
      context: context,
      type: AlertType.warning,
      title: "SIGN OUT",
      desc: "Are you sure to sign out? All the reminders will be deleted.",
      buttons: [
        DialogButton(
          child: Text(
            "Sign out",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            confirmSignOut = true;
            Navigator.pop(context);
          },
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
      ],
    ).show();

    return confirmSignOut;
  }

  Future<void> signOut() async {
    if (await confirmSignOut() == false) return;

    EasyLoading.show(status: 'Signing out...');
    BlockUi.show(
      context,
      backgroundColor: Colors.transparent,
      child: Container(),
    );

    // print(_signedInWithGoogle);
    // print('22222222222222');
    // print(GoogleSignIn().currentUser);
    if (_signedInWithGoogle!) {
      await googleSignIn.signOut().timeout(kTimeoutDuration, onTimeout: () {
        EasyLoading.dismiss();
        BlockUi.hide(context);
        Fluttertoast.showToast(
          msg: kTimeoutMsg,
          toastLength: Toast.LENGTH_LONG,
        );
      });
      (await SharedPreferences.getInstance()).remove('google');
    }
    await _firebaseAuth.signOut().then((value) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('email');
      prefs.remove('filter_start');
      prefs.remove('filter_end');
      prefs.remove('reversed');
      prefs.remove('height');
      prefs.remove('weight');
      prefs.remove('age');

      prefs.remove('reminder1');
      await nt.Notification.cancelAllNotifications();

      await Future.delayed(Duration(seconds: 2));
      EasyLoading.dismiss();
      // BlockUi.hide(context);

      Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (route) => false);
      Fluttertoast.showToast(
        msg: 'You have successfully logged out.',
        toastLength: Toast.LENGTH_SHORT,
      );
    }).timeout(kTimeoutDuration, onTimeout: () {
      EasyLoading.dismiss();
      // BlockUi.hide(context);
      Fluttertoast.showToast(
        msg: kTimeoutMsg,
        toastLength: Toast.LENGTH_LONG,
      );
      Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return body();
  }
}
