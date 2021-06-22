import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final Function() onPressed;

  RoundIconButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      child: Icon(icon),
      elevation: 6.0,
      fillColor: Colors.deepPurple[300],
      shape: CircleBorder(),
      constraints: BoxConstraints(minWidth: 50.0, minHeight: 50.0),
      enableFeedback: false,
    );
  }
}
