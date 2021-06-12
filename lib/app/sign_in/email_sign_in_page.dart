import 'package:flutter/material.dart';
import 'package:flutter_time_tracker/app/sign_in/email_sign_in_form.dart';
import 'package:flutter_time_tracker/services/auth.dart';

class EmailSignInPage extends StatelessWidget {
  const EmailSignInPage({required this.auth});
  final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in with email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: EmailSignInForm(auth: auth),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
