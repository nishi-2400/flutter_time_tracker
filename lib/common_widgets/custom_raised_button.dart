import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  // コンストラクターの定義
  CustomRaisedButton(
      {required this.child,
      required this.color,
      this.borderRadius: 16.0,
      this.height: 50.0,
      required this.onPressed});

  final Widget child;
  final Color color;
  final double borderRadius;
  final double height;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: RaisedButton(
        onPressed: onPressed,
        child: child,
        color: color,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
      ),
    );
  }
}
