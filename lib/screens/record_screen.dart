import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import '../components/record_card.dart';

void main() => runApp(RecordScreen());

class RecordScreen extends StatefulWidget {
  const RecordScreen({Key? key}) : super(key: key);

  static const routeName = 'records_screen';

  @override
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  bool delete = false;

  ScreenshotController screenshotController = ScreenshotController();
  Future<void> takeScreenshotAndShare() async {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    // print('11111');
    final directory = (await getExternalStorageDirectory())!.path;
    print('$directory');

    screenshotController
        .capture(
      pixelRatio: pixelRatio,
      delay: Duration(milliseconds: 10),
    )
        .then((capturedImage) async {
      // await showCapturedWidget(context, capturedImage!);
      File imgFile = await new File('$directory/screenshot1.png').create();
      await imgFile.writeAsBytes(capturedImage!);
      if (await Permission.storage.request().isGranted) {
        // Either the permission was already granted before or the user just granted it.
        Fluttertoast.showToast(
          msg: "Image will be saved to your gallery",
          toastLength: Toast.LENGTH_SHORT,
        );
        ImageGallerySaver.saveImage(
          capturedImage,
          quality: 100,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Image can't be saved to gallery",
          toastLength: Toast.LENGTH_SHORT,
        );
      }
      await Share.shareFiles(['$directory/screenshot1.png']);
      await imgFile.delete();
    });
  }

  Future<dynamic> showCapturedWidget(
      BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text("Captured widget screenshot"),
        ),
        body: Center(
            child: capturedImage != null
                ? Image.memory(capturedImage)
                : Container()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    CollectionReference records = FirebaseFirestore.instance
        .collection('records')
        .doc(user!.uid)
        .collection('user_records');

    return SafeArea(
      child: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
                stream: records.orderBy('date_time').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.purple,
                      ),
                    );
                  } else {
                    return Screenshot(
                      controller: screenshotController,
                      child: ListView.builder(
                          itemCount: snapshot.data!.docs.reversed.length,
                          itemBuilder: (BuildContext context, int index) {
                            return RecordCard(
                                snapshot.data!.docs.reversed.elementAt(index));
                          }),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}

/*
                              onLongPress: () async {
                                await Alert(
                                  context: context,
                                  type: AlertType.warning,
                                  title: "DELETION",
                                  desc:
                                      "Are you sure to delete this record? This is irrevocable!",
                                  buttons: [
                                    DialogButton(
                                      child: Text(
                                        "Delete",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () {
                                        if (!user.emailVerified) {
                                          Fluttertoast.showToast(
                                            msg:
                                                'Deletion failed! Please verify your email address first!',
                                            toastLength: Toast.LENGTH_LONG,
                                          );
                                          Navigator.pop(context);
                                          return;
                                        }
                                        delete = true;
                                        Navigator.pop(context);
                                      },
                                      color: Color.fromRGBO(0, 179, 134, 1.0),
                                    ),
                                  ],
                                ).show();

                                if (delete) {
                                  EasyLoading.show(status: 'deleting...');
                                  await record.reference.delete();
                                  EasyLoading.dismiss();
                                  Fluttertoast.showToast(
                                    msg: 'Record deleted',
                                    toastLength: Toast.LENGTH_SHORT,
                                  );
                                }
                              },
                              */

// onLongPress: () async {
// await takeScreenshotAndShare();
// },

// ElevatedButton(
// onPressed: () {
// Share.share('testing text');
// },
// child: Text(
// 'Share',
// style: TextStyle(
// fontSize: 20.0,
// fontWeight: FontWeight.bold,
// ),
// ))
