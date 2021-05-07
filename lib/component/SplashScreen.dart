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

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin implements SplashScreenView {
  bool appNameVisibility = false;
  String appLogoAssets = "";
  String appName = "";
  double opacity = 0;

  @override
  void initState() {
    super.initState();
    this.widget.presenter.splashScreenView = this;

    //This function is called once after rendering build()
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(seconds: 2));
      setState(() {
        opacity = 1;
      });
    });
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

    Container appNameHolder = Container(
      padding: EdgeInsets.only(top: 16),
      child: Text(
        '',
        style: TextStyle(
          color: Color(0xff00AEEF),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
          fontSize: 30,
        ),
      ),
    );

    FutureBuilder builder = FutureBuilder(
      future: this.widget.presenter.displayAppNameDelay(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AnimatedOpacity(
            opacity: 1.0,
            duration: Duration(milliseconds: 4000),
            child: appNameDisplay,
          );
        }
        return appNameHolder;
      },
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
              AnimatedOpacity(
                opacity: opacity,
                duration: Duration(seconds: 1),
                child: appNameDisplay,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
