import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rhythmcare/screens/chart_screen.dart';
import 'package:rhythmcare/screens/generate_chart_card.dart';
import 'package:rhythmcare/screens/record_info_card.dart';
import 'package:rhythmcare/screens/time_filter_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/record_card.dart';
import '../services/dialog_route.dart';

void main() => runApp(RecordScreen());

class RecordScreen extends StatefulWidget {
  const RecordScreen({Key? key}) : super(key: key);

  static const routeName = 'records_screen';

  @override
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  bool delete = false;
  bool reversed = true;
  DateTime? startDateTime;
  DateTime? endDateTime;
  bool loading = true;

  String? parse(String? time) {
    // print(time);
    // print('2222222222');
    if (time == null || time == 'null') {
      return null;
    } else {
      return time.replaceRange(10, 11, 'T');
    }
  }

  Future<void> retrieveUserPreferences() async {
    await SharedPreferences.getInstance().then((prefs) {
      String? start = parse(prefs.getString('filter_start'));
      String? end = start == null ? null : parse(prefs.getString('filter_end'));
      startDateTime = start == null ? null : DateTime.parse(start);
      endDateTime = end == null ? null : DateTime.parse(end);
      reversed =
          prefs.getBool('reversed') == null ? true : prefs.getBool('reversed')!;
    });
  }

  @override
  void dispose() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('filter_start', startDateTime.toString());
      prefs.setString('filter_end', endDateTime.toString());
      prefs.setBool('reversed', reversed);
    });
    super.dispose();
  }

  Widget body() {
    if (!user!.emailVerified) {
      return Container();
    }
    if (loading == true) {
      retrieveUserPreferences().then((value) {
        Future.delayed(Duration(milliseconds: 100)).then((value) {
          loading = false;
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
      User? user = FirebaseAuth.instance.currentUser;
      CollectionReference records = FirebaseFirestore.instance
          .collection('records')
          .doc(user!.uid)
          .collection('user_records');
      Query<Object?> query = records
          .where(
            'date_time',
            isGreaterThanOrEqualTo: startDateTime,
            isLessThanOrEqualTo: endDateTime == null
                ? null
                : endDateTime!.add(Duration(minutes: 1)),
          )
          .orderBy('date_time');

      return SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                        splashColor: Colors.purple,
                        customBorder: new CircleBorder(),
                        onTap: () {
                          setState(() {
                            reversed = !reversed;
                          });
                        },
                        child: Icon(
                          FontAwesomeIcons.sort,
                          size: 28.0,
                          color: Colors.purple,
                        ),
                      ),
                      SizedBox(
                        width: 17.0,
                      ),
                      InkWell(
                        splashColor: Colors.purple,
                        customBorder: new CircleBorder(),
                        onTap: () {
                          Navigator.of(context)
                              .push(HeroDialogRoute(builder: (context) {
                            // TODO: why can't change name
                            return TimeFilterCard(
                              start: startDateTime,
                              end: endDateTime,
                            );
                          })).then((value) {
                            setState(() {
                              if (value != null) {
                                startDateTime = value[0];
                                endDateTime = value[1];
                              }
                            });
                          });
                        },
                        child: Icon(
                          FontAwesomeIcons.clock,
                          size: 28.0,
                          color: Colors.purple,
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      InkWell(
                        splashColor: Colors.purple,
                        customBorder: new CircleBorder(),
                        onTap: () {
                          Navigator.of(context)
                              .push(HeroDialogRoute(builder: (context) {
                            return GenerateChartCard();
                          })).then((value) async {
                            if (value != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChartScreen(
                                    query: query,
                                    item: value[0],
                                  ),
                                ),
                              );
                            }
                          });
                        },
                        child: Icon(
                          FontAwesomeIcons.chartLine,
                          size: 28.0,
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    splashColor: Colors.purple,
                    customBorder: new CircleBorder(),
                    onTap: () {
                      Navigator.of(context).push(HeroDialogRoute(
                          builder: (context) => RecordInfoCard()));
                    },
                    child: Icon(
                      FontAwesomeIcons.infoCircle,
                      size: 28.0,
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder(
                  stream: query.snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.purple,
                        ),
                      );
                    } else {
                      if (reversed) {
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.reversed.length,
                            itemBuilder: (BuildContext context, int index) {
                              return RecordCard(snapshot.data!.docs.reversed
                                  .elementAt(index));
                            });
                      } else {
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              return RecordCard(
                                  snapshot.data!.docs.elementAt(index));
                            });
                      }
                    }
                  }),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return body();
  }
}
