import 'dart:core';

import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpModel {
  String email;
  String password;
  String rePassword;
  bool acceptRadio;

  SignUpModel(this.email, this.password, this.rePassword, this.acceptRadio);
}

class SignUpCubit extends Cubit<SignUpModel> {
  SignUpCubit(SignUpModel initialState) : super(initialState);

  void signUpInProgress() {}

  void radioButtonChanged() {
    state.acceptRadio = !state.acceptRadio;
    emit(state);
  }
}
