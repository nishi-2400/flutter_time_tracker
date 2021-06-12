import 'package:flutter/material.dart';
import 'package:flutter_time_tracker/common_widgets/form_submit_button.dart';
import 'package:flutter_time_tracker/services/auth.dart';

// フォームタイプを管理
enum EmailSignInFormType { signIn, register }

class EmailSignInForm extends StatefulWidget {
  const EmailSignInForm({required this.auth});
  final AuthBase auth;

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  // TextFieldの値を管理するコントローラー
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  // デフォルトのフォームタイプを”signIn”にセットしておく
  EmailSignInFormType _formType = EmailSignInFormType.signIn;

  // メールアドレスとパスワードのゲッター
  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  // フォームのサブミット
  void _submit() async {
    try {
      if (_formType == EmailSignInFormType.signIn) {
        await widget.auth.signInWithEmail(_email, _password);
      } else {
        await widget.auth.createUserWithEmailAndPassword(_email, _password);
      }

      // Emailサインインページをpop-
      Navigator.of(context).pop();

    } catch (e) {
      print(e.toString());
    }
  }

  void _emailEditingComplete() {
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  // ステートの制御
  void _toggleFormType() {
    setState(() {
      _formType = _formType == EmailSignInFormType.signIn ?
          EmailSignInFormType.register : EmailSignInFormType.signIn;
    });

    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    // ボタンの表示内容の制御
    final primaryText = _formType == EmailSignInFormType.signIn ?
    'Sign in' : 'Create an account';
    final secondaryText = _formType == EmailSignInFormType.signIn ?
    'Need an account? Register' : 'Have an account? Sign In';

    return [
      _buildEmailTextField(),
      SizedBox(height: 8.0),
      _buildPasswordTextField(),
      SizedBox(height: 8.0),
      FormSubmitButton(text: primaryText, onPressed: _submit),
      SizedBox(height: 8.0),
      // フォームタイプの切り替え
      FlatButton(
        onPressed: _toggleFormType,
        child: Text(secondaryText),
      ),
    ];
  }

  TextField _buildPasswordTextField() {
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      obscureText: true,
      onEditingComplete: _submit,
      decoration: InputDecoration(
        labelText: 'Password',
      ),
      // エンターキーの変更
      textInputAction: TextInputAction.done,
    );
  }

  TextField _buildEmailTextField() {
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      onEditingComplete: _emailEditingComplete,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@test.com',
      ),
      // 予測変換を表示しない。
      autocorrect: false,
      // キーボードのタイプ
      keyboardType: TextInputType.emailAddress,
      // エンターキーの変更
      textInputAction: TextInputAction.next,
    );
  }

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
