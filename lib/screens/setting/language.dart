import 'package:elearn/generated/l10n.dart';
import 'package:elearn/screens/home_screen.dart';
import 'package:elearn/widgets/models_providers%20.dart';
import 'package:elearn/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../consttants.dart';

class Language extends StatefulWidget {
  const Language({Key key}) : super(key: key);

  @override
  _LanguageState createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  SharedPreferences pref;

  _init() async {
    pref = await SharedPreferences.getInstance();
  }

  List<Map<String, dynamic>> language = [
    {'flag': 'en', 'language': 'English', 'set1': 'en', 'set2': 'EN'},
    {'flag': 'in', 'language': 'हिंदी', 'set1': 'hi', 'set2': 'HI'},
    {'flag': 'ar', 'language': 'عربى', 'set1': 'ar', 'set2': 'AR'},
    {'flag': 'de', 'language': 'Deutsche', 'set1': 'de', 'set2': 'DE'},
    {'flag': 'es', 'language': 'Española', 'set1': 'es', 'set2': 'ES'},
    {'flag': 'fr', 'language': 'français', 'set1': 'fr', 'set2': 'FR'},
    {'flag': 'ja', 'language': '日本語', 'set1': 'ja', 'set2': 'JA'},
    {'flag': 'ru', 'language': 'русский', 'set1': 'ru', 'set2': 'RU'},
    {'flag': 'th', 'language': 'ทาฮี', 'set1': 'th', 'set2': 'TH'},
    {'flag': 'ur', 'language': 'اردو', 'set1': 'ur', 'set2': 'UR'},
    {'flag': 'zh', 'language': '中國人', 'set1': 'zh', 'set2': 'ZH'},
    {'flag': 'in', 'language': 'தமிழ்', 'set1': 'ta', 'set2': 'TA'},
    {'flag': 'in', 'language': 'తెలుగు', 'set1': 'te', 'set2': 'TE'},
    {'flag': 'in', 'language': 'ಕನ್ನಡ', 'set1': 'kn', 'set2': 'KN'},
    {'flag': 'ko', 'language': '한국어', 'set1': 'ko', 'set2': 'KO'},
  ];

  int count;

  @override
  void initState() {
    // TODO: implement initState
    _init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    if (count == null) count = themeProvider.languageCount;

    return Material(
      child: SafeArea(
          child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color:
            themeProvider.isLightTheme ? Color(0xFFFFFFFF) : Color(0xff26242e),
        child: Stack(
          children: [
            TitleBar(
              ontap: () {
                Navigator.pop(context);
              },
              image: 'assets/images/previous.svg',
              appbartitle: S.of(context).setting_LANGUAGE,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 68.0),
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 2, vertical: 15),
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      childAspectRatio: 3 / 1.7,
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          count = index;
                          themeProvider.languageSet(count);
                          S.load(Locale(language[index]['set1'],
                              language[index]['set2']));

                          pref.setInt('languageCount', count);
                        });
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                            (Route<dynamic> route) => false);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: count != index
                              ? themeProvider.isLightTheme
                                  ? kShadowColor.withOpacity(0.5)
                                  : kLightBlackColor.withOpacity(0.5)
                              : Color.fromRGBO(0, 179, 134, 1.0),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: MediaQuery.of(context).size.width * 0.18,
                              width: MediaQuery.of(context).size.width * 0.23,
                              child: Image.asset(
                                'assets/flag/${language[index]['flag']}.png',
                              ),
                            ),
                            Container(
                              child: Text(
                                language[index]['language'],
                                style: TextStyle(
                                  color: themeProvider.isLightTheme
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    itemCount: language.length,
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
