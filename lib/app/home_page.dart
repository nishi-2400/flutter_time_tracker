import 'package:flutter/material.dart';
import 'package:flutter_time_tracker/services/auth.dart';

class HomePage extends StatelessWidget {
  // コンストラクタ
  const HomePage({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;

  // Logout
  Future<void> _signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          FlatButton(
            onPressed: _signOut,
            child: Text(
              'Logout',
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
