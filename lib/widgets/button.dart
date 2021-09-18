import 'package:elearn/consttants.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  Button({this.press, this.buttonname});
  final Function press;
  final String buttonname;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      focusColor: buttonColorAccent,
      minWidth: 150,
      height: 40,
      elevation: 5,
      highlightElevation: 5,
      highlightColor: Colors.white54,
      splashColor: Colors.transparent,
      colorBrightness: Brightness.light,
      onPressed: press,
      color: Color(0xff2055AD),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Text(
        buttonname,
        style: TextStyle(
            fontFamily: "Nunito",
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w700),
      ),
    );
  }
}
