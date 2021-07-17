enum Repeat {
  once,
  day,
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday
}

class RepeatString {
  static String repeatToString(Repeat repeat) {
    switch (repeat) {
      case Repeat.once : return 'Once';
      case Repeat.day : return 'Every Day';
      case Repeat.monday : return 'Every Monday';
      case Repeat.tuesday : return 'Every Tuesday';
      case Repeat.wednesday : return 'Every Wednesday';
      case Repeat.thursday : return 'Every Thursday';
      case Repeat.friday : return 'Every Friday';
      case Repeat.saturday : return 'Every Saturday';
      case Repeat.sunday : return 'Every Sunday';
    }
  }

  static int? repeatToDateTime(Repeat repeat) {
    switch (repeat) {
      case Repeat.once : return null;
      case Repeat.day : return null;
      case Repeat.monday : return DateTime.monday;
      case Repeat.tuesday : return DateTime.tuesday;
      case Repeat.wednesday : return DateTime.wednesday;
      case Repeat.thursday : return DateTime.thursday;
      case Repeat.friday : return DateTime.friday;
      case Repeat.saturday : return DateTime.saturday;
      case Repeat.sunday : return DateTime.sunday;
    }
  }

  static Repeat? stringToRepeat(String string) {
    switch (string) {
      case 'Once' : return Repeat.once;
      case 'Every Day' : return Repeat.day;
      case 'Every Monday' : return Repeat.monday;
      case 'Every Tuesday' : return Repeat.tuesday;
      case 'Every Wednesday' : return Repeat.wednesday;
      case 'Every Thursday' : return Repeat.thursday;
      case 'Every Friday' : return Repeat.friday;
      case 'Every Saturday' : return Repeat.saturday;
      case 'Every Sunday' : return Repeat.sunday;
    }
    return null;
  }
}
