import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monex/CreateUser/CreateUser_Cubit.dart';
import 'package:monex/CreateUser/CreateUser_View.dart';

class CreateUserPage extends StatelessWidget {
  final CreateUserCubit cubit;
  CreateUserPage(this.cubit);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => cubit,
      child: CreateUserView(
        MediaQuery.of(context).size.height,
        MediaQuery.of(context).size.width,
      ),
    );
  }
}
