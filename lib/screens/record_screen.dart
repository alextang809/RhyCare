import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(RecordScreen());

class RecordScreen extends StatefulWidget {
  const RecordScreen({Key? key}) : super(key: key);

  static const routeName = 'records_screen';

  @override
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
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
                    return ListView(
                      children: snapshot.data!.docs.reversed.map((user) {
                        // TODO: this should actually list record, which is the inner collection
                        return Center(
                          child: ListTile(
                            title: Text(user['date_time']),
                            // onLongPress: () {
                            //   user.reference.delete();
                            // },
                          ),
                        );
                      }).toList(),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}
