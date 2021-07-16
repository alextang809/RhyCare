import 'package:flutter/material.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rhythmcare/components/reminder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../services/notification.dart' as nt;

enum Repeat { once, day, week }

class SetReminderScreen extends StatefulWidget {
  // const SetReminderScreen({Key? key}) : super(key: key);

  static const routeName = 'set_reminder';
  Reminder cr;

  SetReminderScreen(this.cr);

  @override
  _SetReminderScreenState createState() => _SetReminderScreenState();
}

class _SetReminderScreenState extends State<SetReminderScreen> {
  TimeOfDay _time = TimeOfDay.now().replacing(minute: 30);
  Repeat _repeat = Repeat.once;

  void onTimeChanged(TimeOfDay newTime) {
    setState(() {
      _time = newTime;
    });
  }

  Future<void> saveReminderAndActivate() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('reminder1', [
      _time.hour.toString(),
      _time.minute.toString(),
      _repeat.toString(),
      'active'
    ]);

    await nt.Notification.scheduleNotification(_repeat, _time);

    EasyLoading.dismiss();
    Navigator.pop(context);
  }

  @override
  void initState() {
    Reminder currentReminder = widget.cr;
    _time = TimeOfDay(
      hour: currentReminder.hour,
      minute: currentReminder.minute,
    );
    _repeat = currentReminder.repeat;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _time.format(context),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline2,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.purple[400],
              ),
              onPressed: () {
                Navigator.of(context).push(
                  showPicker(
                    context: context,
                    value: _time,
                    onChange: onTimeChanged,
                    disableHour: false,
                    disableMinute: false,
                    is24HrFormat: true,
                    // Optional onChange to receive value as DateTime
                    // onChangeDateTime: (DateTime dateTime) {
                    //   print(dateTime);
                    // },
                  ),
                );
              },
              child: Text(
                "Select Time",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  height: 30.0,
                  child: Divider(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Repeat',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: <Widget>[
                        RadioListTile(
                            value: Repeat.once,
                            title: Text('Once'),
                            groupValue: _repeat,
                            onChanged: (Repeat? value) {
                              setState(() {
                                _repeat = value!;
                              });
                            }),
                        RadioListTile(
                            value: Repeat.day,
                            title: Text('Every day'),
                            groupValue: _repeat,
                            onChanged: (Repeat? value) {
                              setState(() {
                                _repeat = value!;
                              });
                            }),
                        RadioListTile(
                            value: Repeat.week,
                            title: Text('Every week'),
                            groupValue: _repeat,
                            onChanged: (Repeat? value) {
                              setState(() {
                                _repeat = value!;
                              });
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SizedBox(
                height: 100.0,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blueGrey[400],
              ),
              onPressed: () async {
                await saveReminderAndActivate();
              },
              child: Text(
                "Save",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
