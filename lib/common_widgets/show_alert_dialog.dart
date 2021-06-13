import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future showAlertDialog(
  BuildContext context, {
  required String title,
  required String content,
  required String defaultActionText,
  String? cancelActionText,
}) {
  if (Platform.isAndroid) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          if (cancelActionText != null)
            FlatButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(cancelActionText),
            ),
          FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(defaultActionText),
          ),
        ],
      ),
    );
  }
  return showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        if (cancelActionText != null)
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelActionText),
          ),
        FlatButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(defaultActionText),
        ),
      ],
    ),
  );
}
