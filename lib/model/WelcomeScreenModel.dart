import '../utils/constant.dart';

class WelcomeScreenModel {
  String imageAsset;
  String title;
  String description;
  int slideIndicator = 0;

  WelcomeScreenModel(this.imageAsset, this.title, this.description);

  bool movePage(bool direction) {
    if (!direction) {
      if (slideIndicator == 0) {
        return false;
      }
      this.slideIndicator -= 1;
      return true;
    }
    if (slideIndicator == NumConstants.MAX_WELCOME_SCREEN_NUMBER - 1) {
      return false;
    }
    this.slideIndicator += 1;
    return true;
  }
}
