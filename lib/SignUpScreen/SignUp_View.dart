import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'SignUp_Cubit.dart';

class SignUpView extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;

  const SignUpView(this.screenHeight, this.screenWidth);
  @override
  _SignUpViewState createState() => _SignUpViewState(screenHeight, screenWidth);
}

class _SignUpViewState extends State<SignUpView> {
  final double screenHeight;
  final double screenWidth;

  var inputStyle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 16,
    color: Colors.black.withOpacity(0.5),
  );

  var inputContainerMargin;
  var inputContainerDecor;
  _SignUpViewState(this.screenHeight, this.screenWidth);

  @override
  Widget build(BuildContext context) {
    var emailInputController = new TextEditingController();
    var passwordInputController = new TextEditingController();
    var rePasswordInputController = new TextEditingController();

    inputContainerMargin = EdgeInsets.only(top: 40);
    inputContainerDecor = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          spreadRadius: 2,
          blurRadius: 4,
        )
      ],
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(child: BlocBuilder<SignUpCubit, SignUpModel>(
        builder: (context, state) {
          return Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 40,
                  ),
                  height: screenHeight * 16 / 100,
                  child: SvgPicture.asset(
                    'assets/drawable/Main/AppLogo-Blue.svg',
                    height: (screenHeight * 15 / 100),
                  ),
                ),
                Container(
                  decoration: inputContainerDecor,
                  margin: inputContainerMargin,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                    right: 16,
                    left: 16,
                  ),
                  height: screenHeight * 5 / 100,
                  width: screenWidth * 75 / 100,
                  child: Center(
                    child: TextField(
                      controller: emailInputController,
                      decoration: InputDecoration.collapsed(
                        hintText: AppLocalizations.of(context)!.emailHolder,
                      ),
                      style: inputStyle,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                    right: 16,
                    left: 16,
                  ),
                  height: screenHeight * 5 / 100,
                  decoration: inputContainerDecor,
                  margin: inputContainerMargin,
                  width: screenWidth * 75 / 100,
                  child: TextField(
                    controller: passwordInputController,
                    decoration: InputDecoration.collapsed(
                      hintText: AppLocalizations.of(context)!.passwordHolder,
                    ),
                    style: inputStyle,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                    right: 16,
                    left: 16,
                  ),
                  height: screenHeight * 5 / 100,
                  decoration: inputContainerDecor,
                  margin: inputContainerMargin,
                  width: screenWidth * 75 / 100,
                  child: TextField(
                    controller: rePasswordInputController,
                    decoration: InputDecoration.collapsed(
                      hintText: AppLocalizations.of(context)!.rePassewordHolder,
                    ),
                    style: inputStyle,
                  ),
                ),
                Container(
                  height: screenHeight * 10 / 100,
                  width: screenWidth * 80 / 100,
                  child: Row(
                    children: [
                      Checkbox(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: state.acceptRadio,
                        onChanged: (value) {
                          context.read<SignUpCubit>().radioButtonChanged();
                          setState(() {});
                        },
                      ),
                      Text(
                        (AppLocalizations.of(context)!.agree + " "),
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: "Montserrat",
                          color: Colors.black,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          print("term and licences");
                        },
                        child: Text(
                          AppLocalizations.of(context)!.termAndLicenses,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: screenHeight * 5 / 100,
                  width: screenWidth * 40 / 100,
                  child: ElevatedButton(
                    child: Text(
                      AppLocalizations.of(context)!.signUp,
                    ),
                    onPressed: context.read<SignUpCubit>().signUpInProgress,
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      )),
                      backgroundColor: MaterialStateProperty.all(
                        Color(0xff00AEEF),
                      ),
                      textStyle: MaterialStateProperty.all(
                        TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.or.toUpperCase(),
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: screenHeight * 10 / 100,
                  margin: EdgeInsets.only(bottom: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        iconSize: 50,
                        icon: Container(
                          padding: EdgeInsets.all(10),
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              width: 0.5,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ),
                          child: SvgPicture.asset(
                            'assets/drawable/ThirdParty/google.svg',
                            height: 27,
                            alignment: Alignment.center,
                          ),
                        ),
                        onPressed: () {
                          print("Google pressed");
                        },
                      ),
                      IconButton(
                        iconSize: 50,
                        icon: Container(
                          padding: EdgeInsets.all(10),
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              width: 0.5,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ),
                          child: SvgPicture.asset(
                            'assets/drawable/ThirdParty/facebook.svg',
                            height: 27,
                            alignment: Alignment.center,
                          ),
                        ),
                        onPressed: () {
                          print("Facebook pressed");
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    bottom: 16,
                  ),
                  child: InkWell(
                    child: Text(
                      AppLocalizations.of(context)!.alreadyHaveAccount,
                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 14, decoration: TextDecoration.underline),
                    ),
                    onTap: () {
                      print("Login Redirect");
                    },
                  ),
                )
              ],
            ),
          );
        },
      )),
    );
  }
}
