import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:monex/Components/ErrorCode.dart';
import 'package:monex/Components/User.dart' as LocalComponent;
import 'package:monex/CreateUser/CreateUser_Cubit.dart';
import 'package:monex/CreateUser/CreateUser_Page.dart';
import 'package:monex/utils/function.dart';
import 'package:page_transition/page_transition.dart';

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

  final emailInputController = TextEditingController();
  final passwordInputController = TextEditingController();
  final rePasswordInputController = TextEditingController();
  final inputStyle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 16,
    color: Colors.black.withOpacity(0.5),
  );

  var inputContainerMargin;
  var inputContainerDecor;

  var _passwordEyeVisibility;

  var _rePasswordVisibility;
  _SignUpViewState(this.screenHeight, this.screenWidth);

  @override
  void initState() {
    super.initState();
    emailInputController.text = "longtd2910@gmail.com";
    passwordInputController.text = "long123";
    rePasswordInputController.text = "long123";
    _passwordEyeVisibility = false;
    _rePasswordVisibility = false;
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
    passwordInputController.addListener(() {
      if (passwordInputController.text.length > 0) {
        setState(() {
          _passwordEyeVisibility = true;
        });
        return;
      }
      if (passwordInputController.text.length == 0) {
        setState(() {
          _passwordEyeVisibility = false;
        });
      }
    });
    rePasswordInputController.addListener(() {
      if (rePasswordInputController.text.length > 0) {
        setState(() {
          _rePasswordVisibility = true;
        });
      }
      if (rePasswordInputController.text.length == 0) {
        setState(() {
          _passwordEyeVisibility = false;
        });
      }
    });
  }

  void displayErrorMessage(dynamic error) {
    String message = "";
    if (error is ClientSideSignUpException) {
      message = ClientSignUpErrorCode(error.error).errorMessage(context);
    }
    if (error is ServerSideSignUpException) {
      message = ServerSignUpErrorCode(error.error).errorMessage(context);
    }
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Center(
          child: Text(
            message,
          ),
        ),
        content: TextButton(
          child: Text("OK"),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void navigateToCreateUser(LocalComponent.User user) async {
    await context.read<SignUpCubit>().addUserToDatabase(user).catchError((error) {
      displayErrorMessage(error);
    });
    print(user);
    CreateUserCubit cubit = CreateUserCubit(new CreateUserModel(user));
    final CreateUserPage page = new CreateUserPage(cubit);
    Navigator.pushReplacement(context, PageTransition(child: page, type: PageTransitionType.rightToLeft));
  }

  void formSubmitted() async {
    UserCredential? received = await context
        .read<SignUpCubit>()
        .startEmailSignUp(emailInputController.text, passwordInputController.text, rePasswordInputController.text)
        .catchError((error) {
      displayErrorMessage(error);
    });

    LocalComponent.User user = LocalComponent.User(received.user!.uid, [LocalComponent.SignInType.Common]);
    user.email = received.user!.email;
    user.firstName = "";
    user.lastName = "";
    navigateToCreateUser(user);
  }

  void facebookLogin() async {
    List? received = await context.read<SignUpCubit>().startFacebookLogin().catchError((error) {
      displayErrorMessage(error);
    });
    UserCredential serverCred = received![0];
    print(serverCred.user!.uid);
    Map<String, dynamic> userInfo = received[1];
    LocalComponent.User user = LocalComponent.User(serverCred.user!.uid, [LocalComponent.SignInType.Facebook]);
    user.email = userInfo["email"];
    List<String> nameConvert = TypeConvert.nameConvert(userInfo["name"]);
    user.firstName = nameConvert[0];
    user.lastName = nameConvert[1];
    if (userInfo["picture"]["data"]["is_silhouette"] != 0) {
      user.avatarLink = userInfo["picture"]["data"]["url"];
    }

    navigateToCreateUser(user);
  }

  void googleLogin() async {
    List? received = await context.read<SignUpCubit>().startGoogleLogin().catchError((error) {
      displayErrorMessage(error);
    });
    UserCredential serverCred = received![0];
    LocalComponent.User user = LocalComponent.User(serverCred.user!.uid, [LocalComponent.SignInType.Google]);
    user.lastName = serverCred.additionalUserInfo!.profile!["family_name"];
    user.firstName = serverCred.additionalUserInfo!.profile!["given_name"];
    user.email = received[2];
    user.avatarLink = received[3];
    navigateToCreateUser(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Container(
            color: Colors.white,
            child: BlocBuilder<SignUpCubit, SignUpModel>(
              builder: (context, state) {
                return Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      // * App Logo
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
                      // * Email Input
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
                      // * Password Input
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
                          obscureText: !state.passwordEyeOpen!,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: AppLocalizations.of(context)!.passwordHolder,
                            suffixIcon: Visibility(
                              visible: _passwordEyeVisibility,
                              child: IconButton(
                                icon: Icon(
                                  (state.passwordEyeOpen!) ? Icons.visibility : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    context.read<SignUpCubit>().passwordEyeChanged();
                                  });
                                },
                              ),
                            ),
                          ),
                          style: inputStyle,
                        ),
                      ),
                      // * Re-enter password Input
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
                          obscureText: !state.rePasswordEyeOpen!,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: AppLocalizations.of(context)!.rePassewordHolder,
                            suffixIcon: Visibility(
                              visible: _rePasswordVisibility,
                              child: IconButton(
                                icon: Icon(
                                  (state.passwordEyeOpen!) ? Icons.visibility : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    context.read<SignUpCubit>().rePasswordEyeChanged();
                                  });
                                },
                              ),
                            ),
                          ),
                          style: inputStyle,
                        ),
                      ),
                      // * Terms of Services Box
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

                      // * Submit Button
                      Container(
                        height: screenHeight * 5 / 100,
                        width: screenWidth * 40 / 100,
                        child: ElevatedButton(
                          child: Text(
                            AppLocalizations.of(context)!.signUp,
                          ),
                          onPressed: formSubmitted,
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
                      // * "OR" Field
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
                      // * "Third-Party Sign Up Options"
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
                              onPressed: googleLogin,
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
                                facebookLogin();
                              },
                            ),
                          ],
                        ),
                      ),
                      // * Sign in Hypertext
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
            ),
          ),
        ),
      ),
    );
  }
}
