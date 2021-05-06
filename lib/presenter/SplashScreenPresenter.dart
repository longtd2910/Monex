import 'package:monex/model/SplashScreenModel.dart';
import 'package:monex/view/SplashScreenView.dart';
import 'package:monex/utils/constant.dart' as Constants;

class SplashScreenPresenter {
  void onDelayComplete() async {}
  set splashScreenView(SplashScreenView view) {}
}

class BasicSplashScreenPresenter implements SplashScreenPresenter {
  SplashScreenModel _model;
  SplashScreenView _view;

  BasicSplashScreenPresenter() {
    this._model = SplashScreenModel(Constants.StringConstants.APP_NAME, Constants.StringConstants.ASSET_LOGO_BLUE);
  }

  @override
  set splashScreenView(SplashScreenView view) {
    _view = view;
    _view.updatePropertise(_model.logoAssets, _model.appName, _model.appNameVisibility);
  }

  @override
  void onDelayComplete() {
    _model.appNameVisibility = !_model.appNameVisibility;
    _view.updateAppNameVisibility(_model.appNameVisibility);
  }
}
