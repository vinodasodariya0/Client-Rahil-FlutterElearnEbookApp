import 'dart:convert' as convert;
import 'dart:io';
import 'dart:math';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:elearn/generated/l10n.dart';
import 'package:elearn/model/ContinueReadingmodel.dart';
import 'package:elearn/model/Profile.dart';
import 'package:elearn/model/detailsProvider.dart';
import 'package:elearn/screens/category.dart';
import 'package:elearn/screens/search.dart';
import 'package:elearn/screens/setting/profile.dart';
import 'package:elearn/screens/view.dart';
import 'package:elearn/widgets/beswtofday.dart';
import 'package:elearn/widgets/models_providers%20.dart';
import 'package:elearn/widgets/reading_card_list.dart';
import 'package:elearn/widgets/richtxt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:radial_button/widget/circle_floating_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../consttants.dart';
import 'details_screen.dart';
import 'griddview.dart';

class Home extends StatefulWidget {
  Home({this.size});

  final Size size;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _hasSpeech = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = '';
  String lastError = '';
  String lastStatus = '';
  String _currentLocaleId = '';
  int resultListened = 0;
  final SpeechToText speech = SpeechToText();
  TextEditingController tx;

  String resultText = "";
  var conname;
  var conid;
  String image;
  String name;
  String phone;
  String continueImage;
  String email;
  int user_id;
  String type;
  SharedPreferences prefs;

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

  prfrences() async {
    prefs = await SharedPreferences.getInstance();
    SharedPreferences pref = await SharedPreferences.getInstance();
    type = pref.getString("type");
    conname = pref.getString('continuename');
    conid = pref.getInt('continueid');
    image = pref.getString('photo');
    name = pref.getString('name');
    email = pref.getString('email');
    continueImage = pref.getString('continueimage');
    phone = pref.getString('phone');

    ("get values>>>>>>>>>>>>>>>>$conname");
    if (!mounted) return;
    setState(() {});
  }

