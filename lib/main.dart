import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monex/presenter/SplashScreenPresenter.dart';

import 'component/SplashScreen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(new MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Monex",
      home: new SplashScreen(new BasicSplashScreenPresenter()),
    );
  }
}
