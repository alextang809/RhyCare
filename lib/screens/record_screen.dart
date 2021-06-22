import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rhythmcare/screens/home_screen.dart';

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
    CollectionReference records =
        FirebaseFirestore.instance.collection('users');

    return Scaffold(
      appBar: AppBar(
        title: Text('Records'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
                stream: records.snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.purple,
                      ),
                    );
                  } else {
                    return ListView(
                      children: snapshot.data!.docs.map((user) {
                        // TODO: this should actually list record, which is the inner collection
                        return Center(
                          child: ListTile(
                            title: Text(user['email']),
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
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, HomeScreen.routeName);
            },
            child: Text('Add a record'),
          ),
        ],
      ),
    );
  }
}
