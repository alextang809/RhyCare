import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'record.dart';
import 'package:rhythmcare/constants.dart';
import '../screens/detail_record_page.dart';

class RecordCard extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> record;

  RecordCard(this.record);

  @override
  Widget build(BuildContext context) {
    Record thisRecord = Record.fromSnapshot(record);

    return InkWell(
      splashColor: Color(0x6600c1b7),
      child: Container(
        margin: EdgeInsets.all(6.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Color(0x8a66f6f5),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 5,
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
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailRecordPage(record: thisRecord, recordReference: record.reference)),
        );
      },
    );
  }
}
