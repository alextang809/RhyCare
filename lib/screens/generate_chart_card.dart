import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GenerateChartCard extends StatefulWidget {
  // const TimeFilterCard({Key? key}) : super(key: key);

  @override
  _GenerateChartCardState createState() => _GenerateChartCardState();
}

class _GenerateChartCardState extends State<GenerateChartCard> {
  void generateChart(String item) {
    Navigator.pop(context, [item]);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Material(
          // color: AppColors.accentColor,
          color: Color(0xFFE6CDE8),
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      'Generate time series charts',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 22.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Flexible(
                    child: Text(
                      'This function allows you to better view your height/weight/BMI changes with time. Please take note that charts are generated using all records currently visible on your "Records" page (i.e. after filtered by time range). Records without the specific field required (height/weight/BMI) will be ignored when generating charts. When there are more than one record made on the same date, only data from the first record on that day will be used.',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      generateChart('height');
                    },
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                      height: 30.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xFFE9D5EF),
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'View height changes',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      generateChart('weight');
                    },
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                      height: 30.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xFFE9D5EF),
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'View weight changes',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      generateChart('bmi');
                    },
                    child: Container(
                      margin:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                      height: 30.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xFFE9D5EF),
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'View BMI changes',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
