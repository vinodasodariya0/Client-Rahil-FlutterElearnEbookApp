import 'package:elearn/widgets/component.dart';
import 'package:elearn/widgets/models_providers .dart';
import 'package:elearn/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool theme = false;
  bool notification = false;

  @override
  void initState() {
    // TODO: implement initState
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    super.initState();
  }

  changeThemeMode(bool theme) {
    if (!theme) {
      _animationController.forward(from: 0.0);
    } else {
      _animationController.reverse(from: 1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final themeProvider = Provider.of<ThemeProvider>(context);
    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: height,
        width: width,
        child: Stack(
          children: [
            TitleBar(
                ontap: () {
                  Navigator.pop(context);
                },
                image: 'assets/images/previous.svg',
                appbartitle: 'Theme'),
            Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: width * 0.35,
                  height: width * 0.35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        colors: themeProvider.themeMode().gradient,
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight),
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(145, 80),
              child: ScaleTransition(
                scale: _animationController.drive(
                  Tween<double>(begin: 0.0, end: 1.0).chain(
                    CurveTween(curve: Curves.decelerate),
                  ),
                ),
                alignment: Alignment.topRight,
                child: Container(
                  width: width * .30,
                  height: width * .30,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: themeProvider.isLightTheme
                          ? Colors.white
                          : Color(0xFF26242e)),
                ),
              ),
            ),
            Positioned(
              top: 220,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Notitxt(
                        txt: 'App Theme',
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ZAnimatedToggle(
                        values: ['Light', 'Dark'],
                        onToggleCallback: (v) async {
                          await themeProvider.toggleThemeData();
                          setState(() {});
                          changeThemeMode(themeProvider.isLightTheme);
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}

class Notitxt extends StatelessWidget {
  Notitxt({this.txt});

  final String txt;

  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      style: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 15,
          fontWeight: FontWeight.w700,
          // color: Theme.of(context).textSelectionColor,
          decoration: TextDecoration.none),
    );
  }
}
