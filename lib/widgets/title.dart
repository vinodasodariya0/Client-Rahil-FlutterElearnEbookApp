import 'package:elearn/widgets/models_providers%20.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class TitleBar extends StatelessWidget {
  TitleBar({this.image, this.appbartitle, @required this.ontap});

  final String image;
  final String appbartitle;
  final Function ontap;
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 5),
      child: Row(
        children: [
          GestureDetector(
            onTap: ontap,
            child: Card(
              elevation: 20,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              child: SvgPicture.asset(
                image,
                fit: BoxFit.cover,
                height: 30,
                color: themeProvider.isLightTheme
                    ? Colors.black54
                    : Colors.white54,
                width: 30,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(appbartitle,
              style: TextStyle(
                  fontSize: 25,
                  decoration: TextDecoration.none,
                  color: themeProvider.isLightTheme
                      ? Colors.black54
                      : Colors.white54,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w700))
        ],
      ),
    );
  }
}
