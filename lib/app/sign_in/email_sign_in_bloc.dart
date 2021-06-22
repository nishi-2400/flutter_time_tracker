import 'dart:async';
import 'package:flutter_time_tracker/app/sign_in/email_sign_in_model.dart';
import 'package:flutter_time_tracker/services/auth.dart';

class EmailSignInBloc {
  EmailSignInBloc({required this.auth});

  final AuthBase auth;
  final StreamController<EmailSignInModel> _modelStreamController =
      StreamController<EmailSignInModel>();

  Stream<EmailSignInModel> get modelStream => _modelStreamController.stream;
  EmailSignInModel _model = EmailSignInModel();

  void dispose() {
    _modelStreamController.close();
  }

  // フォームのサブミット
  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if (_model.formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmail(_model.email!, _model.password!);
      } else {
        await auth.createUserWithEmailAndPassword(
            _model.email!, _model.password!);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void toggleFormType() {
    final formType = _model.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    updateWith(
      email: '',
      password: '',
      formType: formType,
      isLoading: false,
      submitted: false,
    );
  }

  void updateWith({
    String? email,
    String? password,
    EmailSignInFormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    //  update model
    _model = _model.copyWith(
      email: email,
      password: password,
      formType: formType,
      isLoading: isLoading,
      submitted: submitted,
    );

    _modelStreamController.add(_model);
  }
}
