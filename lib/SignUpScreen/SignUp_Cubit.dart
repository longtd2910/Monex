import 'dart:core';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monex/utils/function.dart';

class SignUpModel {
  String? email;
  String? password;
  String? rePassword;
  bool? acceptRadio;
  bool? passwordEyeOpen;
  bool? rePasswordEyeOpen;

  SignUpModel() {
    email = "";
    password = "";
    rePassword = "";
    acceptRadio = false;
    passwordEyeOpen = false;
    rePasswordEyeOpen = false;
  }
}

class ClientSideSignUpException implements Exception {
  String cause;
  int causeCode;
  ClientSideSignUpException(this.cause, this.causeCode);
}

class ServerSideSignUpException implements Exception {
  String cause;
  int causeCode;
  ServerSideSignUpException(this.cause, this.causeCode);
}

class SignUpCubit extends Cubit<SignUpModel> {
  SignUpCubit(SignUpModel initialState) : super(initialState);

  Future<bool> signUpInProgress(String email, String password, String rePassword) async {
    state.email = email;
    state.password = password;
    state.rePassword = rePassword;

    if (!EmailValidator.validate(state.email!)) {
      throw ClientSideSignUpException("Invalid email", 1);
    }

    if (state.password!.length < 6) {
      throw ClientSideSignUpException("Password too short", 2);
    }

    if (state.password!.length > 16) {
      throw ClientSideSignUpException("Password too long", 3);
    }

    if (state.password!.trim().length != state.password!.length) {
      throw ClientSideSignUpException("Password cannot start or end with a space", 4);
    }

    if (state.password!.compareTo(state.rePassword!) != 0) {
      throw ClientSideSignUpException("The passwords you entered is not the same", 5);
    }

    if (!state.acceptRadio!) {
      throw ClientSideSignUpException("Terms of Service & Privacy Policies must be accepted", 6);
    }

    DatabaseReference monexDbRef = FirebaseDatabase.instance.reference();
    DataSnapshot userIdList = await monexDbRef.child("users").once();
    Map<dynamic, dynamic> values = userIdList.value;
    bool hasDuplicate = false;
    for (String key in values.keys) {
      DataSnapshot emailList = await monexDbRef.child("users").child(key).child("email").once();
      if (emailList.value == state.email) {
        hasDuplicate = true;
      }
    }
    if (hasDuplicate) {
      throw ServerSideSignUpException("This email is already registered", 1);
    }
    monexDbRef.child("users").child(monexDbRef.push().key).update({
      "email": state.email,
      "password": Crypter.encrypt(state.password!),
      "isSetUp": true,
    });
    return true;
  }

  void inputValueChanged(String value, int object) {
    if (object == 1) {
      state.email = value;
      return;
    }
    if (object == 2) {
      state.password = value;
      return;
    }
    if (object == 3) {
      state.rePassword = value;
    }
  }

  void radioButtonChanged() {
    state.acceptRadio = !state.acceptRadio!;
    emit(state);
  }

  void passwordEyeChanged() {
    state.passwordEyeOpen = !state.passwordEyeOpen!;
    emit(state);
  }

  void rePasswordEyeChanged() {
    state.rePasswordEyeOpen = !state.rePasswordEyeOpen!;
    emit(state);
  }
}
