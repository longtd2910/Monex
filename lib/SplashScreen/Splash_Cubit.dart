import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

class SplashCubit extends Cubit<double> {
  SplashCubit() : super(0.0);

  Future<void> appear(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 500));
    emit(1.0);
  }
}