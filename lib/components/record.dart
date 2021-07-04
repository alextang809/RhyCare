import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
  final String date_time;
  final String height;
  final String weight;
  final String bmi;

  Record({
    required this.date_time,
    required this.height,
    required this.weight,
    required this.bmi,
  });

  Record.fromSnapshot(QueryDocumentSnapshot record)
      : this.date_time = record['date_time'].toString().substring(0, 16),
        this.height = record['height'].toString(),
        this.weight = record['weight'].toString(),
        this.bmi = record['bmi'].toString();

  Map<String, dynamic> toJson() {
    return {
      'date_time': date_time,
      'height': height,
      'weight': weight,
      'bmi': bmi,
    };
  }
}
