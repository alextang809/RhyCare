import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rhythmcare/components/reminder.dart';
import 'package:rhythmcare/screens/set_reminder_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../services/notification.dart' as nt;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
SharedPreferences? prefs;

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({Key? key}) : super(key: key);

  static const routeName = 'reminder_screen';

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  bool loading = true;
  Timer? timer;

  Reminder reminder1 =
      Reminder(hour: 17, minute: 0, repeat: Repeat.week, active: false);

  Future<void> retrieveReminders() async {
    prefs = await SharedPreferences.getInstance();
    List<String>? list = prefs!.getStringList('reminder1');
    if (list != null) {
      Repeat repeat = Repeat.once;
      switch (list[2]) {
        case 'Repeat.once':
          repeat = Repeat.once;
          break;
        case 'Repeat.day':
          repeat = Repeat.day;
          break;
        case 'Repeat.week':
          repeat = Repeat.week;
          break;
      }
      reminder1 = Reminder(
          hour: int.parse(list[0]),
          minute: int.parse(list[1]),
          repeat: repeat,
          active: list[3] == 'active');
    }
  }

  String getRepeatText(Repeat repeat) {
    switch (repeat) {
      case Repeat.once:
        return 'Once';
      case Repeat.day:
        return 'Every Day';
      case Repeat.week:
        return 'Every Week';
    }
  }

  void cancelOrActivateReminder(bool value) {
    if (value == false) {
      // cancel reminder
      print('cancel');
      reminder1.active = false;
      if (timer != null) {
        timer!.cancel();
      }
      prefs!.setStringList('reminder1', [
        reminder1.hour.toString(),
        reminder1.minute.toString(),
        reminder1.repeat.toString(),
        'inactive',
      ]);
      nt.Notification.cancelNotification(0);
    } else {
      // activate reminder
      print('activate');
      if (timer != null) {
        timer!.cancel();
        print('timer cancel');
      }
      timer = Timer.periodic(Duration(seconds: 1), (timer) async {
        await checkPendingNotifications();
      });
      print('timer start');
      reminder1.active = true;
      prefs!.setStringList('reminder1', [
        reminder1.hour.toString(),
        reminder1.minute.toString(),
        reminder1.repeat.toString(),
        'active',
      ]);
      nt.Notification.scheduleNotification(
        reminder1.repeat,
        TimeOfDay(
          hour: reminder1.hour,
          minute: reminder1.minute,
        ),
      );
    }
  }

  Widget body() {
    if (loading == true) {
      retrieveReminders().then((value) {
        Future.delayed(Duration(milliseconds: 100)).then((value) {
          loading = false;
          setState(() {});
        });
      });
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.purple,
        ),
      );
    } else {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SetReminderScreen(reminder1),
                    ),
                  ).then((value) {
                    if (timer != null) {
                      timer!.cancel();
                      print('timer cancel');
                    }
                    timer = Timer.periodic(Duration(seconds: 1), (timer) async {
                      await checkPendingNotifications();
                    });
                    print('timer start');
                    setState(() {
                      loading = true;
                    });
                  });
                },
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${reminder1.hour.toString()}:${reminder1.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(fontSize: 30.0),
                            ),
                            Visibility(
                              visible: false,
                              child: Text('Reminder 1'),
                            ),
                            Text(
                              getRepeatText(reminder1.repeat),
                              style: TextStyle(fontSize: 16.0),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Switch(
                            value: reminder1.active,
                            onChanged: (value) {
                              cancelOrActivateReminder(value);
                              setState(() {});
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<void> checkPendingNotifications() async {
    int length = await nt.Notification.checkPendingNotifications();
    if (length == 0) {
      timer!.cancel();
      print('cancel timer');
      setState(() {
        reminder1.active = false;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? list = prefs.getStringList('reminder1');
      if (list != null) {
        prefs.setStringList(
            'reminder1', [list[0], list[1], list[2], 'inactive']);
      }
      print('clear');
    }
  }

  @override
  void initState() {
    print('start timer');
    timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      await checkPendingNotifications();
    });
    super.initState();
  }

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      appBar: AppBar(
        title: Text('Reminder'),
      ),
      body: body(),
    );
    ;
  }
}
