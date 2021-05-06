import 'package:monex/component/SplashScreen.dart';

class SplashScreenModel {
  String _appName;
  String _logoAssets;
  bool appNameVisibility = false;

  String get appName => _appName;
  String get logoAssets => _logoAssets;

  SplashScreenModel(this._appName, this._logoAssets);
}
