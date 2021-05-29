import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  // const HomeScreen({Key key}) : super(key: key);
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      appBar: AppBar(
        title: Text('RhythmCare Home Screen'),
        backgroundColor: Colors.purple[900],
      ),
      body: Center(
        child: Image(
          image: AssetImage('images/icon.png'),
        ),
      ),
    );
  }
}
