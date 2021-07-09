import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'record.dart';
import 'package:rhythmcare/constants.dart';
import '../screens/detail_record_page.dart';

class RecordCard extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> record;

  RecordCard(this.record);

  @override
  Widget build(BuildContext context) {
    Record thisRecord = Record.fromSnapshot(record);
    FirebaseAuth _firebaseauth = FirebaseAuth.instance;

    Color cardColor(String bmi_string) {
      double bmi = double.parse(bmi_string);
      Color color = Color(0xffffffff);
      if (bmi < 18.5) {
        color = Color(0x851bd0ed);
      } else if (bmi <= 24.9) {
        color = Color(0x8513D57B);
      } else if (bmi <= 29.9) {
        color = Color(0x85FECE00);
      } else if (bmi <= 34.9) {
        color = Color(0x85FD5A00);
      } else if (bmi <= 39.9) {
        color = Color(0x85FE0047);
      } else {
        color = Color(0x85FE0047);
      }
      return color;
    }

    Color recordColor = cardColor(thisRecord.bmi);

    return InkWell(
      splashColor: Color(0x6600c1b7),
      child: Container(
        margin: EdgeInsets.all(6.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: recordColor,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 3,
              blurRadius: 3,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  thisRecord.date_time,
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Height: ${thisRecord.height} cm',
                      style: kRecordSmallTextStyle,
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      'Weight: ${thisRecord.weight} kg',
                      style: kRecordSmallTextStyle,
                    ),
                  ],
                ),
                SizedBox(
                  width: 25.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Your BMI',
                      style: kRecordSmallTextStyle,
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      '${thisRecord.bmi}',
                      style: kRecordLargeTextStyle,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        // check whether email has been verified
        if (!_firebaseauth.currentUser!.emailVerified) {
          Fluttertoast.showToast(
            msg: 'Please verify your email address before viewing details!',
            toastLength: Toast.LENGTH_LONG,
          );
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailRecordPage(
              record: thisRecord,
              recordReference: record.reference,
              backgroundColor: recordColor,
            ),
          ),
        );
      },
    );
  }
}