  @override
  void initState() {
    getUserProfile();
    hello2();
    // hello(id: 1);
    // hello(id: 2);
    // TODO: implement initState
    tx = TextEditingController(text: '');
    prfrences();
    if (!mounted) return;
    setState(() {});
    initSpeechState();
    category();
    bannerImage();

    super.initState();
    bannerSize = AdmobBannerSize.BANNER;

    bannerAd = AdmobBanner(
      adUnitId: getBannerAdUnitId(),
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        //  if (event == AdmobAdEvent.closed) bannerAd.();
        // Ads.handleEvent(event, args, 'Banner', scaffoldState, showSnackBar);
      },
      adSize: bannerSize,
    );
  }

  void showSnackBar(String content) {
    scaffoldState.currentState.showSnackBar(
      SnackBar(
        content: Text(content),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  bool spin = false;
  List cat = [];

  category() async {
    if (!mounted) return;
    setState(() {
      spin = true;
    });
    var response = await http.get(Uri.parse('$mainapilink/api.php?cat_list'));
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      var second = jsonResponse["EBOOK_APP"];
      cat = second;
      // (cat);
      if (!mounted) return;
      setState(() {
        spin = false;
      });
    } else {
      ('Request failed with status: ${response.statusCode}.');
    }
  }

  List today = [];
  List today2 = [];
  List today3 = [];
  List today4 = [];
  List bestofday = [];

  bannerImage() async {
    if (!mounted) return;
    setState(() {
      spin = true;
    });
    var response = await http.get(Uri.parse('$mainapilink/api.php?home'));
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      var itemCount = jsonResponse["EBOOK_APP"]["featured_books"];
      var second = jsonResponse["EBOOK_APP"]["latest_books"];

      today = itemCount;
      bestofday = second;
      //  (today);
      if (!mounted) return;
      setState(() {
        spin = false;
      });
    } else {
      ('Request failed with status: ${response.statusCode}');
    }
    //////////////////////////////////////////////////////////////////////////////////
    /// new add home section
  }

  List booklist;
  bool spin1;

  Future<dynamic> hello2() async {
    if (!mounted) return;
    setState(() {
      spin1 = true;
    });
    var response2 = await http.get(Uri.parse(
        //    "http://vocsyinfotech.website/envanto/admin_panel/ebook/api.php?method_name=home_section_id&homesection_id=1&page=1"));
        '$mainapilink/api.php?method_name=home_section'));

    if (response2.statusCode == 200) {
      ("**************${response2.statusCode}");

      var jsonResponse = convert.jsonDecode(response2.body);
      ("**************${response2.statusCode}");
      booklist = jsonResponse["EBOOK_APP"];
      ('lodiii $booklist');

      ("_____$booklist");
      ("${response2.body}");
      if (!mounted) return;
    } else {
      ('Request failed with status: ${response2.statusCode}.');
    }
    if (!mounted) return;
    setState(() {
      spin1 = false;
    });
  }

  Future<ContinueReading> getcontinusReading() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    user_id = pref.getInt('uid');
    try {
      var response1 = await http.get(Uri.parse(
          "$mainapilink/api.php?con_reding_book&con_read_user_id=$user_id"));
      if (response1.statusCode == 200) {
        return continueReadingFromJson(response1.body);
        //return detailsHomeSectionFromJsresponse1.body);
      } else {
        ('Request failed with status: ${response1.statusCode}.');
      }
    } catch (e) {
      ('ERROR === $e');
    }
  }

  void errorListener(SpeechRecognitionError error) {
    // ("Received error status: $error, listening: ${speech.isListening}");
    setState(() {
      lastError = '${error.errorMsg}';
    });
    Fluttertoast.showToast(
        msg: lastError,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future<void> initSpeechState() async {
    getUserProfile();
    if (!mounted) return;
    setState(() {
      spin = true;
    });
    var hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener, debugLogging: true);
    if (hasSpeech) {
      var systemLocale = await speech.systemLocale();
      _currentLocaleId = systemLocale.localeId;
    }

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
      spin = false;
    });
  }

  bool search = false;
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  AdmobBannerSize bannerSize;
  AdmobBanner bannerAd;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    var itemsActionBar = [
      FloatingActionButton(
        heroTag: null,
        mini: true,
        backgroundColor: Colors.indigoAccent,
        onPressed: speech.isListening ? cancelListening : null,
        child: Icon(Icons.cancel),
      ),
      FloatingActionButton(
        heroTag: null,
        backgroundColor: Colors.yellowAccent,
        onPressed: !_hasSpeech || speech.isListening ? null : startListening,
        child: Icon(Icons.mic),
      ),
      FloatingActionButton(
        heroTag: null,
        mini: true,
        backgroundColor: Colors.redAccent,
        onPressed: speech.isListening ? stopListening : null,
        child: Icon(Icons.stop),
      ),
    ];

    return Consumer<DetailsProvider>(builder:
        (BuildContext context, DetailsProvider detailsProvider, Widget child) {
      return Scaffold(
          floatingActionButton: CircleFloatingButton.floatingActionButton(
              items: itemsActionBar,
              color: Colors.indigo,
              icon: Icons.mic,
              //  child: Icon(Icons.mic,color: Colors.white,),
              duration: Duration(milliseconds: 1000),
              curveAnim: Curves.elasticOut),
          body: CustomScrollView(
            scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 18.0, left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Textrich(
                          //   context: context,
                          //   fontsize1: 30,
                          //   fontsize2: 25,
                          //   txt1: "${S.of(context).home_GREETINGS}\n",
                          //   txt2: name != null ? name : S.of(context).home_USER,
                          // ),
                          FutureBuilder<ProfileModel>(
                            future: getUserProfile(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Textrich(
                                  context: context,
                                  fontsize1: 26,
                                  fontsize2: 26,
                                  txt1: "${S.of(context).home_GREETINGS}\n",
                                  txt2: snapshot.data.ebookApp[0].name == null
                                      ? " "
                                      : "${snapshot.data.ebookApp[0].name}",
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
                          GestureDetector(
                            onTap: type == "GOOGLE" || user_id == null
                                ? () {}
                                : () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return Profile(
                                        name: name,
                                        email: email,
                                        phonenumber: phone,
                                        image: image,
                                      );
                                    })).then((value) {
                                      return setState(() {});
                                    });
                                  },
                            child: Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                color: buttonColorAccent.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(90),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black,
                                  )
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(35),
                                  child: CircleAvatar(
                                    radius: 35,
                                    backgroundColor: Colors.red,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(90),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black,
                                          )
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
                                                                    .ebookApp[0]
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
                                                                    .ebookApp[0]
                                                                    .userImage
                                                                : 'https://images.unsplash.com/photo-1611674600319-a74611913036?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=2134&q=80',
                                                        fit: BoxFit.cover,
                                                      ),
                                              ),
                                            );
                                          } else if (snapshot.hasData == null) {
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
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),

                    ///textfield
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                      ),
                      child: TextField(
                        onTap: () {
                          setState(() {
                            search = true;
                          });
                        },
                        onSubmitted: (value) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Search(
                              searched: tx.text,
                            );
                          })).then((value) {
                            tx.text = '';
                            tx.clear();
                          });
                        },
                        onChanged: (result) {},
                        controller: tx,
                        autofocus: false,
                        decoration: new InputDecoration(
                          hintText: S.of(context).home_search_bar,
                          hintStyle: TextStyle(
                              color: themeProvider.isLightTheme
                                  ? Colors.black
                                  : Colors.white,
                              fontWeight: FontWeight.w300),
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(
                                color: buttonColorAccent, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(
                                color: buttonColorAccent, width: 2),
                          ),
                          prefixIcon: IconButton(
                            icon: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: SvgPicture.asset(
                                'assets/images/searchicon.svg', height: 25,
                                // height: 20,
                                // fit: BoxFit.fitHeight,
                                color: themeProvider.isLightTheme
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                search = true;
                              });
                            },
                          ),
                          //fillColor: Colors.green
                        ),
                        keyboardType: TextInputType.emailAddress,
                        style: new TextStyle(
                          fontFamily: "Poppins",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Textrich(
                        context: context,
                        fontsize1: 25,
                        fontsize2: 25,
                        txt1: S.of(context).home_SELECT,
                        txt2: S.of(context).home_CATEGORY,
                      ),
                    ),
                    Container(
                      height: 150,
                      //themeProvider.isLightTheme?Colors.white: Color(0xFf34323d),
                      child: Progress(
                        spin: spin,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: cat.length,
                            itemBuilder: (context, index) {
                              var cid = cat[index]["cid"];
                              var name = cat[index]["category_name"];
                              var books = cat[index]["total_books"];
                              var id = int.parse(cid);
                              return name != null
                                  ? GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              transitionDuration:
                                                  Duration(microseconds: 800),
                                              transitionsBuilder: (context,
                                                  animation,
                                                  animationTime,
                                                  child) {
                                                animation = CurvedAnimation(
                                                    curve: Curves.elasticOut,
                                                    parent: animation);
                                                return ScaleTransition(
                                                    scale: animation,
                                                    alignment: Alignment.center,
                                                    child: child);
                                              },
                                              pageBuilder: (context, animation,
                                                  animationTime) {
                                                return Newcate(
                                                  catid: id,
                                                  title: name,
                                                  id: "cat_id",
                                                );
                                              },
                                            ));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 1.0, vertical: 10),
                                        child: Card(
                                          color: themeProvider.isLightTheme
                                              ? Colors.black
                                              : Colors.white,
                                          elevation: 30,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Container(
                                              height: 200,
                                              width: 180,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        images[index]),
                                                    fit: BoxFit.cover),

                                                color: Colors.black54,
                                                // gradient: LinearGradient(
                                                //     begin: Alignment.topRight,
                                                //     end: Alignment.bottomLeft,
                                                //     colors: [
                                                //       Colors.redAccent,
                                                //       Colors.blueAccent
                                                //     ])
                                              ),
                                              child: Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Text(
                                                      '$name',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    Text(
                                                      '$books',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 13,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ),
                                      ),
                                    )
                                  : Center(
                                      child: Text(S
                                          .of(context)
                                          .home_category_internet_error));
                            }),
                      ),
                    ),

                    Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: Ad(),
                    ),

                    Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Textrich(
                                context: context,
                                fontsize1: 25,
                                fontsize2: 25,
                                txt1: S.of(context).home_WHAT_ARE_YOU_READING,
                                txt2: S.of(context).home_TODAY,
                              )),
                          SizedBox(height: 30),
                          Container(
                            height: 250,
                            width: MediaQuery.of(context).size.width,
                            child: Progress(
                              spin: spin,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: today.length,
                                itemBuilder: (context, index) {
                                  var booklink = today[index]["book_file_url"];
                                  var bookfamous = today[index]["book_title"];
                                  var auther = today[index]["author_name"];
                                  var image = today[index]["book_cover_img"];
                                  var rating = today[index]["total_rate"];
                                  var bookid = today[index]["id"];
                                  var dis = today[index]["book_description"];
                                  var authdes =
                                      today[index]["author_description"];
                                  var authid = today[index]["author_id"];
                                  var i = int.parse(bookid);
                                  return ReadingListCard(
                                    image: image != null
                                        ? image
                                        : 'assets/images/book-1.png',
                                    title: bookfamous,
                                    auth: auther,
                                    bookid: i,
                                    authid: int.parse(authid),
                                    author_description: authdes,
                                    radius: 35,
                                    rating: rating,
                                    pressDetails: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return DetailsScreen(
                                              dis: dis,
                                              image: image,
                                              title: auther,
                                              txt: bookfamous
                                                  .replaceAll(' ', '_')
                                                  .replaceAll(r"\'", "'"),
                                              id: i,
                                              rating: rating,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    pressRead: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PdfViewerPage(
                                            bookid: i,
                                            image: image,
                                            txt: bookfamous,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                  //     _buildDownloadReadButton(detailsProvider,
                                  //         context, booklink, i.toString()),
                                  //   ],
                                  // );
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Textrich(
                                  context: context,
                                  fontsize1: 25,
                                  fontsize2: 25,
                                  txt1: S.of(context).home_BEST_OF_THE,
                                  txt2: S.of(context).home_DAY,
                                ),
                                Container(
                                  height: 300,
                                  child: Progress(
                                    spin: spin,
                                    child: PageView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: bestofday.length,
                                        itemBuilder: (context, index) {
                                          var image = bestofday[index]
                                              ["book_cover_img"];
                                          var txt = bestofday[index]
                                              ["book_description"];
                                          var rate =
                                              bestofday[index]["rate_avg"];
                                          var txt1 =
                                              bestofday[index]["book_title"];
                                          var txt2 =
                                              bestofday[index]["author_name"];
                                          var link =
                                              bestofday[index]["book_file_url"];
                                          var booktype =
                                              bestofday[index]["category_name"];
                                          var catid = bestofday[index]["id"];
                                          var id = int.parse(catid);
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: BestOftheDay(
                                                size: widget.size,
                                                context: context,
                                                image: image,
                                                title: txt2,
                                                txt: txt,
                                                link: link,
                                                rate: rate,
                                                txt1: txt1,
                                                txt2: txt2,
                                                booktype: booktype,
                                                catid: id),
                                          );
                                        }),
                                  ),
                                ),

                                /// shared preference
                                booklist == null
                                    ? Shimmer.fromColors(
                                        baseColor: Colors.white70,
                                        highlightColor: Colors.blueAccent,
                                        period: Duration(seconds: 2),
                                        child: Icon(
                                          Icons.all_inclusive_outlined,
                                          size: 50,
                                          color: Colors.black,
                                        ))
                                    : Container(
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount: booklist.length,
                                            itemBuilder:
                                                (BuildContext context, index) {
                                              return AllBooks(
                                                auther: booklist[index]
                                                    ["author_name"],
                                                id: booklist[index]["id"],
                                                section_title: booklist[index]
                                                    ["section_title"],
                                              );
                                            }),
                                      ),

                                user_id != null
                                    ? FutureBuilder<ContinueReading>(
                                        future: getcontinusReading(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Textrich(
                                                    context: context,
                                                    fontsize1: 25,
                                                    fontsize2: 25,
                                                    txt1: S
                                                        .of(context)
                                                        .home_CONTINUE,
                                                    txt2: S
                                                        .of(context)
                                                        .home_READING,
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                                ContinueRead(
                                                  link: snapshot.data
                                                      .ebookApp[0].bookFileUrl,
                                                  txt: snapshot.data.ebookApp[0]
                                                      .bookTitle
                                                      .replaceAll(' ', '_')
                                                      .replaceAll(r"\'", "'"),
                                                  // txt: themeProvider.conName,
                                                  id: int.parse(snapshot
                                                      .data.ebookApp[0].id),
                                                  // id: themeProvider.conId,
                                                  image: snapshot.data
                                                      .ebookApp[0].bookCoverImg,
                                                  // image: themeProvider.conImage,
                                                ),
                                              ],
                                            );
                                          } else if (snapshot.hasData == null) {
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          } else {
                                            return Center(child: Container());
                                          }
                                          // }
                                        })
                                    : Container(
                                        height: 0,
                                        width: 0,
                                      ),
                                SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ));
    });
  }

  //}

  // ignore: non_constant_identifier_names
  AdmobBanner Ad() {
    return AdmobBanner(
      adUnitId: getBannerAdUnitId(),
      adSize: bannerSize,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        // Ads.handleEvent(event, args, 'Banner', scaffoldState, showSnackBar);
      },
      onBannerCreated: (AdmobBannerController controller) {},
    );
  }

  void startListening() {
    lastWords = '';
    lastError = '';
    speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 5),
        pauseFor: Duration(seconds: 5),
        partialResults: false,
        localeId: _currentLocaleId,
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        listenMode: ListenMode.confirmation);
    setState(() {});
  }

  void stopListening() {
    speech.stop();
    setState(() {
      level = 0.0;
    });
  }

  void cancelListening() {
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    ++resultListened;
    setState(() {
      lastWords = '${result.recognizedWords}';
      tx.text = lastWords;
    });
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    // ("sound level $level: $minSoundLevel - $maxSoundLevel ");
    setState(() {
      this.level = level;
    });
  }

  void statusListener(String status) {
    setState(() {
      lastStatus = '$status';
    });
  }
}

