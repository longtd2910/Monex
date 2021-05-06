import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:monex/presenter/SplashScreenPresenter.dart';
import 'package:monex/view/SplashScreenView.dart';

class SplashScreen extends StatefulWidget {
  final SplashScreenPresenter presenter;

  SplashScreen(this.presenter, {Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> implements SplashScreenView {
  bool appNameVisibility = false;
  String appLogoAssets = "";
  String appName = "";

  @override
  void initState() {
    super.initState();
    this.widget.presenter.splashScreenView = this;
  }

  @override
  void displayAppNameDelay() async {
    Future.delayed(Duration(milliseconds: 800));
  }

  @override
  void updateAppNameVisibility(bool visibility) {
    setState(() {
      appNameVisibility = visibility;
    });
  }

  @override
  void updatePropertise(String appLogoAssets, String appName, bool appNameVisibility) {
    setState(() {
      this.appLogoAssets = appLogoAssets;
      this.appName = appName;
      this.appNameVisibility = appNameVisibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    Container appLogoDisplay = Container(
      child: SvgPicture.asset(
        appLogoAssets,
      ),
    );

    Container appNameDisplay = Container(
      padding: EdgeInsets.only(
        top: 16,
      ),
      child: Text(
        appName,
        style: TextStyle(
          color: Color(0xff00AEEF),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
          fontSize: 30,
        ),
      ),
    );
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              appLogoDisplay,
              Visibility(
                child: appNameDisplay,
                visible: appNameVisibility,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
