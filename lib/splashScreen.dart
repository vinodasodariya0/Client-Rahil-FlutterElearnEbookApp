import 'package:elearn/screens/home_screen.dart';
import 'package:elearn/screens/login.dart';
import 'package:flutter/material.dart';

class Splash_Screen extends StatefulWidget {
  Splash_Screen({
    this.email,
  });

  String email;

  @override
  _Splash_ScreenState createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {
  @override
  void initState() {
    Future.delayed(
        Duration(
          seconds: 4,
        ), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => widget.email != null ? HomeScreen() : Login(),
      ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/1234.png"),
                  fit: BoxFit.cover)),
          //child: Image.asset("assets/images/1234.png"),
        ),
      ),
    );
  }
}