class AllBooks extends StatefulWidget {
  // ignore: non_constant_identifier_names
  AllBooks({this.id, this.section_title, this.ind, this.auther});

  String id;

  // ignore: non_constant_identifier_names
  String section_title;
  String auther;
  int ind;

  @override
  _AllBooksState createState() => _AllBooksState();
}

class _AllBooksState extends State<AllBooks> {
  void initState() {
    hello(id: widget.id);
  }

  List Bookslist;
  bool spin = false;

  Future<dynamic> hello({String id}) async {
    if (!mounted) return;
    setState(() {
      spin = true;
    });
    var response1 = await http.get(Uri.parse(
        '$mainapilink/api.php?method_name=home_section_id&homesection_id=$id&page=1'));
    if (response1.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response1.body);
      Bookslist = jsonResponse["EBOOK_APP"];
    } else {}
    if (!mounted) return;
    setState(() {
      spin = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(bottom: 10, top: 20, left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(
                  '${widget.section_title}',
                  style: TextStyle(
                      color: themeProvider.isLightTheme
                          ? Colors.black
                          : Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Nunito'),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.to(Gridvieww(id: widget.id, title: widget.section_title));
                },
                child: Text(
                  "See All",
                  style: TextStyle(
                    color: themeProvider.isLightTheme
                        ? Colors.black
                        : Colors.white,
                    fontSize: 15,
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          height: 260,
          width: MediaQuery.of(context).size.width,
          child:
              // Progress(
              //   spin: spin,
              //   child:
              Bookslist == null
                  ? Shimmer.fromColors(
                      baseColor: Colors.white70,
                      highlightColor: Colors.blueAccent,
                      period: Duration(seconds: 2),
                      child: Icon(
                        Icons.all_inclusive_outlined,
                        size: 50,
                        color: Colors.black,
                      ))
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: Bookslist.length,
                      itemBuilder: (context, index) {
                        var bookfamous = Bookslist[index]["book_title"];
                        var auther = Bookslist[index]["author_name"];
                        var image = Bookslist[index]["book_cover_img"];
                        var rating = Bookslist[index]["total_rate"];
                        var bookid = Bookslist[index]["id"];
                        var authid = Bookslist[index]["author_id"];
                        var authdes = Bookslist[index]["author_description"];
                        var dis = Bookslist[index]["book_description"];
                        var i = int.parse(bookid);
                        return ReadingListCard(
                          image: image != null
                              ? image
                              : 'assets/images/book-1.png',
                          title: bookfamous,
                          radius: 35,
                          auth: auther,
                          authid: int.parse(authid),
                          author_description: authdes,
                          bookid: i,
                          rating: rating,
                          pressDetails: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return DetailsScreen(
                                    dis: dis,
                                    image: image,
                                    title: auther,
                                    txt: bookfamous
                                        .replaceAll(' ', '_')
                                        .replaceAll(r"\'", "'"),
                                    id: i,
                                    rating: rating,
                                  );
                                },
                              ),
                            );
                          },
                          pressRead: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PdfViewerPage(
                                  bookid: i,
                                  image: image,
                                  txt: bookfamous,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
        ),
        // ),
      ],
    );
  }
}

class ContinueRead extends StatelessWidget {
  const ContinueRead({this.txt, this.id, this.image, this.link});

