import 'package:flutter/material.dart';
import 'package:flutter_time_tracker/common_widgets/show_alert_dialog.dart';
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

  // サインアウトの確認ダイアログ
  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(
      context,
      title: 'Logout',
      content: 'Are you sure that you want to sign out?',
      defaultActionText: 'Logout',
      cancelActionText: 'Cancel',
    );

    if (didRequestSignOut == true) {
      _signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          FlatButton(
            onPressed: () => _confirmSignOut(context),
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
