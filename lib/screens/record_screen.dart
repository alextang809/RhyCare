import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../components/record_card.dart';

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

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    CollectionReference records = FirebaseFirestore.instance
        .collection('records')
        .doc(user!.uid)
        .collection('user_records');

    return SafeArea(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                InkWell(
                  splashColor: Colors.purple,
                  onTap: () {
                    setState(() {
                      reversed = !reversed;
                    });
                  },
                  child: Icon(
                    FontAwesomeIcons.sort,
                    size: 26.0,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
                stream: records.orderBy('date_time').snapshots(),
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
