import 'package:flutter/material.dart';
import 'package:rhythmcare/constants.dart';

class RecordInfoCard extends StatefulWidget {
  // const TimeFilterCard({Key? key}) : super(key: key);

  @override
  _RecordInfoCardState createState() => _RecordInfoCardState();
}

class _RecordInfoCardState extends State<RecordInfoCard> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Material(
          // color: AppColors.accentColor,
          color: Colors.purple[50],
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: SizedBox(
              height: screenHeight * 0.7,
              width: screenWidth * 0.7,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'What is BMI?',
                      style: TextStyle(
                        fontSize: 18.0,
                        height: 1.35,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Body mass index (BMI) is a value derived from the mass (weight) and height of a person. The BMI is defined as the body mass divided by the square of the body height, and is expressed in units of kg/m², resulting from mass in kilograms and height in metres.',
                      style: TextStyle(
                        fontSize: 16.0,
                        height: 1.35,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      '(Source: Wikipedia)',
                      style: TextStyle(
                        fontSize: 15.0,
                        height: 1.35,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    Text(
                      'Why do records have different color?',
                      style: TextStyle(
                        fontSize: 18.0,
                        height: 1.35,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'If the BMI function is enabled, calculated BMI value will be shown on your records, and your records will be displayed with different colors based on your health level reflected by BMI. Details are as follows:',
                      style: TextStyle(
                        fontSize: 16.0,
                        height: 1.35,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    Column(
                      children: <Widget>[
                        RecordColorInfoRow(
                          screenWidth: screenWidth,
                          color: kRecordColor1,
                          text1: 'Underweight',
                          text2: '(BMI < 18.5)',
                        ),
                        RecordColorInfoRow(
                          screenWidth: screenWidth,
                          color: kRecordColor2,
                          text1: 'Normal weight',
                          text2: '(18.5 ≤ BMI ≤ 24.9)',
                        ),
                        RecordColorInfoRow(
                          screenWidth: screenWidth,
                          color: kRecordColor3,
                          text1: 'Pre-obesity',
                          text2: '(25.0 ≤ BMI ≤ 29.9)',
                        ),
                        RecordColorInfoRow(
                          screenWidth: screenWidth,
                          color: kRecordColor4,
                          text1: 'Obesity class I',
                          text2: '(30.0 ≤ BMI ≤ 34.9)',
                        ),
                        RecordColorInfoRow(
                          screenWidth: screenWidth,
                          color: kRecordColor5,
                          text1: 'Obesity class II',
                          text2: '(35.0 ≤ BMI ≤ 39.9)',
                        ),
                        RecordColorInfoRow(
                          screenWidth: screenWidth,
                          color: kRecordColor5,
                          text1: 'Obesity class III',
                          text2: '(BMI > 40)',
                        ),
                      ],
                    ),
                    Text(
                      '(Source: World Health Organization)',
                      style: TextStyle(
                        fontSize: 15.0,
                        height: 1.35,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RecordColorInfoRow extends StatelessWidget {
  const RecordColorInfoRow({
    Key? key,
    required this.screenWidth,
    required this.color,
    required this.text1,
    required this.text2,
  }) : super(key: key);

  final double screenWidth;
  final Color color;
  final String text1;
  final String text2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: screenWidth * 0.02,
          ),
          Container(
            height: 15.0,
            width: 32.0,
            color: color,
          ),
          SizedBox(
            width: 15.0,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  text1,
                  style: TextStyle(
                    fontSize: 16.0,
                    height: 1.35,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  text2,
                  style: TextStyle(
                    fontSize: 13.0,
                    height: 1.35,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
