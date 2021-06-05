import 'package:flutter/material.dart';
import 'package:flutter_time_tracker/common_widgets/custom_raised_button.dart';

class SignInButton extends CustomRaisedButton {
  SignInButton({
    required String text,
    required Color textColor,
    required Color color,
    required VoidCallback onPressed,
  })  : assert(text != null),
        super(
          child: Text(
            text,
            style: TextStyle(color: textColor, fontSize: 15.0),
          ),
          color: color,
          borderRadius: 16.0,
          onPressed: onPressed,
        );
}
