import 'package:monex/model/WelcomeScreenModel.dart';
import 'package:monex/view/WelcomeScreenView.dart';

import '../component/SplashScreen.dart';

abstract class WelcomeScreenPresenter {
  void onPageSwap(int pageIndicator);
  set welcomeScreenView(WelcomeScreenView view);
  void setImageAsset(String assets);
  void setTitle(String title);
  void setDescription(String description);
}

class BasicWelcomeScreenPresenter implements WelcomeScreenPresenter {
  WelcomeScreenView _view;
  WelcomeScreenModel _model;
  @override
  void onPageSwap(int pageIndicator) {
    if (pageIndicator == 0) {
      
    }
  }

  @override
  void setDescription(String description) {
    // TODO: implement setDescription
  }

  @override
  void setImageAsset(String assets) {
    // TODO: implement setImageAsset
  }

  @override
  void setTitle(String title) {
    // TODO: implement setTitle
  }

  @override
  set welcomeScreenView(WelcomeScreenView view) {
    // TODO: implement welcomeScreenView
  }
}
