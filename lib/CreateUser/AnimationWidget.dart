import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:monex/utils/CustomView.dart';

class ImageContainer extends StatefulWidget {
  const ImageContainer({
    Key? key,
    required this.screenHeight,
    required this.screenWidth,
    required this.img,
    required this.scrollCut,
    required this.scrollDirection,
  }) : super(key: key);

  final double screenHeight;
  final double screenWidth;
  final Image img;
  final ScrollController scrollCut;
  final Axis scrollDirection;

  @override
  _ImageContainerState createState() => _ImageContainerState(this.screenHeight, this.screenWidth, this.img, this.scrollCut, this.scrollDirection);
}

class _ImageContainerState extends State<ImageContainer> with TickerProviderStateMixin {
  final double screenHeight;
  final double screenWidth;
  final Image img;
  final ScrollController scrollCut;
  final Axis scrollDirection;

  late AnimationController firstArrowAnimationController;
  late AnimationController secondArrowAnimationController;
  late AnimationController thirdArrowAnimationController;
  late Animation<double> firstArrowAnimation;
  late Animation<double> secondArrowAnimation;
  late Animation<double> thirdArrowAnimation;

  _ImageContainerState(this.screenHeight, this.screenWidth, this.img, this.scrollCut, this.scrollDirection);

  void setAnimationProperties() {
    // * First Arrow, from inside
    firstArrowAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    firstArrowAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1, end: 0.4), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 0.4, end: 0.1), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 0.1, end: 0.0), weight: 40),
    ]).animate(firstArrowAnimationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) async {
        if (status == AnimationStatus.completed) {
          await Future.delayed(Duration(milliseconds: 200)).then((value) {
            firstArrowAnimationController.repeat();
          });
        }
      });
    // * Second Arrow
    secondArrowAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    secondArrowAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: 1), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 1, end: 0.4), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 0.4, end: 0.0), weight: 40),
    ]).animate(secondArrowAnimationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) async {
        if (status == AnimationStatus.completed) {
          await Future.delayed(Duration(milliseconds: 200)).then((value) {
            secondArrowAnimationController.repeat();
          });
        }
      });
    // * Third Arrow
    thirdArrowAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    thirdArrowAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: 0), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: 1), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 1, end: 1), weight: 40),
    ]).animate(thirdArrowAnimationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) async {
        if (status == AnimationStatus.completed) {
          await Future.delayed(Duration(milliseconds: 200)).then((value) {
            thirdArrowAnimationController.repeat();
          });
        }
      });
  }

  void animationStart() {}
  @override
  void initState() {
    super.initState();
    setAnimationProperties();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      firstArrowAnimationController.forward();
      secondArrowAnimationController.forward();
      thirdArrowAnimationController.forward();
    });
  }

  @override
  void dispose() {
    firstArrowAnimationController.dispose();
    secondArrowAnimationController.dispose();
    thirdArrowAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Colors.blue,
            height: screenHeight * 30 / 100,
            width: screenHeight * 30 / 100,
            margin: EdgeInsets.only(bottom: 16, top: 16),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ScrollConfiguration(
                  behavior: NoGlowScrollBehavior(),
                  child: SingleChildScrollView(
                    scrollDirection: scrollDirection,
                    controller: scrollCut,
                    child: img,
                  ),
                ),
                Positioned(
                  bottom: 20 + screenHeight * 15 / 100,
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.black.withOpacity(firstArrowAnimation.value),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30 + screenHeight * 15 / 100,
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.black.withOpacity(secondArrowAnimation.value),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 40 + screenHeight * 15 / 100,
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.black.withOpacity(thirdArrowAnimation.value),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -20 + screenHeight * 15 / 100,
                  child: RotatedBox(
                    quarterTurns: -1,
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.black.withOpacity(firstArrowAnimation.value),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -30 + screenHeight * 15 / 100,
                  child: RotatedBox(
                    quarterTurns: -1,
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.black.withOpacity(secondArrowAnimation.value),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -40 + screenHeight * 15 / 100,
                  child: RotatedBox(
                    quarterTurns: -1,
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.black.withOpacity(thirdArrowAnimation.value),
                    ),
                  ),
                )
              ],
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
                onPressed: () {},
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
    );
  }
}
