import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:monex/Components/ErrorCode.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:monex/CreateUser/CreateUser_Cubit.dart';

class CreateUserView extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  CreateUserView(this.screenHeight, this.screenWidth);
  @override
  _CreateUserViewState createState() => _CreateUserViewState(this.screenHeight, this.screenWidth);
}

class _CreateUserViewState extends State<CreateUserView> {
  _CreateUserViewState(this.screenHeight, this.screenWidth);

  late final AppLocalizations lang;
  final double screenHeight;
  final double screenWidth;
  final inputContainerMargin = EdgeInsets.all(8);
  final inputContainerDecor = BoxDecoration(
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
  final inputStyle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 16,
    color: Colors.black.withOpacity(0.5),
  );

  final labelStyle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 13,
    color: Colors.black.withOpacity(0.5),
  );
  final firstNameTextFieldController = new TextEditingController();
  final lastNameTextFieldController = new TextEditingController();
  String firstNameLabel = "";
  String lastNameLabel = "";
  late Future<bool> update;

  void loadLocalization() async {
    lang = await AppLocalizations.delegate.load(Locale('en', 'US'));
  }

  @override
  void initState() {
    super.initState();
    loadLocalization();
    update = context.read<CreateUserCubit>().state.user.updateAvatarFromServer();
    firstNameTextFieldController.text = context.read<CreateUserCubit>().state.user.firstName!;
    lastNameTextFieldController.text = context.read<CreateUserCubit>().state.user.lastName!;
    firstNameTextFieldController.addListener(() {
      if (firstNameTextFieldController.text.length > 0) {
        setState(() {
          firstNameLabel = lang.firstName;
          lastNameLabel = lang.lastName;
        });
      } else {
        setState(() {
          firstNameLabel = "";
          lastNameLabel = "";
        });
      }
    });
    lastNameTextFieldController.addListener(() {
      if (lastNameTextFieldController.text.length > 0) {
        setState(() {
          firstNameLabel = lang.firstName;
          lastNameLabel = lang.lastName;
        });
      } else {
        setState(() {
          firstNameLabel = "";
          lastNameLabel = "";
        });
      }
    });
    firstNameLabel = lang.firstName;
    lastNameLabel = lang.lastName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Column(
          children: [
            GestureDetector(child: BlocBuilder<CreateUserCubit, CreateUserModel>(
              builder: (context, state) {
                return FutureBuilder(
                  future: update,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SvgPicture.asset(
                        'assets/drawable/Main/AppLogo-Blue.svg',
                        height: (screenHeight * 40 / 100),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Image.file(
                        File(state.user.avatarLocalPath!),
                        height: screenHeight * 40 / 100,
                        width: screenHeight * 40 / 100,
                      );
                    }
                    return SvgPicture.asset(
                      'assets/drawable/Main/AppLogo-Blue.svg',
                      height: (screenHeight * 40 / 100),
                    );
                  },
                );
              },
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: inputContainerMargin,
                        child: Text(
                          firstNameLabel,
                          style: labelStyle,
                          textAlign: TextAlign.start,
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
                        width: screenWidth * 40 / 100,
                        child: TextField(
                          controller: firstNameTextFieldController,
                          decoration: InputDecoration.collapsed(
                            hintText: AppLocalizations.of(context)!.firstName,
                          ),
                          style: inputStyle,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: inputContainerMargin,
                        child: Text(
                          lastNameLabel,
                          style: labelStyle,
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
                        width: screenWidth * 40 / 100,
                        child: Center(
                          child: TextField(
                            controller: lastNameTextFieldController,
                            decoration: InputDecoration.collapsed(
                              hintText: AppLocalizations.of(context)!.lastName,
                            ),
                            style: inputStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Visibility(
                        child: Container(
                          margin: inputContainerMargin,
                          child: Text(
                            "",
                            style: labelStyle,
                          ),
                        ),
                        visible: true,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.swap_horiz_outlined,
                        ),
                        onPressed: () {
                          var temp = firstNameTextFieldController.text;
                          firstNameTextFieldController.text = lastNameTextFieldController.text;
                          lastNameTextFieldController.text = temp;
                        },
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
