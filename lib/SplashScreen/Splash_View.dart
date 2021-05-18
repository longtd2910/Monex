import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:monex/SplashScreen/Splash_Cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Add 1-time delay
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) => context.read<SplashCubit>().appear(context));

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: SvgPicture.asset(
                  'assets/drawable/Main/AppLogo-Blue.svg',
                ),
              ),
              Container(
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
