import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gallery_saver/gallery_saver.dart';

import '../components/record.dart';

class DetailRecordPage extends StatefulWidget {
  // const DetailRecordPage({Key? key}) : super(key: key);

  final Record record;
  final DocumentReference recordReference;
  final Color backgroundColor;

  DetailRecordPage({required this.record, required this.recordReference, required this.backgroundColor});

  @override
  _DetailRecordPageState createState() => _DetailRecordPageState();
}

class _DetailRecordPageState extends State<DetailRecordPage> {
  Record? thisRecord;
  DocumentReference? thisRecordReference;
  Color? thisBackgroundColor;

  @override
  void initState() {
    thisRecord = this.widget.record;
    thisRecordReference = this.widget.recordReference;
    thisBackgroundColor = this.widget.backgroundColor;
    super.initState();
  }

  ScreenshotController screenshotController = ScreenshotController();
  Future<Uint8List?> takeScreenshot() async {
    double pixelRatio = MediaQuery
        .of(context)
        .devicePixelRatio;
    Uint8List? image;
    await screenshotController
        .capture(pixelRatio: pixelRatio, delay: Duration(milliseconds: 10))
        .then((capturedImage) async {
      image = capturedImage;
      // await showCapturedWidget(context, capturedImage!);
    });
    return image;
  }

  /*
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
   */

  Future<void> save() async {
    if (await Permission.storage.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      // EasyLoading.show(status: 'saving...');

      Uint8List? capturedImage = await takeScreenshot();
      final String currentTime = DateTime.now().toIso8601String().substring(0, 22);

      final directory = (await getApplicationDocumentsDirectory()).path;
      print('$directory');
      File imgFile = await new File('$directory/rhythmcare_$currentTime.png').create();
      await imgFile.writeAsBytes(capturedImage!);

      final result = await GallerySaver.saveImage(imgFile.path.toString());

      // final result = await ImageGallerySaver.saveImage(
      //   capturedImage!,
      //   quality: 100,
      //   name: 'rhythmcare_$currentTime',
      // );

      print(result);

      imgFile.delete();

      // EasyLoading.dismiss();

      Fluttertoast.showToast(
        msg: "Your record has been saved to gallery.",
        toastLength: Toast.LENGTH_SHORT,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Storage permission is required to save the record!",
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  Future<void> share() async {
    // EasyLoading.show(status: 'processing...');

    Uint8List? capturedImage = await takeScreenshot();
    final String currentTime = DateTime.now().toIso8601String().substring(0, 22);

    final directory = (await getApplicationDocumentsDirectory()).path;
    print('$directory');
    File imgFile = await new File('$directory/$currentTime.png').create();
    await imgFile.writeAsBytes(capturedImage!);

    // EasyLoading.dismiss();

    await Share.shareFiles(['$directory/$currentTime.png']);
    await imgFile.delete();
    print('finish');
  }

  Future<void> delete() async {
    bool delete = false;

    await Alert(
      context: context,
      type: AlertType.warning,
      title: "DELETION",
      desc: "Are you sure to delete this record? The action is irrevocable!",
      buttons: [
        DialogButton(
          child: Text(
            "Delete",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            delete = true;
            Navigator.pop(context);
          },
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
      ],
    ).show();

    if (delete) {
      EasyLoading.show(status: 'deleting...');
      await thisRecordReference!.delete();
      EasyLoading.dismiss();
      Fluttertoast.showToast(
        msg: 'Record deleted',
        toastLength: Toast.LENGTH_SHORT,
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
      ),
      backgroundColor: Colors.purple[100],
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: double.infinity,
              ),
              Screenshot(
                controller: screenshotController,
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: thisBackgroundColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(thisRecord!.date_time),
                      Text('Height: ${thisRecord!.height}'),
                      Text('Weight: ${thisRecord!.weight}'),
                      Text('BMI: ${thisRecord!.bmi}'),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      await save();
                    },
                    child: Text('Save as image'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await share();
                    },
                    child: Text('Share as image'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await delete();
                    },
                    child: Text('Delete this record'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
