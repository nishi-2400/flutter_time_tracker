import 'dart:async';
import 'package:flutter_time_tracker/app/sign_in/email_sign_in_model.dart';

class EmailSignInBloc {
  final StreamController<EmailSignInModel> _modelStreamController =
      StreamController<EmailSignInModel>();

  Stream<EmailSignInModel> get modelStream => _modelStreamController.stream;
  EmailSignInModel _model = EmailSignInModel();

  void dispose() {
    _modelStreamController.close();
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
