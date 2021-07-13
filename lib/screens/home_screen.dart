import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rhythmcare/services/add_record.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/reusable_card.dart';
import '../components/round_icon_button.dart';
import '../constants.dart';
import '../components/record.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const routeName = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  double height = 160.0;
  double weight = 60.0;
  int age = 20;
  Timer? _weightMinusTimer;
  Timer? _weightPlusTimer;
  Timer? _ageMinusTimer;
  Timer? _agePlusTimer;
  bool loading = true;

  Future<void> retrieveUserLastUpdatedData() async {
    await SharedPreferences.getInstance().then((prefs) {
      height = prefs.getDouble('height') == null
          ? 160.0
          : prefs.getDouble('height')!;
      weight =
          prefs.getDouble('weight') == null ? 60.0 : prefs.getDouble('weight')!;
      age = prefs.getInt('age') == null ? 20 : prefs.getInt('age')!;
    });
  }

  // @override
  // void initState() {
  //   retrieveUserLastUpdatedData();
  //   super.initState();
  // }

  @override
  void dispose() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setDouble('height', height);
      prefs.setDouble('weight', weight);
      prefs.setInt('age', age);
    });
    super.dispose();
  }

  Widget body() {
    if (loading == true) {
      retrieveUserLastUpdatedData().then((value) {
        Future.delayed(Duration(milliseconds: 100)).then((value) {
          loading = false;
          setState(() {});
        });
      });
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.purple,
        ),
      );
    } else {
      return SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: ReusableCard(
                  color: kCardColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'HEIGHT',
                        style: kLabelTextStyle,
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: <Widget>[
                          Text(
                            height.toStringAsFixed(1),
                            style: kNumberTextStyle,
                          ),
                          Text(
                            'cm',
                            style: kLabelTextStyle,
                          ),
                        ],
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.white,
                          inactiveTrackColor: Color(0xFF8D8E98),
                          thumbColor: Color(0xFFEB1555),
                          overlayColor: Color(0x29EB1555),
                          thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 13.0),
                          overlayShape:
                          RoundSliderOverlayShape(overlayRadius: 20.0),
                        ),
                        child: Slider(
                            value: height.toDouble(),
                            min: 100.0,
                            max: 220.0,
                            divisions: 240,
                            onChanged: (double newValue) {
                              setState(() {
                                height = newValue;
                              });
                            }),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ReusableCard(
                  color: kCardColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'WEIGHT',
                        style: kLabelTextStyle,
                      ),
                      SizedBox(
                        height: 2.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: <Widget>[
                          Text(
                            weight.toStringAsFixed(1),
                            style: kNumberTextStyle,
                          ),
                          Text(
                            'kg',
                            style: kLabelTextStyle,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTapDown: (TapDownDetails details) {
                              // print('down');
                              _weightMinusTimer =
                                  Timer.periodic(Duration(milliseconds: 3), (t) {
                                    setState(() {
                                      if (weight > 12.0) weight -= 0.1;
                                    });
                                    // print('value $weight');
                                  });
                            },
                            onTapUp: (TapUpDetails details) {
                              // print('up');
                              _weightMinusTimer!.cancel();
                            },
                            onTapCancel: () {
                              // print('cancel');
                              _weightMinusTimer!.cancel();
                            },
                            child: RoundIconButton(
                              icon: FontAwesomeIcons.minus,
                              onPressed: () {
                                setState(() {
                                  if (weight > 12.0) weight -= 0.1;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          GestureDetector(
                            onTapDown: (TapDownDetails details) {
                              // print('down');
                              _weightPlusTimer =
                                  Timer.periodic(Duration(milliseconds: 3), (t) {
                                    setState(() {
                                      if (weight < 250.0) weight += 0.1;
                                    });
                                    // print('value $weight');
                                  });
                            },
                            onTapUp: (TapUpDetails details) {
                              // print('up');
                              _weightPlusTimer!.cancel();
                            },
                            onTapCancel: () {
                              // print('cancel');
                              _weightPlusTimer!.cancel();
                            },
                            child: RoundIconButton(
                              icon: FontAwesomeIcons.plus,
                              onPressed: () {
                                setState(() {
                                  if (weight < 250.0) weight += 0.1;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ReusableCard(
                  color: kCardColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'AGE',
                        style: kLabelTextStyle,
                      ),
                      SizedBox(
                        height: 2.0,
                      ),
                      Text(
                        age.toString(),
                        style: kNumberTextStyle,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTapDown: (TapDownDetails details) {
                              // print('down');
                              _ageMinusTimer =
                                  Timer.periodic(Duration(milliseconds: 50), (t) {
                                    setState(() {
                                      if (age > 8) age--;
                                    });
                                    // print('value $weight');
                                  });
                            },
                            onTapUp: (TapUpDetails details) {
                              // print('up');
                              _ageMinusTimer!.cancel();
                            },
                            onTapCancel: () {
                              // print('cancel');
                              _ageMinusTimer!.cancel();
                            },
                            child: RoundIconButton(
                              icon: FontAwesomeIcons.minus,
                              onPressed: () {
                                setState(() {
                                  if (age > 8) age--;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          GestureDetector(
                            onTapDown: (TapDownDetails details) {
                              // print('down');
                              _agePlusTimer =
                                  Timer.periodic(Duration(milliseconds: 50), (t) {
                                    setState(() {
                                      if (age < 70) age++;
                                    });
                                    // print('value $weight');
                                  });
                            },
                            onTapUp: (TapUpDetails details) {
                              // print('up');
                              _agePlusTimer!.cancel();
                            },
                            onTapCancel: () {
                              // print('cancel');
                              _agePlusTimer!.cancel();
                            },
                            child: RoundIconButton(
                              icon: FontAwesomeIcons.plus,
                              onPressed: () {
                                setState(() {
                                  if (age < 70) age++;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 40.0,
                ),
                child: MaterialButton(
                  color: Colors.blue,
                  minWidth: 50.0,
                  height: 45.0,
                  textColor: Colors.white,
                  onPressed: () async {
                    EasyLoading.show(status: 'processing...');

                    if (!user!.emailVerified) {
                      EasyLoading.dismiss();

                      Fluttertoast.showToast(
                        msg:
                        'Upload failed! Please verify your email address first!',
                        toastLength: Toast.LENGTH_LONG,
                      );
                      return;
                    }
                    var now = DateTime.now();
                    double bmi = weight / pow(height / 100, 2);
                    // print(now);

                    await FirebaseFirestore.instance
                        .collection('records')
                        .doc(user!.uid)
                        .collection("user_records")
                        .add(
                      Record(
                        date_time: Timestamp.fromDate(now),
                        height: height.toStringAsFixed(1),
                        weight: weight.toStringAsFixed(1),
                        bmi: bmi.toStringAsFixed(1),
                      ).toJson(),
                    )
                        .then((value) {
                      EasyLoading.dismiss();

                      Fluttertoast.showToast(
                        msg: 'Upload successfully',
                        toastLength: Toast.LENGTH_SHORT,
                      );
                    }); // TODO: catch any error
                  },
                  child: Text('UPLOAD'),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return body();
  }
}
