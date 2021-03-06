import 'dart:async';

import 'package:block_ui/block_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rhythmcare/screens/login_screen.dart';

import 'screens/home_screen.dart';
import 'screens/record_screen.dart';
import 'screens/setting_screen.dart';

class Navigation extends StatefulWidget {
  // const Navigation({Key? key}) : super(key: key);

  static const p0RouteName = 'nav_p0';
  static const p1RouteName = 'nav_p1';
  static const p2RouteName = 'nav_p2';
  int initialPageIndex = 0;

  Navigation(this.initialPageIndex);

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _currentIndex = 0;
  DateTime? currentBackPressTime;
  List<String> titles = [
    'Home',
    'Records',
    'Settings',
  ];
  List<Widget> pages = [
    HomeScreen(),
    RecordScreen(),
    SettingScreen(),
  ];
  // final PageStorageBucket bucket = PageStorageBucket();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Timer? timer;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'Press back again to exit.');
      return Future.value(false);
    }
    return Future.value(true);
  }



  @override
  void initState() {
    _currentIndex = widget.initialPageIndex;
    // print('init');
    if (!_firebaseAuth.currentUser!.emailVerified) {
      Fluttertoast.showToast(
        msg: 'You will be auto signed out in about one minute with unverified email address!',
        toastLength: Toast.LENGTH_LONG,
      );
      timer = Timer(Duration(seconds: 75), () async {
        EasyLoading.show(status: 'Auto Signing out...');
        BlockUi.show(
          context,
          backgroundColor: Colors.transparent,
          child: Container(),
        );
        try {
          await _firebaseAuth.signOut().then((value) async {
            await Future.delayed(Duration(seconds: 3)).then((value) {
              EasyLoading.dismiss();
              Navigator.pushNamedAndRemoveUntil(
                  context, LoginScreen.routeName, (route) => false);
            });
          });
        } catch (error) {
          EasyLoading.dismiss();
          Navigator.pushNamedAndRemoveUntil(
              context, LoginScreen.routeName, (route) => false);
          Fluttertoast.showToast(
            msg: 'An error occurs',
            toastLength: Toast.LENGTH_LONG,
          );
        }
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      appBar: AppBar(
        title: Text(titles[_currentIndex]),
        actions: <Widget>[
          Visibility(
            // visible: _currentIndex == 1,
            visible: false,
            child: Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Icon(
                    FontAwesomeIcons.sort,
                    size: 26.0,
                  ),
                )),
          ),
        ],
      ),
      body: WillPopScope(
        child: pages[_currentIndex],
        onWillPop: onWillPop,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.purple,
        selectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            // backgroundColor: Colors.orange,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'Records',
            // backgroundColor: Colors.orange,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            // backgroundColor: Colors.orange,
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
