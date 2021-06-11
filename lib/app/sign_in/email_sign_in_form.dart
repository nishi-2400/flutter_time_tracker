import 'package:flutter/material.dart';

List<Widget> _buildChildren() {
  return [
    TextField(
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@test.com',
      ),
    ),
    SizedBox(height: 8.0),
    TextField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
      ),
    ),
    SizedBox(height: 8.0),
    RaisedButton(child: Text('Sign in'), onPressed: () {}),
    SizedBox(height: 8.0),
    FlatButton(
      onPressed: () {},
      child: Text('Need an account? Register'),
    ),
  ];
}

class EmailSignInForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }
}
