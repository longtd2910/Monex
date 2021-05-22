// @dart=2.9

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monex/SplashScreen/Splash_Page.dart';
import 'SignUpScreen/SignUp_page.dart';
import 'SplashScreen/Splash_Observer.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  Bloc.observer = SplashObserver();
  final page = SplashPage();
  runApp(
    MaterialApp(
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
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => page,
        '/signup': (context) => SignUpPage(),
      },
      title: "Monex",
    ),
  );
}
