import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:elearn/screens/setting.dart';
import 'package:elearn/widgets/models_providers%20.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'explore.dart';
import 'home.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pc;

  int _page = 0;

  GlobalKey _bottomNavigationKey = GlobalKey();

  @override
  // ignore: must_call_super
  void initState() {
    pc = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final themeProvider = Provider.of<ThemeProvider>(context);
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          backgroundColor: themeProvider.isLightTheme != true
              ? Colors.transparent
              : Colors.white,
          color: themeProvider.isLightTheme != true
              ? Colors.black54
              : Colors.black54,
          height: 50,
          items: <Widget>[
            SvgPicture.asset(
              'assets/images/Home.svg',
              height: 30,
              fit: BoxFit.cover,
            ),
            SvgPicture.asset(
              'assets/images/web-browser.svg',
              height: 30,
              fit: BoxFit.cover,
              color: Colors.white,
            ),
            SvgPicture.asset(
              'assets/images/setting.svg',
              height: 30,
              fit: BoxFit.cover,
              color: themeProvider.isLightTheme ? Colors.black : Colors.white,
            ),
          ],
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
          letIndexChange: (index) => true,
        ),
        body: IndexedStack(index: _page, children: [
          ///home
          Home(size: size),

          ///secPage
          Explore(),

          ///setting
          Setting(),
        ]),
      ),
    );
  }
}
