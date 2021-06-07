import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:monex/Components/ErrorCode.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:monex/Components/User.dart';
import 'package:monex/CreateUser/AnimationWidget.dart';
import 'package:monex/CreateUser/CreateUser_Cubit.dart';
import 'package:monex/main.dart';
import 'package:monex/utils/CustomView.dart';

class CreateUserView extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  CreateUserView(this.screenHeight, this.screenWidth);
  @override
  _CreateUserViewState createState() => _CreateUserViewState(this.screenHeight, this.screenWidth);
}

class _CreateUserViewState extends State<CreateUserView> with TickerProviderStateMixin {
  _CreateUserViewState(this.screenHeight, this.screenWidth);

  late final AppLocalizations lang;
  final double screenHeight;
  final double screenWidth;
  final inputContainerMargin = EdgeInsets.all(8);
  final mainComponentMargin = EdgeInsets.only(top: 24, bottom: 24);
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
  Gender genderSelect = Gender.Male;
  String firstNameLabel = "";
  String lastNameLabel = "";
  late Future<bool> update;
  double opacity = 0.4;
  void loadLocalization() async {
    lang = await AppLocalizations.delegate.load(Locale('en', 'US'));
  }

  final ScrollController scrollCut = new ScrollController();
  final TransformationController _controller = new TransformationController();
  void promptPictureChoice(File chosenFile) async {
    Image img = Image.file(
      chosenFile,
      fit: BoxFit.cover,
    );
    var decodedImage = await decodeImageFromList(chosenFile.readAsBytesSync());
    Axis scrollDirection = Axis.vertical;
    // if (decodedImage.height > decodedImage.width) {
    //   img = Image.file(
    //     chosenFile,
    //     width: screenHeight * 30 / 100,
    //     fit: Box,
    //   );
    // } else {
    //   scrollDirection = Axis.horizontal;
    //   img = Image.file(
    //     chosenFile,
    //     height: screenHeight * 30 / 100,
    //   );
    // }
    showDialog<String>(
      context: context,
      builder: (BuildContext bc) => AlertDialog(
        contentPadding: EdgeInsets.all(8),
        title: Container(
          child: Center(
            child: Text("Choose this image?"),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: screenHeight * 30 / 100,
              width: screenHeight * 30 / 100,
              color: Colors.blue,
              child: InteractiveViewer(
                transformationController: _controller,
                minScale: 1.0,
                maxScale: 2.0,
                onInteractionUpdate: (details) {
                  print(details.scale);
                },
                child: Container(child: img),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 18,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _controller.value..setEntry(0, 3, 2);
                  },
                  child: Text(
                    "Done",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadLocalization();
    if (context.read<CreateUserCubit>().state.user.avatarLink != null) {
      update = context.read<CreateUserCubit>().state.user.updateAvatarFromServer();
    } else {
      Future<bool> noInputProvided() async => false;
      update = noInputProvided();
    }
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
    lastNameLabel = lang.lastName;
    firstNameLabel = lang.firstName;
    if (context.read<CreateUserCubit>().state.user.firstName!.length == 0) {
      lastNameLabel = "";
    }
    if (context.read<CreateUserCubit>().state.user.lastName!.length == 0) {
      firstNameLabel = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // * Greeting line
                Container(
                  margin: EdgeInsets.only(bottom: 24),
                  child: Text(
                    lang.createUserGreeting,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 24,
                    ),
                  ),
                ),
                // * Avatar
                Container(
                  margin: mainComponentMargin,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        opacity = 0.8;
                        Future.delayed(Duration(milliseconds: 100)).then((value) {
                          setState(() {
                            opacity = 0.4;
                          });
                        });
                      });
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext bc) {
                          return SafeArea(
                            child: Container(
                              child: Wrap(
                                children: [
                                  ListTile(
                                    leading: Icon(Icons.photo_library),
                                    title: Text(lang.chooseImageGallery),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.photo_camera),
                                    title: Text(lang.chooseImageCamera),
                                    onTap: () async {
                                      File? image = await context.read<CreateUserCubit>().state.user.imageFromCamera();
                                      if (image != null) {
                                        context.read<CreateUserCubit>().state.user.uploadToFireStorage(image);
                                        setState(() {
                                          update = context.read<CreateUserCubit>().state.user.uploadToFireStorage(image);
                                        });
                                        Navigator.pop(context);
                                        promptPictureChoice(image);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: BlocBuilder<CreateUserCubit, CreateUserModel>(
                      builder: (context, state) {
                        return FutureBuilder(
                          future: update,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 60,
                                child: SvgPicture.asset(
                                  'assets/drawable/Main/AppLogo-Blue.svg',
                                ),
                              );
                            }
                            if (snapshot.connectionState == ConnectionState.done) {
                              if (snapshot.data == false) {
                                return CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 60,
                                  child: SvgPicture.asset(
                                    'assets/drawable/Main/AppLogo-Blue.svg',
                                  ),
                                );
                              }
                              return ClipOval(
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 60,
                                      backgroundImage: FileImage(
                                        File(state.user.avatarLocalPath!),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      child: Container(
                                          height: 25,
                                          width: 100,
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              AnimatedOpacity(
                                                duration: Duration(milliseconds: 100),
                                                opacity: opacity,
                                                child: Container(
                                                  color: Colors.black,
                                                  height: 25,
                                                  width: 100,
                                                ),
                                              ),
                                              Icon(
                                                Icons.camera_alt,
                                                color: Colors.grey,
                                                size: 20,
                                              ),
                                            ],
                                          )),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 60,
                              child: SvgPicture.asset(
                                'assets/drawable/Main/AppLogo-Blue.svg',
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                // * Name input fields
                Container(
                  margin: EdgeInsets.only(right: 8, left: 8, top: 24, bottom: 24),
                  child: Row(
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
                              width: screenWidth * 38 / 100,
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
                              width: screenWidth * 38 / 100,
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
                              padding: EdgeInsets.all(0),
                              iconSize: screenHeight * 2.5 / 100,
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
                  ),
                ),
                // *Gender radio group
                Container(
                  margin: mainComponentMargin,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: ListTile(
                          title: Row(
                            children: [
                              Radio<Gender>(
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                value: Gender.Male,
                                groupValue: genderSelect,
                                onChanged: (Gender? value) {
                                  setState(() {
                                    genderSelect = context.read<CreateUserCubit>().radioButtonSelectionChanged(value!);
                                  });
                                },
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 8),
                                child: Text(
                                  lang.genderMale,
                                  style: inputStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: ListTile(
                          title: Row(
                            children: [
                              Radio<Gender>(
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                value: Gender.Female,
                                groupValue: genderSelect,
                                onChanged: (Gender? value) {
                                  setState(() {
                                    genderSelect = context.read<CreateUserCubit>().radioButtonSelectionChanged(value!);
                                  });
                                },
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 8),
                                child: Text(
                                  lang.genderFemale,
                                  style: inputStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: ListTile(
                          title: Row(
                            children: [
                              Radio<Gender>(
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                value: Gender.Other,
                                groupValue: genderSelect,
                                onChanged: (Gender? value) {
                                  setState(() {
                                    genderSelect = context.read<CreateUserCubit>().radioButtonSelectionChanged(value!);
                                  });
                                },
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 8),
                                child: Text(
                                  lang.genderOther,
                                  style: inputStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // *Submit button
                Container(
                  margin: mainComponentMargin,
                  height: screenHeight * 5 / 100,
                  width: screenWidth * 45 / 100,
                  child: ElevatedButton(
                    child: Text(
                      lang.getStarted,
                    ),
                    onPressed: () {},
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
                // *Adjuster blank space
                Container(
                  height: screenHeight * 10 / 100,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
