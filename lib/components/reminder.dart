import 'repeat.dart';

class Reminder {
  int hour;
  int minute;
  Repeat repeat;
  bool active;

  Reminder({
    required this.hour,
    required this.minute,
    required this.repeat,
    required this.active,
  });
}
