import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monex/presenter/SplashScreenPresenter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'component/SplashScreen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    localizationsDelegates: [
      AppLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: [
      const Locale('en', 'EN'),
      const Locale('vi', 'VN'),
    ],
    title: "Monex",
    home: new SplashScreen(new BasicSplashScreenPresenter()),
  ));
}
