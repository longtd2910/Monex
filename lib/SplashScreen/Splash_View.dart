import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';

import '../SignUpScreen/SignUp_page.dart';
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
              duration: Duration(milliseconds: 300),
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
    WidgetsBinding.instance!.addPostFrameCallback(
      (timeStamp) async {
        //Start "monex" display animation
        //take 800ms to fully show "monex"
        context.read<SplashCubit>().appear();
        //Stay at splash screen for 1000ms
        Future.delayed(Duration(milliseconds: 200), () {
          final page = SignUpPage();
          Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade, child: page, duration: Duration(milliseconds: 800)));
        });
      },
    );
  }

  late BuildContext showListContext;

  @override
  Widget build(BuildContext context) {
    //Add 1-time delay
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
