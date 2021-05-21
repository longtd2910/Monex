import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Splash_Cubit.dart';
import 'Splash_View.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashCubit(),
      child: SplashView(MediaQuery.of(context).size.height, MediaQuery.of(context).size.width),
    );
  }
}
