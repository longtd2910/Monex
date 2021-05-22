import 'package:flutter/material.dart';

class TextFieldTest extends StatefulWidget {
  @override
  _TextFieldTestState createState() => _TextFieldTestState();
}

class _TextFieldTestState extends State<TextFieldTest> {
  final myControl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: TextField(
            controller: myControl,
          ),
        ),
      ),
    );
  }
}
