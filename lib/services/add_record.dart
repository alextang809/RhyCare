import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddUserRecord {

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUserRecord(String email) async {
    print(email);
    await users
        .add({
          'email': email,
        })
        .then((value) => print("User Record Added"))
        .catchError((error) => print("Failed to add user record: $error"));
  }
}
