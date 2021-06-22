// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddUserRecord {

  // Create a CollectionReference called users that references the firestore collection
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUserRecord(String email) async {
    // Call the user's CollectionReference to add a new user
    print(email);
    await users
        .add({
          'email': email,
        })
        .then((value) => print("User Record Added"))
        .catchError((error) => print("Failed to add user record: $error"));
  }
}
