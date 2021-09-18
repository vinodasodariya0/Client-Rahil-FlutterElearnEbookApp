import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models_providers .dart';

class Textrich extends StatelessWidget {
  Textrich({
    this.fontsize1,
    this.fontsize2,
    this.txt1,
    this.txt2,
    @required this.context,
  });

  final double fontsize1;
  final double fontsize2;
  final String txt1;
  final String txt2;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return RichText(
      overflow: TextOverflow.ellipsis,
      softWrap: true,
      maxLines: 2,
      textAlign: TextAlign.start,
      text: TextSpan(
        // ignore: deprecated_member_use
        style: Theme.of(context).textTheme.display1,
        children: [
          TextSpan(
            text: txt1,
            style: TextStyle(
              fontSize: fontsize1,
              color: themeProvider.isLightTheme ? Colors.black : Colors.white,
              fontFamily: "Nunito",
            ),
          ),
          TextSpan(
              text: txt2,
              style: TextStyle(
                color: themeProvider.isLightTheme ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: fontsize2,
              ))
        ],
      ),
    );
  }
}