  final String txt;
  final String image;
  final int id;
  final String link;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {

        if (link.toString().contains('epub')) {
          Directory appDocDir = Platform.isAndroid
              ? await getExternalStorageDirectory()
              : await getApplicationDocumentsDirectory();
          String path = Platform.isIOS
              ? appDocDir.path + '/$id.epub'
              : appDocDir.path + '/Ebook/$id.epub';
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return EpuB(id: id, path: path);
          }));
        } else {
          id != null
              ? Navigator.push(context, MaterialPageRoute(builder: (contesxt) {
                  return PdfViewerPage(
                    txt: txt,
                    image: image,
                    bookid: id,
                  );
                }))
              : Fluttertoast.showToast(
                  msg: S.of(context).home_continue_NO_BOOK_toast,
                  backgroundColor: Colors.black,
                  fontSize: 20,
                  gravity: ToastGravity.BOTTOM,
                  textColor: Colors.white,
                  toastLength: Toast.LENGTH_LONG);
        }
      },
      child: Card(
        elevation: 40,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(38.5)),
        child: Container(
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xff616066),
            borderRadius: BorderRadius.circular(38.5),
            boxShadow: [
              BoxShadow(
                offset: Offset(2, 2),
                blurRadius: 5,
                color: Colors.black54.withOpacity(.3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(38.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.55,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                  txt != null
                                      ? "$txt"
                                      : S
                                          .of(context)
                                          .home_continue_CRUSHING_INFLUENCE,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 5),
                            ],
                          ),
                        ),
                        image != null
                            ? Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Image.network(
                                  '$image',
                                  height: 100,
                                  width: 50,
                                ),
                              )
                            : Image.asset(
                                "assets/images/book-1.png",
                                width: 55,
                              )
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Progress extends StatelessWidget {
  const Progress({
    this.child,
    @required this.spin,
  });

  final bool spin;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        color: Theme.of(context).backgroundColor,
        progressIndicator: Shimmer.fromColors(
            baseColor: Colors.white70,
            highlightColor: Colors.blueAccent,
            period: Duration(seconds: 2),
            child: Icon(
              Icons.all_inclusive_outlined,
              size: 50,
              color: Colors.black,
            )),
        inAsyncCall: spin,
        child: child);
  }
}
