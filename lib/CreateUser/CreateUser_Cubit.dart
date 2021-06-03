import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monex/Components/ErrorCode.dart';
import 'package:monex/Components/User.dart';

class CreateUserModel {
  User user;
  String firstName = "";
  String lastName = "";
  CreateUserModel(this.user);
}

class CreateUserCubit extends Cubit<CreateUserModel> {
  CreateUserCubit(CreateUserModel initialState) : super(initialState);

  void onFormSubmit(String firstName, String lastName) async {
    state.firstName = firstName;
    state.lastName = lastName;
    if (firstName.isEmpty || lastName.isEmpty) {
      throw Exception();
    }
  }

  Future<bool> saveAvatarToLocal() async {
    await state.user.updateAvatarFromServer().catchError((_) => false);
    return true;
  }
}
