import 'package:flutter/material.dart';
import 'package:flutter_time_tracker/app/sign_in/email_sign_in_form_change_notifier.dart';

class EmailSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in with email'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: EmailSignInChangeNotifier.create(context),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
