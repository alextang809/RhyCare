import 'package:block_ui/block_ui.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rhythmcare/constants.dart';

class ChangeFunctionScreen extends StatefulWidget {
  const ChangeFunctionScreen({Key? key}) : super(key: key);

  static const routeName = 'change_function';

  @override
  _ChangeFunctionScreenState createState() => _ChangeFunctionScreenState();
}

class _ChangeFunctionScreenState extends State<ChangeFunctionScreen> {
  bool loading = true;
  bool heightEnabled = true;
  bool weightEnabled = true;
  bool ageEnabled = true;
  bool bmiEnabled = true;

  User user = FirebaseAuth.instance.currentUser!;

  Future<void> save() async {
    EasyLoading.show(status: 'Saving...');
    BlockUi.show(
      context,
      backgroundColor: Colors.transparent,
      child: Container(),
    );
    await FirebaseFirestore.instance.collection('settings').doc(user.uid).set({
      'height_enabled': heightEnabled,
      'weight_enabled': weightEnabled,
      'age_enabled': ageEnabled,
      'bmi_enabled': bmiEnabled,
    }).then((value) {
      EasyLoading.dismiss();
      BlockUi.hide(context);
      Fluttertoast.showToast(
        msg: 'Any changes have been saved.',
        toastLength: Toast.LENGTH_SHORT,
      );
    }).timeout(kTimeoutDuration, onTimeout: () {
      EasyLoading.dismiss();
      BlockUi.hide(context);
      Fluttertoast.showToast(
        msg: kTimeoutMsg,
        toastLength: Toast.LENGTH_LONG,
      );
    });
    Navigator.pop(context);
  }

  Future<void> retrieveUserPreferences() async {
    try {
      await FirebaseFirestore.instance
          .collection('settings')
          .doc(user.uid)
          .get()
          .then((snapshot) {
        heightEnabled = snapshot.get('height_enabled');
        weightEnabled = snapshot.get('weight_enabled');
        ageEnabled = snapshot.get('age_enabled');
        bmiEnabled = snapshot.get('bmi_enabled');
      });
    } catch (e) {  // TODO: update this later

      Fluttertoast.showToast(
        msg: 'An error occurred. Please contact support.',
        toastLength: Toast.LENGTH_LONG,
      );

      heightEnabled = true;
      weightEnabled = true;
      ageEnabled = true;
      bmiEnabled = true;
    }
  }

  Widget body() {
    if (loading == true) {
      retrieveUserPreferences().then((value) {
        Future.delayed(Duration(milliseconds: 100)).then((value) {
          loading = false;
          if (this.mounted) {
            setState(() {});
          }
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SwitchListTile(
                title: Text("Height"),
                value: heightEnabled,
                tileColor: Colors.white,
                onChanged: (bool value) {
                  setState(() {
                    heightEnabled = value;
                    if (value == false) {
                      bmiEnabled = false;
                    }
                  });
                },
              ),
              SwitchListTile(
                title: Text("Weight"),
                value: weightEnabled,
                tileColor: Colors.white,
                onChanged: (bool value) {
                  setState(() {
                    weightEnabled = value;
                    if (value == false) {
                      bmiEnabled = false;
                    }
                  });
                },
              ),
              SwitchListTile(
                title: Text("Age"),
                value: ageEnabled,
                tileColor: Colors.white,
                onChanged: (bool value) {
                  setState(() {
                    ageEnabled = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text("BMI"),
                value: bmiEnabled,
                tileColor: Colors.white,
                onChanged: (bool value) {
                  setState(() {
                    bmiEnabled = value;
                    if (value == true) {
                      heightEnabled = true;
                      weightEnabled = true;
                    }
                  });
                },
              ),
              Container(
                child: Text('Press "Save" to save your changes.'),
                margin: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 5.0),
              ),
              ElevatedButton(
                onPressed: () async {
                  await save();
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      appBar: AppBar(
        title: Text('Functions'),
      ),
      body: body(),
    );
  }
}
