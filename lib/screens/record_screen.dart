import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rhythmcare/components/time_filter_card.dart';

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

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    CollectionReference records = FirebaseFirestore.instance
        .collection('records')
        .doc(user!.uid)
        .collection('user_records');
    Stream<QuerySnapshot<Object?>> stream = records
        .where(
          'date_time',
          isGreaterThanOrEqualTo: startDateTime,
          isLessThanOrEqualTo: endDateTime,
        )
        .orderBy('date_time')
        .snapshots();

    return SafeArea(
      child: Column(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                InkWell(
                  splashColor: Colors.purple,
                  customBorder: new CircleBorder(),
                  onTap: () {
                    Navigator.of(context)
                        .push(HeroDialogRoute(builder: (context) {
                      // TODO: why can't change name
                      return TimeFilterCard();
                    })).then((value) {
                      setState(() {
                        startDateTime = value[0];
                        endDateTime = value[1];
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
                  width: 15.0,
                ),
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
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
                stream: stream,
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
                            return RecordCard(
                                snapshot.data!.docs.reversed.elementAt(index));
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
