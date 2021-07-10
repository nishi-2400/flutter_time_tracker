import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_tracker/app/sign_in/email_sign_in_bloc.dart';
import 'package:flutter_time_tracker/app/sign_in/email_sign_in_model.dart';
import 'package:flutter_time_tracker/common_widgets/form_submit_button.dart';
import 'package:flutter_time_tracker/common_widgets/show_exception_alert_dialog.dart';
import 'package:flutter_time_tracker/services/auth.dart';
import 'package:provider/provider.dart';

// with で mixin
class EmailSignInBlocBased extends StatefulWidget {
  EmailSignInBlocBased({Key? key, required this.bloc}) : super(key: key);
  final EmailSignInBloc bloc;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<EmailSignInBloc>(
      create: (_) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
        builder: (_, bloc, __) => EmailSignInBlocBased(bloc: bloc),
      ),
      dispose: (_, bloc) => bloc.dispose(),
    );
  }

  @override
  _EmailSignInBlocBasedState createState() => _EmailSignInBlocBasedState();
}

class _EmailSignInBlocBasedState extends State<EmailSignInBlocBased> {
  // TextFieldの値を管理するコントローラー
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

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
      await widget.bloc.submit();
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
  void _emailEditingComplete(EmailSignInModel model) {
    final newFocus = model.emailValidator.isValid(model.email!)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  // ステートの制御
  void _toggleFormType() {
    widget.bloc.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren(EmailSignInModel model) {
    return [
      _buildEmailTextField(model),
      SizedBox(height: 8.0),
      _buildPasswordTextField(model),
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

  TextField _buildPasswordTextField(EmailSignInModel model) {
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
      onChanged: widget.bloc.updatePassword,
    );
  }

  TextField _buildEmailTextField(EmailSignInModel model) {
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      onEditingComplete: () => _emailEditingComplete(model),
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
      onChanged: widget.bloc.updateEmail,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
        stream: widget.bloc.modelStream,
        initialData: EmailSignInModel(),
        builder: (context, snapshot) {
          final EmailSignInModel? model = snapshot.data;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: _buildChildren(model!),
            ),
          );
        });
  }
}
