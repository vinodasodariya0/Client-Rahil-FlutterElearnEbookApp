import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:elearn/generated/l10n.dart';
import 'package:elearn/screens/home_screen.dart';
import 'package:elearn/widgets/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../consttants.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  WebViewController _webViewController;
  String privacypolicy;
  FacebookLogin facebookLogin = FacebookLogin();
  var uid;
  String nam;
  String imageUrl;
  String phone;
  String mail;
  TextEditingController tx;
  TextEditingController tx2;
  TextEditingController forget;
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

  _loadHtmlFromAssets() async {
    _webViewController.loadUrl(Uri.dataFromString(privacypolicy,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }

  bool visi = false;

  @override
  void initState() {
    Plat();
    // TODO: implement initState
    tx = TextEditingController(text: '');
    tx2 = TextEditingController(text: '');
    forget = TextEditingController(text: '');
    AppleSignIn.onCredentialRevoked.listen((_) {
      ("Credentials revoked");
    });
    super.initState();
  }

  void Plat() {
    if (Platform.isAndroid) {
      visi = false;
    } else {
      visi = true;
    }
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> handleLogin() async {
    try {
      final FacebookLoginResult result = await facebookLogin.logIn(['email']);
      switch (result.status) {
        case FacebookLoginStatus.cancelledByUser:
          break;
        case FacebookLoginStatus.error:
          (FacebookLoginStatus.error);

          break;
        case FacebookLoginStatus.loggedIn:
        case FacebookLoginStatus.loggedIn:
          try {
            (result);
            final FacebookAccessToken accessToken = result.accessToken;
            AuthCredential credential =
                FacebookAuthProvider.credential(accessToken.token);

            final UserCredential authResult =
                await _auth.signInWithCredential(credential);
            final User _user = authResult.user;

            if (_user != null) {
              // Checking if email and name is null
              assert(_user.email != null);
              assert(_user.displayName != null);
              assert(_user.photoURL != null);

              nam = _user.displayName;
              mail = _user.email;

              imageUrl = _user.photoURL;
              phone = _user.phoneNumber;

              //  uid = _user.uid;
              String authId = _user.uid;
              SharedPreferences pre = await SharedPreferences.getInstance();
              // int user_id = int.parse(uid);
              // pre.setInt('uid', user_id);
              pre.setString("type", "GOOGLE");
              pre.setString('photo', imageUrl);
              pre.setString('mail', mail);
              pre.setString('name', nam);
              pre.setString('phone', phone);
              //$mainapilink/user_register_api.php?name=john&email=john@gmail.com&password=123456&phone=1234567891&auth_id=00000&type=Google

              final String bASEURL =
                  "$mainapilink/user_register_api.php?user_image=$imageUrl&name=$nam&email=$mail&password=&phone=$phone&auth_id=$authId&type=Facebook";
              var response = await http.get(Uri.parse(bASEURL));
              var jsonResponse = convert.jsonDecode(response.body);
              var second = jsonResponse["EBOOK_APP"];

              var success = second[0]["success"];
              p = success;
              msg = second[0]["MSG"];
              int userID = int.parse(second[0]["user_id"]);

              pre.setInt("uid", userID);
              pre.setString("type", "GOOGLE");

              if (p == '1') {
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.setString('email', mail);
                Navigator.pop(context);

                //   pre.setString("type", "GOOGLE");
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return HomeScreen();
                })).then((value) => Fluttertoast.showToast(
                    msg: '$mail Logged In Successfully',
                    backgroundColor: Colors.black,
                    fontSize: 20,
                    gravity: ToastGravity.BOTTOM,
                    textColor: Colors.white,
                    toastLength: Toast.LENGTH_LONG));
              } else {
                Navigator.pop(context);

                Fluttertoast.showToast(
                    msg: '$msg problem in signin',
                    backgroundColor: Colors.black,
                    fontSize: 20,
                    gravity: ToastGravity.BOTTOM,
                    textColor: Colors.white,
                    toastLength: Toast.LENGTH_LONG);
              }

              // Only taking the first part of the name, i.e., First Name
              if (nam.contains(" ")) {
                nam = nam.substring(0, nam.indexOf(" "));
              }

              assert(!_user.isAnonymous);
              assert(await _user.getIdToken() != null);

              final User currentUser = _auth.currentUser;
              assert(_user.uid == currentUser.uid);
            }
          } catch (e) {
            Navigator.pop(context);
            var i = e.toString();
            int ind = i.lastIndexOf("]");
            if (ind > 0) i = i.substring(ind + 1);

            Fluttertoast.showToast(
                msg: i,
                backgroundColor: Colors.black,
                fontSize: 20,
                gravity: ToastGravity.BOTTOM,
                textColor: Colors.white,
                toastLength: Toast.LENGTH_LONG);
          }
          break;
      }
    } catch (e) {
      Navigator.pop(context);
      ('ERROR IN FAQCE BOOK $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        // appBar: PreferredSize(
        //   child: Container(
        //     height: 50,
        //     width: size.width,
        //     decoration: BoxDecoration(
        //       image: DecorationImage(
        //           image: AssetImage("assets/images/Login background.png"),
        //           fit: BoxFit.cover),
        //     ),
        //   ),
        //   preferredSize: size,
        // ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/images/Login background.png"),
            fit: BoxFit.cover,
          )),
          child: ModalProgressHUD(
            inAsyncCall: spin,
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowGlow();
              },
              child: CustomScrollView(
                  shrinkWrap: true,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.manual,
                  physics: AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          // ConstrainedBox(
                          //   constraints: BoxConstraints(
                          //       maxHeight: MediaQuery.of(context).size.height,
                          //       maxWidth: MediaQuery.of(context).size.width),
                          //   child: Image.asset(
                          //     "assets/images/Login background.png",
                          //     width: MediaQuery.of(context).size.width,
                          //     height: MediaQuery.of(context).size.height,
                          //     fit: BoxFit.cover,
                          //   ),
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Padding(
                              //   padding: const EdgeInsets.only(right: 10.0),
                              //   child: FlatButton(
                              //     shape: RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.circular(10)),
                              //     color: Colors.white,
                              //     child: Text(
                              //       S.of(context).loginPage_SKIP,
                              //       overflow: TextOverflow.ellipsis,
                              //       style: TextStyle(
                              //           fontFamily: 'Nunito',
                              //           color: Colors.black,
                              //           fontWeight: FontWeight.bold),
                              //     ),
                              //     onPressed: () {
                              //       Navigator.pushReplacement(context,
                              //           MaterialPageRoute(builder: (context) {
                              //         return HomeScreen();
                              //       }));
                              //     },
                              //   ),
                              // ),
                            ],
                          ),
                          Container(
                              height: MediaQuery.of(context).size.height * 0.4,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/images/123.gif"),
                                    fit: BoxFit.cover),
                              )),
                          Container(
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                ///textfield
                                Textf(
                                  tx: tx,
                                  mic: 'assets/images/Vector.png',
                                  obse: false,
                                  hint: S.of(context).loginPage_emailHint,
                                ),

                                Textf(
                                  tx: tx2,
                                  mic: 'assets/images/Group.png',
                                  obse: true,
                                  hint: S.of(context).loginPage_passwordHint,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerRight,
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: Text(
                                        S
                                            .of(context)
                                            .loginPage_TROUBLE_IN_LOGIN,
                                        textAlign: TextAlign.right,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontFamily: "Nunito",
                                            color: Colors.black,
                                            fontSize: 15),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: TextButton(
                                          onPressed: () {
                                            Alert(
                                                context: context,
                                                style: AlertStyle(
                                                    titleStyle: TextStyle(
                                                        fontFamily:
                                                            "Helvetica Neue",
                                                        color: Colors.black,
                                                        fontSize: 26),
                                                    backgroundColor:
                                                        Colors.white,
                                                    alertElevation: 0,
                                                    isButtonVisible: true),
                                                title: S
                                                    .of(context)
                                                    .loginPage_forgot_ENTER_YOUR_EMAIL,
                                                content: Column(
                                                  children: <Widget>[
                                                    Textf(
                                                      tx: forget,
                                                      mic:
                                                          'assets/images/email.png',
                                                      obse: false,
                                                      hint: S
                                                          .of(context)
                                                          .loginPage_emailHint,
                                                    ),
                                                  ],
                                                ),
                                                buttons: [
                                                  DialogButton(
                                                    width: 173,
                                                    height: 50,
                                                    radius:
                                                        BorderRadius.circular(
                                                            14),
                                                    color: Color(0xff2055AD),
                                                    onPressed: () async {
                                                      if (!mounted) return;
                                                      setState(() {
                                                        spin = true;
                                                      });

                                                      final String bASEURL =
                                                          "$mainapilink/user_forgot_pass_api.php?email=${forget.text}";
                                                      var response = await http
                                                          .get(Uri.parse(
                                                              bASEURL));
                                                      var jsonResponse =
                                                          convert.jsonDecode(
                                                              response.body);
                                                      var second = jsonResponse[
                                                          "EBOOK_APP"];
                                                      var success =
                                                          second[0]["success"];
                                                      p = success;
                                                      msg = second[0]["MSG"];
                                                      ('...............$p');
                                                      (msg);
                                                      if (p == '1') {
                                                        Navigator.pop(context);
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg: msg,
                                                            backgroundColor:
                                                                Colors.black,
                                                            fontSize: 20,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            textColor:
                                                                Colors.white,
                                                            toastLength: Toast
                                                                .LENGTH_LONG);
                                                      }
                                                      forget.text = '';
                                                      forget.clear();
                                                      if (!mounted) return null;
                                                      setState(() {
                                                        spin = false;
                                                      });
                                                    },
                                                    child: Text(
                                                      S
                                                          .of(context)
                                                          .loginPage_forgot_APPLY_button,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 20),
                                                    ),
                                                  )
                                                ]).show();
                                          },
                                          child: Text(
                                            S
                                                .of(context)
                                                .loginPage_FORGOT_PASSWORD,
                                            style: TextStyle(
                                                fontFamily: "Nunito",
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700),
                                          )),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 70,
                                  child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Button(
                                            press: () {
                                              bottom();
                                            },
                                            buttonname:
                                                S.of(context).loginPage_SIGNUP,
                                          ),
                                          Button(
                                            buttonname:
                                                S.of(context).loginPage_LOGIN,
                                            press: () async {
                                              (forget.text);
                                              if (!mounted) return;
                                              setState(() {
                                                spin = true;
                                              });

                                              final String bASEURL =
                                                  "$mainapilink/user_login_api.php?email=${tx.text}&password=${tx2.text}&type=Normal";
                                              var response = await http
                                                  .get(Uri.parse(bASEURL));
                                              var jsonResponse = convert
                                                  .jsonDecode(response.body);
                                              var second =
                                                  jsonResponse["EBOOK_APP"];
                                              var success =
                                                  second[0]["success"];
                                              var user_id =
                                                  second[0]["user_id"];
                                              var name = second[0]["name"];
                                              var p = success;
                                              msg = second[0]["MSG"];
                                              ('...............$p');
                                              (msg);
                                              if (p == '1') {
                                                SharedPreferences pref =
                                                    await SharedPreferences
                                                        .getInstance();
                                                int uid = int.parse(user_id);
                                                pref.setInt('uid', uid);
                                                ('UID +============================$uid');
                                                pref.setString(
                                                    'email', tx.text);
                                                pref.setString('name', name);
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return HomeScreen();
                                                })).then((value) =>
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            '${tx.text} ${S.of(context).loginPage_LOGIN_SUCCESS_toast}',
                                                        backgroundColor:
                                                            Colors.black,
                                                        fontSize: 20,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        textColor: Colors.white,
                                                        toastLength:
                                                            Toast.LENGTH_LONG));
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg: msg,
                                                    backgroundColor:
                                                        Colors.black,
                                                    fontSize: 20,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    textColor: Colors.white,
                                                    toastLength:
                                                        Toast.LENGTH_LONG);
                                              }
                                              forget.text = '';
                                              forget.clear();
                                              if (!mounted) return null;
                                              setState(() {
                                                spin = false;
                                              });
                                            },
                                          ),
                                        ],
                                      )),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () async {
                                        if (!mounted) return null;
                                        setState(() {
                                          spin = true;
                                        });
                                        final GoogleSignInAccount
                                            googleSignInAccount =
                                            await googleSignIn.signIn();
                                        final GoogleSignInAuthentication
                                            googleSignInAuthentication =
                                            await googleSignInAccount
                                                .authentication;

                                        final AuthCredential credential =
                                            GoogleAuthProvider.credential(
                                          accessToken:
                                              googleSignInAuthentication
                                                  .accessToken,
                                          idToken: googleSignInAuthentication
                                              .idToken,
                                        );

                                        final UserCredential authResult =
                                            await _auth.signInWithCredential(
                                                credential);
                                        final User user = authResult.user;
                                        var userid =
                                            authResult.user.providerData[0].uid;
                                        String authId = user.uid;
                                        (authId);
                                        (userid);

                                        if (user != null) {
                                          // Checking if email and name is null
                                          assert(user.email != null);
                                          assert(user.displayName != null);
                                          assert(user.photoURL != null);

                                          nam = user.displayName;
                                          mail = user.email;
                                          imageUrl = user.photoURL;
                                          phone = user.phoneNumber;
                                          var _email = user.email;

                                          SharedPreferences pre =
                                              await SharedPreferences
                                                  .getInstance();
                                          //int user_id = int.parse(uid);

                                          pre.setString('photo', imageUrl);
                                          pre.setString('mail', mail);
                                          pre.setString('email', _email);
                                          pre.setString('name', nam);
                                          pre.setString('phone', phone);

                                          final String bASEURL =
                                              "$mainapilink/user_register_api.php?user_image=$imageUrl&name=$nam&email=$mail&password=&phone=$phone&auth_id=$authId&type=Google";
                                          var response = await http
                                              .get(Uri.parse(bASEURL));
                                          var jsonResponse =
                                              convert.jsonDecode(response.body);
                                          var second =
                                              jsonResponse["EBOOK_APP"];

                                          var success = second[0]["success"];
                                          p = success;
                                          msg = second[0]["MSG"];
                                          int userID =
                                              int.parse(second[0]["user_id"]);
                                          pre.setInt("uid", userID);
                                          pre.setString("type", "GOOGLE");

                                          if (p == '1') {
                                            SharedPreferences pref =
                                                await SharedPreferences
                                                    .getInstance();
                                            pref.setString('email', mail);
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return HomeScreen();
                                            })).then((value) =>
                                                Fluttertoast.showToast(
                                                    msg:
                                                        '$mail ${S.of(context).loginPage_LOGIN_SUCCESS_toast}',
                                                    backgroundColor:
                                                        Colors.black,
                                                    fontSize: 20,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    textColor: Colors.white,
                                                    toastLength:
                                                        Toast.LENGTH_LONG));
                                          } else {
                                            Fluttertoast.showToast(
                                                msg:
                                                    '$msg ${S.of(context).loginPage_PROBLEM_IN_SIGNIN_toast}',
                                                backgroundColor: Colors.black,
                                                fontSize: 20,
                                                gravity: ToastGravity.BOTTOM,
                                                textColor: Colors.white,
                                                toastLength: Toast.LENGTH_LONG);
                                          }

                                          if (nam.contains(" ")) {
                                            nam = nam.substring(
                                                0, nam.indexOf(" "));
                                          }

                                          assert(!user.isAnonymous);
                                          assert(
                                              await user.getIdToken() != null);

                                          final User currentUser =
                                              _auth.currentUser;
                                          assert(user.uid == currentUser.uid);
                                          if (!mounted) return null;
                                          setState(() {
                                            spin = false;
                                          });
                                        }
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        child: Image.asset(
                                            "assets/images/google.png"),
                                      ),
                                    ),
                                    // SizedBox(
                                    //   width: 50,
                                    // ),
                                    // GestureDetector(
                                    //   onTap: () {
                                    //     handleLogin();
                                    //   },
                                    //   child: Container(
                                    //     height: 40,
                                    //     width: 40,
                                    //     child: Image.asset(
                                    //         "assets/images/facebook.png"),
                                    //   ),
                                    // ),
                                    Visibility(
                                      visible: visi,
                                      child: SizedBox(
                                        width: 50,
                                      ),
                                    ),
                                    Platform.isIOS
                                        ? GestureDetector(
                                            onTap: () async {
                                              try {
                                                var cred =
                                                    await signInWithApple();
                                              } catch (e) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text('$e')));
                                                (e);
                                              }
                                            },
                                            child: Container(
                                              height: 30,
                                              width: 30,
                                              child: Image.asset(
                                                  "assets/images/apple_logo.png"),
                                            ),
                                          )
                                        : Container(
                                            height: 0,
                                            width: 0,
                                          ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _launchURL(
                                              "https://www.freeprivacypolicy.com/blog/privacy-policy-url/");
                                        },
                                        child: Text('Privacy Policy',
                                            style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Colors.black,
                                            )),
                                      ),
                                      // can add more TextSpans here...
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                        ],
                        addRepaintBoundaries: true,
                      ),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  appleSignIn(String appleName, String appleEmail, String authId) async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    String name = appleName;
    if (name == null) {
      name = "User";
      pre.setString('email', appleEmail);
      pre.setString('name', name);
    } else {
      pre.setString('email', appleEmail);
      pre.setString('name', name);
    }

    final String bASEURL =
        "$mainapilink/user_register_api.php?name=$appleName&email=$appleEmail&password=&phone=&auth_id=$authId&type=Apple";
    var response = await http.get(Uri.parse(bASEURL));
    var jsonResponse = convert.jsonDecode(response.body);
    var second = jsonResponse["EBOOK_APP"];
    var success = second[0]["success"];
    p = success;
    msg = second[0]["MSG"];
    int userID = int.parse(second[0]["user_id"]);
    pre.setInt("uid", userID);
    pre.setString("type", "APPLE");

    (msg);
    if (p == '1') {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('email', appleEmail);
      Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
        return HomeScreen();
      }), ModalRoute.withName('/'))
          .then((value) => Fluttertoast.showToast(
              msg: '$appleEmail ${S.of(context).loginPage_LOGIN_SUCCESS_toast}',
              backgroundColor: Colors.black,
              fontSize: 20,
              gravity: ToastGravity.BOTTOM,
              textColor: Colors.white,
              toastLength: Toast.LENGTH_LONG));
    } else {
      Fluttertoast.showToast(
          msg: '$msg ${S.of(context).loginPage_PROBLEM_IN_SIGNIN_toast}',
          backgroundColor: Colors.black,
          fontSize: 20,
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG);
    }
  }

  signInWithApple() async {
    // 1. perform the sign-in request
    List<Scope> scopes = const [];
    final result = await AppleSignIn.performRequests([
      AppleIdRequest(
        requestedScopes: [
          Scope.email,
          Scope.fullName,
        ],
        requestedOperation: OpenIdOperation.operationLogin,
      ),
    ]);
    // 2. check the result
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final appleIdCredential = result.credential;
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode),
        );
        UserCredential authResult =
            await _auth.signInWithCredential(credential);
        final firebaseUser = authResult.user;

        if (scopes.contains(Scope.fullName)) {
          final displayName =
              '${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}';
          await firebaseUser.updateProfile(displayName: displayName);
        }
        String appleName = firebaseUser.displayName;
        String appleEmail = firebaseUser.email;
        String authId = firebaseUser.uid;

        final String bASEURL =
            "$mainapilink/user_register_api.php?name=${appleName != null ? appleName : ''}&email=${appleEmail != null ? appleEmail : ''}&password=&phone=&auth_id=$authId&type=Apple";
        var response = await http.get(Uri.parse(bASEURL));
        var jsonResponse = convert.jsonDecode(response.body);
        var second = jsonResponse["EBOOK_APP"];

        var success = second[0]["success"];
        p = success;
        msg = second[0]["MSG"];
        var dataname = second[0]["name"];
        var dataemail = second[0]["email"];
        var datauserID = second[0]["user_id"];
        SharedPreferences pref = await SharedPreferences.getInstance();
        if (dataname.toString().isEmpty && dataemail.toString().isEmpty) {
          AppleDialouge(uid: authId);
          pref.setString('email', appleEmail);
        } else {
          pref.setString('email', dataemail);
          pref.setString('name', dataname);
          pref.setInt("uid", int.parse(datauserID));
          pref.setString("type", "APPLE");
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
            return HomeScreen();
          }), ModalRoute.withName('/'));
        }

        return authResult;
      case AuthorizationStatus.error:
        throw PlatformException(
          code: 'ERROR_AUTHORIZATION_DENIED',
          message: result.error.toString(),
        );

      case AuthorizationStatus.cancelled:
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      default:
        throw UnimplementedError();
    }
  }

  final _form = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phonenum = TextEditingController();
  var login;
  var msg;
  var p;
  bool spin = false;

  // ignore: missing_return
  Widget bottom() {
    showMaterialModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        expand: true,
        builder: (context) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: SafeArea(
                child: SingleChildScrollView(
                    controller: ModalScrollController.of(context),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 5.0,
                            sigmaY: 5.0,
                          ),
                          child: Container(
                            color: Colors.white54.withOpacity(0.8),
                            alignment: Alignment.topCenter,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              height: MediaQuery.of(context).size.height * 0.68,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10),
                                  Text(
                                    S.of(context).loginPage_SIGNUP,
                                    style: TextStyle(
                                        fontSize: 35,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Nunito',
                                        color: Colors.black87),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Textf(
                                    tx: name,
                                    mic: 'assets/images/User.png',
                                    obse: false,
                                    hint: S.of(context).loginPage_nameHint,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Textf(
                                    tx: email,
                                    mic: 'assets/images/Vector.png',
                                    obse: false,
                                    hint: S.of(context).loginPage_emailHint,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Textf(
                                    tx: password,
                                    mic: 'assets/images/Group.png',
                                    obse: true,
                                    hint: S.of(context).loginPage_passwordHint,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Textf(
                                    tx: phonenum,
                                    mic: 'assets/images/Phone.png',
                                    obse: false,
                                    hint: S.of(context).loginPage_phoneHint,
                                  ),

                                  SizedBox(
                                    height: 8,
                                  ),
                                  //login button
                                  ModalProgressHUD(
                                    inAsyncCall: spin,
                                    child: Button(
                                      buttonname: S.of(context).loginPage_LOGIN,
                                      press: () async {
                                        if (!mounted) return;
                                        setState(() {
                                          spin = true;
                                        });

                                        final String bASEURL =
                                            "$mainapilink/user_register_api.php?name=${name.text}&email=${email.text}&password=${password.text}&phone=${phonenum.text}&type=Normal";
                                        var response =
                                            await http.get(Uri.parse(bASEURL));
                                        SharedPreferences pre =
                                            await SharedPreferences
                                                .getInstance();
                                        var jsonResponse =
                                            convert.jsonDecode(response.body);
                                        var second = jsonResponse["EBOOK_APP"];
                                        login = second[0]["user_id"];
                                        var user_id = second[0]['user_id'];
                                        var o = second[0]["success"];
                                        p = o;
                                        msg = second[0]["msg"];

                                        if (p.toString().contains('1')) {
                                          pre.setInt('uid', int.parse(user_id));
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                              Fluttertoast.showToast(
                                                  msg: msg,
                                                  backgroundColor: Colors.black,
                                                  fontSize: 20,
                                                  gravity: ToastGravity.BOTTOM,
                                                  textColor: Colors.white,
                                                  toastLength:
                                                      Toast.LENGTH_LONG);
                                              return HomeScreen();
                                            }),
                                          );
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: msg,
                                              backgroundColor: Colors.black,
                                              fontSize: 20,
                                              gravity: ToastGravity.BOTTOM,
                                              textColor: Colors.white,
                                              toastLength: Toast.LENGTH_LONG);
                                        }

                                        name.text = '';
                                        email.text = '';
                                        password.text = '';
                                        phonenum.text = '';
                                        if (!mounted) return;
                                        setState(() {
                                          spin = false;
                                        });
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ))),
              ),
            ));
  }

  Widget AppleDialouge({var uid}) {
    showMaterialModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        expand: true,
        builder: (context) => Form(
              key: _form,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SafeArea(
                  child: SingleChildScrollView(
                      controller: ModalScrollController.of(context),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 5.0,
                              sigmaY: 5.0,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 70, right: 10, left: 10, bottom: 40),
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.white54.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 15),

                                        Textf(
                                          tx: name,
                                          mic: 'assets/images/person.png',
                                          obse: false,
                                          formkey: _form,
                                          hint:
                                              S.of(context).loginPage_nameHint,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Textf(
                                          tx: email,
                                          formkey: _form,
                                          mic: 'assets/images/Vector.png',
                                          obse: false,
                                          hint:
                                              S.of(context).loginPage_emailHint,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),

                                        //login button
                                        ModalProgressHUD(
                                          inAsyncCall: spin,
                                          child: Button(
                                            buttonname: S
                                                .of(context)
                                                .loginPage_forgot_APPLY_button,
                                            press: () async {
                                              if (!_form.currentState
                                                  .validate()) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content: Text(
                                                          'Processing Data')),
                                                );
                                              } else {
                                                if (!mounted) return;
                                                setState(() {
                                                  spin = true;
                                                });

                                                appleSignIn(
                                                    name.text, email.text, uid);

                                                (name.text);
                                                (email.text);

                                                name.text = '';
                                                email.text = '';
                                                if (!mounted) return;
                                                setState(() {
                                                  spin = false;
                                                });
                                              }
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ))),
                ),
              ),
            ));
  }
}

class Textf extends StatelessWidget {
  const Textf({
    this.hint,
    this.mic,
    this.icon,
    this.obse,
    this.formkey,
    @required this.tx,
  });

  final TextEditingController tx;
  final String hint;
  final String mic;
  final IconData icon;
  final bool obse;
  final formkey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'empty';
          }
          return null;
        },
        onChanged: (result) {},
        controller: tx,
        autofocus: false,
        obscureText: obse,
        decoration: new InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Image.asset(
              mic,
              height: 50,
              width: 50,
              fit: BoxFit.contain,
              // allowDrawingOutsideViewBox: true,
            ),
          ),
          prefixIconConstraints: BoxConstraints(maxHeight: 40, maxWidth: 40),
          hintText: hint,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          hintStyle: TextStyle(
              color: Colors.black45,
              fontFamily: "Nunito",
              fontWeight: FontWeight.w700),
          fillColor: Colors.black45,
          border: OutlineInputBorder(
            gapPadding: 5,
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(color: buttonColor, width: 3),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(color: buttonColor, width: 3),
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        style: new TextStyle(
          fontFamily: "Poppins",
          color: Colors.black54,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}
