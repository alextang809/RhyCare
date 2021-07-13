import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TimeFilterCard extends StatefulWidget {
  // const TimeFilterCard({Key? key}) : super(key: key);

  DateTime? start;
  DateTime? end;

  TimeFilterCard({required this.start, required this.end});

  @override
  _TimeFilterCardState createState() => _TimeFilterCardState();
}

class _TimeFilterCardState extends State<TimeFilterCard> {
  DateTime? startDateTime;
  DateTime? endDateTime;

  Future<DateTime?> pickStartDateTime() async {
    // DateTime lastDate = endDateTime == null ? DateTime.now() : endDateTime!;
    DateTime initialDate = DateTime.now();
    final DateTime? startDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.parse('20210501'),
      lastDate: initialDate,
    );
    if (startDate == null) return null;

    TimeOfDay initialTime = TimeOfDay.now();
    final TimeOfDay? startTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (startTime == null) return null;

    startDateTime = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
      startTime.hour,
      startTime.minute,
    );

    // print('finish');
    setState(() {});
    return startDateTime;
  }

  Future<DateTime?> pickEndDateTime() async {
    // DateTime firstDate = startDateTime == null ? DateTime.parse('20210501') : startDateTime!;
    DateTime initialDate = DateTime.now();
    final DateTime? endDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.parse('20210501'),
      lastDate: initialDate,
    );
    if (endDate == null) return null;

    TimeOfDay initialTime = TimeOfDay.now();
    final TimeOfDay? endTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (endTime == null) return null;

    endDateTime = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
      endTime.hour,
      endTime.minute,
    );

    // print('finish');
    setState(() {});
    return endDateTime;
  }

  String getStartDateTime() {
    if (startDateTime == null) {
      return 'Select';
    } else {
      return startDateTime.toString().substring(0, 16);
    }
  }

  String getEndDateTime() {
    if (endDateTime == null) {
      return 'Select';
    } else {
      return endDateTime.toString().substring(0, 16);
    }
  }

  Future<void> applyFilter() async {
    Navigator.pop(context, [startDateTime, endDateTime]);
  }

  void done() {
    if (startDateTime == null ||
        endDateTime == null ||
        endDateTime!.isBefore(startDateTime!)) {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text('Tap'),
      // ));
      Fluttertoast.showToast(
        msg: 'Please enter a valid time range!',
        toastLength: Toast.LENGTH_SHORT,
      );
    } else {
      applyFilter();
    }
  }

  void clearFilter() {
    startDateTime = null;
    endDateTime = null;
    applyFilter();
  }

  @override
  void initState() {
    startDateTime = widget.start;
    endDateTime = widget.end;
    super.initState();
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
                      'Show records',
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
                      'From',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await pickStartDateTime();
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
                          getStartDateTime(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      'To',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await pickEndDateTime();
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
                          getEndDateTime(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          done();
                        },
                        child: Text('Done'),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      TextButton(
                        onPressed: () {
                          clearFilter();
                        },
                        child: Text(
                          'Clear Filter',
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    ],
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
