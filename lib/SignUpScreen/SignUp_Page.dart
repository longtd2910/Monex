import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'SignUp_Cubit.dart';
import 'SignUp_View.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignUpCubit(new SignUpModel()),
      child: SignUpView(
        MediaQuery.of(context).size.height,
        MediaQuery.of(context).size.width,
      ),
    );
  }
}
