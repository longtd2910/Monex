import 'dart:core';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:monex/Components/ErrorCode.dart';

import '../utils/function.dart';
import 'package:monex/Components/User.dart' as LocalComponent;

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
  ClientSignUpError error;
  ClientSideSignUpException(this.error);
}

class ServerSideSignUpException implements Exception {
  ServerSignUpError error;
  ServerSideSignUpException(this.error);
}

class SignUpCubit extends Cubit<SignUpModel> {
  SignUpCubit(SignUpModel initialState) : super(initialState);

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

  Future<List?> startFacebookLogin() async {
    final AccessToken? accessToken = await FacebookAuth.instance.accessToken;
    if (accessToken != null) {
      var user = await FirebaseAuth.instance.signInWithCredential(FacebookAuthProvider.credential(accessToken.token));
      var data = await FacebookAuth.instance.getUserData();
      return [user, data];
    }
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        // you are logged
        final AccessToken accessToken = result.accessToken!;
        var user = await FirebaseAuth.instance.signInWithCredential(FacebookAuthProvider.credential(accessToken.token));
        var data = await FacebookAuth.instance.getUserData();
        return [user, data];
      }
      if (result.status == LoginStatus.cancelled) {
        return null;
      }
    } on Exception {
      throw ServerSideSignUpException(ServerSignUpError.UnknownError);
    }
  }

  Future<List?> startGoogleLogin() async {
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      var user = await FirebaseAuth.instance.signInWithCredential(credential);
      return [user, googleUser.displayName, googleUser.email, googleUser.photoUrl];
    } on Exception {
      throw ServerSideSignUpException(ServerSignUpError.UnknownError);
    }
  }

  Future<UserCredential> startEmailSignUp(String email, String password, String rePassword) async {
    state.email = email;
    state.password = password;
    state.rePassword = rePassword;

    if (!EmailValidator.validate(state.email!)) {
      throw ClientSideSignUpException(ClientSignUpError.EmailInvalid);
    }

    if (state.password!.length < 6) {
      throw ClientSideSignUpException(ClientSignUpError.PasswordTooWeak);
    }

    if (state.password!.length > 16) {
      throw ClientSideSignUpException(ClientSignUpError.PasswordTooLong);
    }

    if (state.password!.trim().length != state.password!.length) {
      throw ClientSideSignUpException(ClientSignUpError.PasswordTrim);
    }

    if (state.password!.compareTo(state.rePassword!) != 0) {
      throw ClientSideSignUpException(ClientSignUpError.RePasswordWrong);
    }

    if (!state.acceptRadio!) {
      throw ClientSideSignUpException(ClientSignUpError.TermsOfServicesUnCheck);
    }
    UserCredential emailUser = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: state.email!,
      password: state.password!,
    )
        .catchError((error) {
      if ((error as FirebaseAuthException).code == 'email-already-in-use') {
        throw ServerSideSignUpException(ServerSignUpError.EmailRegistered);
      }
      throw ServerSideSignUpException(ServerSignUpError.UnknownError);
    });
    return emailUser;
  }

  Future<void> addUserToDatabase(LocalComponent.User user) async {
    try {
      DatabaseReference monexDbRef = FirebaseDatabase.instance.reference();
      monexDbRef.child("users").update({
        user.userId: {"isSetUp": true}
      });
    } on Exception catch (e) {
      throw ServerSideSignUpException(ServerSignUpError.UnknownError);
    }
  }
}
