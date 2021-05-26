import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monex/Components/User.dart';

class CreateUserModel {
  User root;
  String firstName = "";
  String lastName = "";
  CreateUserModel(this.root);
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
}
