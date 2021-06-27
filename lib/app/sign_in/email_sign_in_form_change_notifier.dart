import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_time_tracker/app/sign_in/email_sign_in_bloc.dart';
import 'package:flutter_time_tracker/app/sign_in/email_sign_in_change_model.dart';
import 'package:flutter_time_tracker/app/sign_in/email_sign_in_model.dart';
import 'package:flutter_time_tracker/common_widgets/form_submit_button.dart';
import 'package:flutter_time_tracker/common_widgets/show_exception_alert_dialog.dart';
import 'package:flutter_time_tracker/services/auth.dart';

// with で mixin
class EmailSignInChangeNotifier extends StatefulWidget {
  EmailSignInChangeNotifier({Key? key, required this.model}) : super(key: key);
  final EmailSignInChangeModel model;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (_) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (_, model, __) => EmailSignInChangeNotifier(model: model),
      ),
    );
  }

  @override
  _EmailSignInChangeNotifierState createState() =>
      _EmailSignInChangeNotifierState();
}

class _EmailSignInChangeNotifierState extends State<EmailSignInChangeNotifier> {
  // TextFieldの値を管理するコントローラー
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  EmailSignInChangeModel get model => widget.model;

  // ウィジェットが破棄される際に呼ばれるメソッド
  @override
  void dispose() {
    // 不要な一次データを削除しておく
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    // widgetをdispose()で破棄
    super.dispose();
  }

  // フォームのサブミット
  Future<void> _submit() async {
    try {
      await widget.model.submit();
      // Emailサインインページをpop-
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Sign in failed',
        exception: e,
      );
    }
  }

  // フォーカスの制御
  void _emailEditingComplete() {
    final newFocus = model.emailValidator.isValid(model.email!)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  // ステートの制御
  void _toggleFormType() {
    widget.model.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    return [
      _buildEmailTextField(),
      SizedBox(height: 8.0),
      _buildPasswordTextField(),
      SizedBox(height: 8.0),
      FormSubmitButton(
          text: model.primaryButtonText,
          onPressed: model.canSubmit ? _submit : null),
      SizedBox(height: 8.0),
      // フォームタイプの切り替え
      FlatButton(
        onPressed: !model.isLoading! ? () => _toggleFormType() : null,
        child: Text(model.secondaryButtonText),
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
        errorText: model.passwordErrorText,
        enabled: model.isLoading! == false,
      ),
      // エンターキーの変更
      textInputAction: TextInputAction.done,
      onChanged: model.updatePassword,
    );
  }

  TextField _buildEmailTextField() {
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      onEditingComplete: () => _emailEditingComplete(),
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@test.com',
        errorText: model.emailErrorText,
        enabled: model.isLoading == false,
      ),
      // 予測変換を表示しない。
      autocorrect: false,
      // キーボードのタイプ
      keyboardType: TextInputType.emailAddress,
      // エンターキーの変更
      textInputAction: TextInputAction.next,
      onChanged: model.updateEmail,
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
