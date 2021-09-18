import 'dart:convert';
import 'dart:convert' as convert;
import 'dart:io';
import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:elearn/generated/l10n.dart';
import 'package:elearn/model/Profile.dart';
import 'package:elearn/screens/login.dart';
import 'package:elearn/screens/setting/download.dart';
import 'package:elearn/screens/setting/favourite.dart';
import 'package:elearn/screens/setting/language.dart';
import 'package:elearn/screens/setting/notification.dart';
import 'package:elearn/screens/setting/profile.dart';
import 'package:elearn/widgets/models_providers%20.dart';
import 'package:elearn/widgets/title.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../consttants.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  String privacypolicy;

  bool spin = false;
  String email;
  String image;
  String name;
  String phonenumber;
  SharedPreferences prefs;
  String type;
  int user_id;

  pre() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    email = pref.getString('email');
    image = pref.getString('photo');
    name = pref.getString('name');
    phonenumber = pref.getString('phone');
    type = pref.getString('type');
    setState(() {});
  }

  share() async {
    if (!mounted) return;
    setState(() {
      spin = true;
    });
    var response =
        await http.get(Uri.parse('$mainapilink/api.php?app_details'));
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      var second = jsonResponse["EBOOK_APP"];
      privacypolicy = second[0]["app_privacy_policy"];

      if (!mounted) return;
      setState(() {
        spin = false;
      });
    } else {
      ('Request failed with status: ${response.statusCode}.');
    }
  }

  WebViewController _webViewController;

  @override
  void initState() {
    // TODO: implement initState
    share();
    pre();
    super.initState();
  }

  Future<ProfileModel> getUserProfile() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    user_id = pref.getInt('uid');
    (user_id);
    var response = await http
        .get(Uri.parse("$mainapilink/user_profile_api.php?id=$user_id"));
    if (response.statusCode == 200) {
      ('BODY :${response.body}');

      return profileModelFromJson(response.body);
    } else {
      ('Request failed with status: ${response.statusCode}.');
    }
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  FacebookLogin facebookLogin = FacebookLogin();

  signOutGoogle() async {
    await FirebaseAuth.instance.signOut();
    await _auth.signOut().then((onValue) {
      setState(() {
        facebookLogin.logOut();
      });
    });
    setState(() {
      spin = false;
    });
    ("User Signed Out");
  }

  _loadHtmlFromAssets() async {
    _webViewController.loadUrl(Uri.dataFromString(privacypolicy,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }

  String getAppShare() {
    if (Platform.isIOS) {
      return appShareIOS;
    } else {
      return appShareAndroid;
    }
  }

  int count = 0;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    getUserProfile();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor:
            themeProvider.isLightTheme ? Color(0xFFFFFFFF) : Color(0xFF26242e),
        title: TitleBar(
          ontap: null,
          appbartitle: "Setting",
          image: 'assets/images/setting.svg',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Icon(
                Icons.favorite,
                color: Colors.redAccent,
                size: 35,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: Duration(microseconds: 800),
                      transitionsBuilder:
                          (context, animation, animationTime, child) {
                        animation = CurvedAnimation(
                            curve: Curves.elasticOut, parent: animation);
                        return ScaleTransition(
                            scale: animation,
                            alignment: Alignment.center,
                            child: child);
                      },
                      pageBuilder: (context, animation, animationTime) {
                        return ReadTodoScreen();
                      },
                    ));
              },
            ),
          )
        ],
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          // color: themeProvider.isLightTheme
          //     ? Color(0xFFFFFFFF)
          //     : Color(0xFF26242e),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: themeProvider.isLightTheme
                      ? AssetImage('assets/images/bgWhite.png')
                      : AssetImage('assets/images/bgBlack.png'),
                  fit: BoxFit.cover)),
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowGlow();
            },
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Align(
                      child: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40.0, vertical: 15),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 60,
                                    backgroundColor: buttonColorAccent,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(90),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black,
                                            ),
                                          ],
                                        ),
                                        child: FutureBuilder<ProfileModel>(
                                          future: getUserProfile(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Container(
                                                // color: Colors.black,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.3,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(80),
                                                  child: type == "GOOGLE"
                                                      ? Image.network(
                                                          image,
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image.network(
                                                          snapshot
                                                                      .data
                                                                      .ebookApp[
                                                                          0]
                                                                      .userImage ==
                                                                  null
                                                              ? 'https://images.unsplash.com/photo-1611674600319-a74611913036?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=2134&q=80'
                                                              : snapshot
                                                                          .data
                                                                          .ebookApp[
                                                                              0]
                                                                          .userImage !=
                                                                      ""
                                                                  ? snapshot
                                                                      .data
                                                                      .ebookApp[
                                                                          0]
                                                                      .userImage
                                                                  : 'https://images.unsplash.com/photo-1611674600319-a74611913036?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=2134&q=80',
                                                          fit: BoxFit.cover,
                                                        ),
                                                ),
                                              );
                                            } else if (snapshot.hasData ==
                                                null) {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            } else {
                                              return Container();
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  FutureBuilder<ProfileModel>(
                                    future: getUserProfile(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Container(
                                          alignment: Alignment.center,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          child: Text(
                                            snapshot.data.ebookApp[0].name ==
                                                    null
                                                ? ""
                                                : "${snapshot.data.ebookApp[0].name.toUpperCase()}",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: "Nunito",
                                            ),
                                          ),
                                        );
                                      } else if (snapshot.hasData == null) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 60,
                          ),
                          user_id == null
                              ? Container()
                              : Settinglist(
                                  txt: S.of(context).setting_PROFILE,
                                  ic: "assets/images/profile.svg",
                                  ontap: () {
                                    Navigator.of(context)
                                        .push(
                                      MaterialPageRoute(
                                        builder: (context) => Profile(
                                          image: image,
                                          name: name,
                                          email: email,
                                          phonenumber: phonenumber,
                                        ),
                                      ),
                                    )
                                        .then((value) {
                                      return setState(() {});
                                    });
                                  },
                                ),
                          Settinglist(
                            txt: S.of(context).setting_DOWNLOAD,
                            ic: "assets/images/down.svg",
                            ontap: () {
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration:
                                        Duration(microseconds: 800),
                                    transitionsBuilder: (context, animation,
                                        animationTime, child) {
                                      animation = CurvedAnimation(
                                          curve: Curves.elasticOut,
                                          parent: animation);
                                      return ScaleTransition(
                                          scale: animation,
                                          alignment: Alignment.center,
                                          child: child);
                                    },
                                    pageBuilder:
                                        (context, animation, animationTime) {
                                      return Download();
                                    },
                                  ));
                            },
                          ),
                          Settinglist(
                            txt: "theme",
                            ic: "assets/images/theme.svg",
                            ontap: () {
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration:
                                        Duration(microseconds: 800),
                                    transitionsBuilder: (context, animation,
                                        animationTime, child) {
                                      animation = CurvedAnimation(
                                          curve: Curves.elasticOut,
                                          parent: animation);
                                      return ScaleTransition(
                                          scale: animation,
                                          alignment: Alignment.center,
                                          child: child);
                                    },
                                    pageBuilder:
                                        (context, animation, animationTime) {
                                      return Notifications();
                                    },
                                  ));
                            },
                          ),
                          Settinglist(
                            txt: S.of(context).setting_LANGUAGE,
                            ic: "assets/images/language.svg",
                            ontap: () {
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration:
                                        Duration(microseconds: 800),
                                    transitionsBuilder: (context, animation,
                                        animationTime, child) {
                                      animation = CurvedAnimation(
                                          curve: Curves.elasticOut,
                                          parent: animation);
                                      return ScaleTransition(
                                          scale: animation,
                                          alignment: Alignment.center,
                                          child: child);
                                    },
                                    pageBuilder:
                                        (context, animation, animationTime) {
                                      return Language();
                                    },
                                  ));
                            },
                          ),
                          Settinglist(
                            txt: S.of(context).setting_SHARE,
                            ic: "assets/images/share.svg",
                            ontap: () async {
                              await FlutterShare.share(
                                  title: S.of(context).setting_share_SHARE,
                                  text: S.of(context).setting_share_SHARE_TEXT,

                                  ///your app link
                                  linkUrl: getAppShare(),
                                  chooserTitle:
                                      S.of(context).setting_share_TITLE);
                            },
                          ),
                          Settinglist(
                            txt: S.of(context).setting_PRIVACY_POLICY,
                            ic: "assets/images/policy.svg",
                            ontap: () {
                              AwesomeDialog(
                                width: MediaQuery.of(context).size.width,
                                isDense: true,
                                context: context,
                                animType: AnimType.SCALE,
                                dialogType: DialogType.INFO,
                                body: Container(
                                  height: 510,
                                  width: MediaQuery.of(context).size.width,
                                  child: WebView(
                                    initialUrl: '',
                                    javascriptMode: JavascriptMode.unrestricted,
                                    onWebViewCreated:
                                        (WebViewController webViewController) {
                                      _webViewController = webViewController;
                                      _loadHtmlFromAssets();
                                    },
                                  ),
                                ),
                                title: S.of(context).setting_privacy_IGNORED,
                                desc:
                                    S.of(context).setting_privacy_ALSO_IGNORED,
                                btnOkOnPress: () {},
                              )..show();
                            },
                          ),
                          user_id == null
                              ? Settinglist(
                                  txt: S.of(context).loginPage_LOGIN,
                                  ic: "assets/images/logout.svg",
                                  ontap: () {
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: (context) {
                                      return Login();
                                    }));
                                  },
                                )
                              : Settinglist(
                                  txt: S.of(context).setting_LOGOUT,
                                  ic: "assets/images/logout.svg",
                                  ontap: () {
                                    if (email != null) {
                                      Alert(
                                        context: context,
                                        type: AlertType.warning,
                                        title: S
                                            .of(context)
                                            .setting_logout_ARE_YOU_SURE,
                                        desc: S
                                            .of(context)
                                            .setting_logout_LOGOUT_WITH_EBOOK,
                                        buttons: [
                                          DialogButton(
                                            child: Text(
                                              S
                                                  .of(context)
                                                  .setting_logout_CANCEL,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            color: Color.fromRGBO(
                                                0, 179, 134, 1.0),
                                          ),
                                          DialogButton(
                                            child: Text(
                                              S.of(context).setting_LOGOUT,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                            onPressed: () async {
                                              setState(() {
                                                spin = true;
                                              });

                                              signOutGoogle()
                                                  .then((value) async {
                                                SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                prefs.remove('email');
                                                prefs.remove('photo');
                                                prefs.remove('name');
                                                prefs.remove('uid');
                                                prefs.clear();
                                                prefs.containsKey('email') ==
                                                        false
                                                    ? Navigator
                                                        .pushAndRemoveUntil<
                                                            void>(
                                                        context,
                                                        MaterialPageRoute<void>(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                Login()),
                                                        ModalRoute.withName(
                                                            '/'),
                                                      )
                                                    : Fluttertoast.showToast(
                                                        msg: S
                                                            .of(context)
                                                            .setting_logout_FAILED_TO_LOGOUT_toast,
                                                        backgroundColor:
                                                            Colors.black,
                                                        fontSize: 20,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        textColor: Colors.white,
                                                        toastLength:
                                                            Toast.LENGTH_LONG);
                                              });
                                              setState(() {
                                                spin = false;
                                              });
                                            },
                                            gradient: LinearGradient(colors: [
                                              Color.fromRGBO(
                                                  116, 116, 191, 1.0),
                                              Color.fromRGBO(52, 138, 199, 1.0)
                                            ]),
                                          )
                                        ],
                                      ).show();
                                    } else {
                                      Navigator.pushAndRemoveUntil<void>(
                                        context,
                                        MaterialPageRoute<void>(
                                            builder: (BuildContext context) =>
                                                Login()),
                                        ModalRoute.withName('/'),
                                      );
                                    }
                                  },
                                ),
                        ],
                      ),
                      alignment: Alignment.topCenter,
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

class Settinglist extends StatelessWidget {
  Settinglist({this.txt, this.ic, this.ontap});

  final String txt;
  final String ic;
  final Function ontap;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 0),
      child: Row(
        children: [
          SvgPicture.asset(
            ic,
            color: themeProvider.isLightTheme ? Colors.black54 : Colors.white,
          ),
          SizedBox(
            width: 5,
          ),
          TextButton(
              onPressed: ontap,
              child: Text(
                txt,
                style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: themeProvider.isLightTheme
                        ? Colors.black54
                        : Colors.white),
              ))
        ],
      ),
    );
  }
}
