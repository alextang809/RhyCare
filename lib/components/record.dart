import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
  final Timestamp dateTime;
  final String height;
  final String weight;
  final String age;
  final String bmi;

  Record({
    required this.dateTime,
    required this.height,
    required this.weight,
    required this.age,
    required this.bmi,
  });

  Record.fromSnapshot(QueryDocumentSnapshot record)
      : this.dateTime = record['date_time'],
        this.height = record['height'].toString(),
        this.weight = record['weight'].toString(),
        this.age = record['age'].toString(),
        this.bmi = record['bmi'].toString();

  Map<String, dynamic> toJson() {
    return {
      'date_time': dateTime,
      'height': height,
      'weight': weight,
      'age': age,
      'bmi': bmi,
    };
  }
}
