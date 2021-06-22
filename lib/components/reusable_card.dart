import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {
  /*
  const ReusableCard({
    Key key,
  }) : super(key: key);
  */

  final Color color;
  final Widget? child;
  final Function()? onTap;
  final Function()? onLongPress;

  ReusableCard({required this.color, this.child, this.onTap, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        child: child,
        margin: EdgeInsets.all(6.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}