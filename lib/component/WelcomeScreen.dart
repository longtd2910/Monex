import 'package:flutter/material.dart';
import 'package:monex/view/WelcomeScreenView.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>  implements WelcomeScreenView{
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }

  @override
  void swipePage(int pageIndicator) {
      // TODO: implement swipePage
    }
  
    @override
    void updatePropertise(String imageAsset, String title, String description) {
    // TODO: implement updatePropertise
  }
}