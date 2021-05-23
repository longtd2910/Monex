// @dart=2.9

import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monex/SplashScreen/Splash_Page.dart';
import 'package:page_transition/page_transition.dart';
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
  WidgetsFlutterBinding.ensureInitialized();
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
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
      initialRoute: 'signup',
      onGenerateRoute: (settings) {
        if (settings.name == 'signup') {
          final page = SignUpPage();
          return PageTransition(type: PageTransitionType.fade, child: page, duration: Duration(milliseconds: 800));
        }
        return null;
      },
      title: "Monex",
    ),
  );
}
