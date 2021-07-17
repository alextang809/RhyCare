import 'package:flutter/material.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rhythmcare/components/reminder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../services/notification.dart' as nt;
import '../components/repeat.dart';

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
  Repeat _repeat = Repeat.day;

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
      RepeatString.repeatToString(_repeat),
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
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 2,
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
                    child: Container(
                      child: DropdownButton(
                        value: _repeat,
                        items: Repeat.values.map((Repeat item) {
                          return DropdownMenuItem<Repeat>(
                            child: Text(RepeatString.repeatToString(item)),
                            value: item,
                          );
                        }).toList(),
                        onChanged: (Repeat? value) {
                          setState(() {
                            _repeat = value!;
                          });
                        },
                        elevation: 8,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        icon: Icon(Icons.arrow_drop_down_circle),
                        iconEnabledColor: Colors.purple[400],
                        isExpanded: true,
                      ),
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
                primary: Colors.blue,
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
