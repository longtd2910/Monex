import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'Splash_Cubit.dart';

class SplashView extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;

  const SplashView(this.screenHeight, this.screenWidth);

  @override
  _SplashViewState createState() => _SplashViewState(screenHeight, screenWidth);
}

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
  final double screenHeight;
  final double screenWidth;

  var _firebaseInitialization;

  _SplashViewState(this.screenHeight, this.screenWidth);

  appLogoDisplay() => Container(
        child: SvgPicture.asset(
          'assets/drawable/Main/AppLogo-Blue.svg',
          height: (screenHeight * 15 / 100),
        ),
      );

  appNameDisplay() => Container(
        padding: EdgeInsets.only(
          top: 16,
        ),
        child: BlocBuilder<SplashCubit, double>(
          builder: (context, state) {
            return AnimatedOpacity(
              opacity: state,
              duration: Duration(milliseconds: 800),
              child: Text(
                AppLocalizations.of(context)!.appName,
                style: TextStyle(
                  color: Color(0xff00AEEF),
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                ),
              ),
            );
          },
        ),
      );

  @override
  void initState() {
    super.initState();
  }

  late BuildContext showListContext;

  @override
  Widget build(BuildContext context) {
    //Add 1-time delay
    WidgetsBinding.instance!.addPostFrameCallback(
      (timeStamp) async {
        //Start "monex" display animation
        context.read<SplashCubit>().appear();
      },
    );
    _firebaseInitialization = Firebase.initializeApp();
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          child: Center(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  appLogoDisplay(),
                  appNameDisplay(),
                  FutureBuilder(
                      future: _firebaseInitialization,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          Future.delayed(
                            Duration(milliseconds: 700),
                            () {
                              Navigator.pushNamed(context, '/signup');
                            },
                          );
                          //move to next screen
                        }
                        if (snapshot.hasError) {
                          log('Firebase initialization failed ' + snapshot.error.toString());
                          //move to offline mode
                        }
                        return Container(
                          padding: EdgeInsets.only(
                            top: 32,
                          ),
                          child: SizedBox(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff00AEEF)),
                              strokeWidth: 2.2,
                            ),
                            height: screenHeight * 3 / 100,
                            width: screenHeight * 3 / 100,
                          ),
                        );
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
