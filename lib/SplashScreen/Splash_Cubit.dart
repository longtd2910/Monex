import 'package:bloc/bloc.dart';

class SplashCubit extends Cubit<double> {
  SplashCubit() : super(0.0);

  Future<void> appear() async {
    emit(1.0);
  }
}
