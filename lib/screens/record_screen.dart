import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rhythmcare/components/reusable_card.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../components/reusable_card.dart';
import '../constants.dart';

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
                      children: snapshot.data!.docs.reversed.map((record) {
                        return Center(
                          child: ReusableCard(
                            color: kCardColor,
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      record['date_time']
                                          .toString()
                                          .substring(0, 16),
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 12.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Height: ${record['height']} cm',
                                          style: kRecordSmallTextStyle,
                                        ),
                                        SizedBox(
                                          height: 8.0,
                                        ),
                                        Text(
                                          'Weight: ${record['weight']} kg',
                                          style: kRecordSmallTextStyle,
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 25.0,),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          'Your BMI',
                                          style: kRecordSmallTextStyle,
                                        ),
                                        SizedBox(height: 5.0,),
                                        Text(
                                          '${record['bmi']}',
                                          style: kRecordLargeTextStyle,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            onLongPress: () async {
                              await Alert(
                                context: context,
                                type: AlertType.warning,
                                title: "DELETION",
                                desc: "Are you sure to delete this record? This is irrevocable!",
                                buttons: [
                                  DialogButton(
                                    child: Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () {
                                      if (!user.emailVerified) {
                                        Fluttertoast.showToast(
                                          msg: 'Deletion failed! Please verify your email address first!',
                                          toastLength: Toast.LENGTH_LONG,
                                        );
                                        Navigator.pop(context);
                                        return;
                                      }
                                      delete = true;
                                      Navigator.pop(context);
                                    },
                                    color: Color.fromRGBO(0, 179, 134, 1.0),
                                  ),
                                ],
                              ).show();

                              if (delete) {
                                EasyLoading.show(status: 'deleting...');
                                await record.reference.delete();
                                EasyLoading.dismiss();
                                Fluttertoast.showToast(
                                  msg: 'Record deleted',
                                  toastLength: Toast.LENGTH_SHORT,
                                );
                              }
                            },
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
