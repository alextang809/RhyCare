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

  ReusableCard({required this.color, this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: child,
        margin: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}