import 'dart:convert' as convert;
import 'dart:io';

// import 'package:admob_flutter/admob_flutter.dart';
import 'package:elearn/consttants.dart';
import 'package:elearn/databasefavourite/downloadDb.dart';
import 'package:elearn/generated/l10n.dart';
import 'package:elearn/model/allcomments.dart';
import 'package:elearn/model/detailsProvider.dart';
// import 'package:elearn/model/allComments.dart';
import 'package:elearn/screens/databasefavourite/db.dart';
import 'package:elearn/screens/explore.dart' as exp;
import 'package:elearn/screens/explore.dart';
import 'package:elearn/screens/setting/BookRating2.dart';
import 'package:elearn/screens/view.dart';
import 'package:elearn/widgets/button.dart';
import 'package:elearn/widgets/models_providers%20.dart';
import 'package:elearn/widgets/reading_card_list.dart';
import 'package:elearn/widgets/richtxt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailsScreen2 extends StatefulWidget {
  DetailsScreen2(
      {this.image,
      this.title,
      this.txt,
      this.rating,
      this.id,
      this.dis,
      this.AuthorName});

  final String image;
  final String txt;
  final String dis;
  final String rating;
  final int id;
  final String title;
  final String AuthorName;

  @override
  _DetailsScreen2State createState() => _DetailsScreen2State();
}

class _DetailsScreen2State extends State<DetailsScreen2> {
  // EventController eventController = Get.put(EventController());

  List cat = [];
  List le = [];
  List ids = [];
  var d;
  var c;
  var id;
  var link;
  String bookRating;
  int user_id;
  String buy_book_url;
  bool commentBox = false;
  bool deleteCommit = false;
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

  // AdmobBannerSize bannerSize;
  // AdmobBanner bannerAd;
  final _form = GlobalKey<FormState>();
  TextEditingController commentController = TextEditingController();
  SharedPreferences pref;

  _init() async {
    pref = await SharedPreferences.getInstance();
    user_id = pref.getInt('uid');
  }

  @override
  void initState() {
    _init();
    // TODO: implement initState
    loadPDF();
    super.initState();
  }

  void showSnackBar(String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  bool spin = false;

  loadPDF() async {
    if (!mounted) return;
    setState(() {
      spin = true;
    });
    var response =
        await http.get(Uri.parse("$mainapilink/api.php?book_id=${widget.id}"));
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      var second = jsonResponse["EBOOK_APP"];
      cat = second;
      d = cat[0]["book_description"];
      c = cat[0]["user_comments"];
      id = cat[0]["id"];
      link = cat[0]["book_file_url"];
      bookRating = cat[0]["rate_avg"];
      buy_book_url = cat[0]["book_buy_url"];

      var i = cat[0]["related_books"];

      le = i;
      if (!mounted) return;
      setState(() {
        spin = false;
      });
    } else {}
  }

  submitRating(int rating) async {
    Navigator.pop(context);
    setState(() {
      spin = true;
    });
    var response = await http.get(Uri.parse(
        "$mainapilink/api_rating.php?book_id=${widget.id}&user_id=$user_id&rate=$rating"));
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      var second = jsonResponse["EBOOK_APP"];
      String msg = second[0]['MSG'];
      if (msg == "You have succesfully rated") {
        Fluttertoast.showToast(
            msg: S.of(context).detail_screen_YOU_HAVE_SUCCESSFULLY_RATED,
            backgroundColor: Colors.black,
            fontSize: 20,
            gravity: ToastGravity.BOTTOM,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_LONG);
        setState(() {
          loadPDF();
        });
      } else if (msg == "You have already rated") {
        Fluttertoast.showToast(
            msg: S.of(context).detail_screen_YOU_HAVE_ALREADY_RATED,
            backgroundColor: Colors.black,
            fontSize: 20,
            gravity: ToastGravity.BOTTOM,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_LONG);
      }
    } else {
      ('Request failed with status: ${response.statusCode}.');
    }
    setState(() {
      spin = false;
    });
  }

  sendComment() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    // user_id = pref.getInt('uid');
    var response = await http.get(Uri.parse(
        "$mainapilink/api_comment.php?user_id=$user_id&book_id=$id&comment_text=${commentController.text}"));
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      if (jsonResponse.toString().contains('successflly')) {
        ('===================  Comment post successflly...! ===================');
        setState(() {
          loadPDF();
        });
        commentController.clear();
      }
    } else {
      ('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<AllComments> GetAllComments(id) async {
    try {
      var response = await http.get(Uri.parse(
        "$mainapilink/api.php?get_all_comments&books_id=$id",
        // 'http://vocsyinfotech.website/envanto/client/leprovocatour/api.php?get_all_comments&events_id=$enventId'
      ));
      if (response.statusCode == 200) {
        return allCommentsFromJson(response.body);
      } else {}
    } catch (e) {
      ("exception $e");
    }
  }

  Future deleteComment(id) async {
    try {
      var response = await http
          .get(Uri.parse("$mainapilink/api.php?removecomment&comment_id=$id"));
      var responseData = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        return responseData;
      } else {}
    } catch (e) {
      ('error $e');
    }
  }

  bool isdownload = false;
  @override
  Widget build(BuildContext context) {
    bool visi = false;

    final themeProvider = Provider.of<ThemeProvider>(context);
    var size = MediaQuery.of(context).size;
    Widget discription = Html(
      data: """$d""",
    );
    return Consumer<DetailsProvider>(builder:
        (BuildContext context, DetailsProvider detailsProvider, Widget child) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.black,
              leadingWidth: 40,
              title: Text(
                "${widget.title}",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              leading: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Image.asset(
                    'assets/images/1.png',
                    height: 6,
                    width: 6,
                  ),
                ),
              )),
          body: exp.Progress(
            spin: spin,
            child: SingleChildScrollView(
              child: Material(
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.only(
                          //  top: size.height * .12,
                          left: size.width * .05,
                          right: size.width * .05),
                      // height: size.height * .55,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: Text(widget.txt,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20,
                                            fontFamily: 'Nunito')),
                                  ),
                                  SizedBox(
                                    height: 35,
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: user_id == null
                                            ? () {
                                                Fluttertoast.showToast(
                                                    msg: S
                                                        .of(context)
                                                        .detail_screen_LOGIN_FIRST,
                                                    backgroundColor:
                                                        Colors.black,
                                                    fontSize: 20,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    textColor: Colors.white,
                                                    toastLength:
                                                        Toast.LENGTH_LONG);
                                              }
                                            : () async {
                                                var response = await http.get(
                                                    Uri.parse(
                                                        "$mainapilink/api.php?rating_check=1&book_id=${widget.id}&user_id=$user_id"));
                                                if (response.statusCode ==
                                                    200) {
                                                  var jsonResponse =
                                                      convert.jsonDecode(
                                                          response.body);
                                                  var second =
                                                      jsonResponse["EBOOK_APP"];
                                                  String msg =
                                                      second[0]['sucess'];
                                                  if (msg == "0") {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          double rat = 0;
                                                          return AlertDialog(
                                                            title: Text(S
                                                                .of(context)
                                                                .detail_screen_RATE_A_BOOK),
                                                            content: Container(
                                                              child: RatingBar
                                                                  .builder(
                                                                initialRating:
                                                                    3,
                                                                minRating: 1,
                                                                direction: Axis
                                                                    .horizontal,
                                                                allowHalfRating:
                                                                    false,
                                                                itemCount: 5,
                                                                itemPadding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            4.0),
                                                                itemBuilder:
                                                                    (context,
                                                                            _) =>
                                                                        Icon(
                                                                  Icons.star,
                                                                  color: Colors
                                                                      .amber,
                                                                ),
                                                                onRatingUpdate:
                                                                    (rating) {
                                                                  (rating);
                                                                  rat = rating;
                                                                  (rat);
                                                                },
                                                              ),
                                                            ),
                                                            actions: [
                                                              Button(
                                                                buttonname: S
                                                                    .of(context)
                                                                    .detail_screen_SUBMIT,
                                                                press: () {
                                                                  int rating =
                                                                      rat.toInt();
                                                                  (rating);
                                                                  submitRating(
                                                                      rating);
                                                                  setState(
                                                                      () {});
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        });
                                                  } else if (msg == "1") {
                                                    Fluttertoast.showToast(
                                                        msg: S
                                                            .of(context)
                                                            .detail_screen_YOU_HAVE_ALREADY_RATED,
                                                        backgroundColor:
                                                            Colors.black,
                                                        fontSize: 20,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        textColor: Colors.white,
                                                        toastLength:
                                                            Toast.LENGTH_LONG);
                                                  }
                                                } else {}
                                              },
                                        child: BookRating2(score: bookRating),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.favorite_border,
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          ///add into database.tr
                                          DatabaseHelper.instance.insertTodo(
                                              Todo(
                                                  id: widget.id,
                                                  rating: bookRating,
                                                  pdf: "pdf",
                                                  coverimage: widget.image,
                                                  link: link,
                                                  authername: '',
                                                  bookid: widget.id,
                                                  title: widget.txt));

                                          Fluttertoast.showToast(
                                              msg: S
                                                  .of(context)
                                                  .detail_screen_ADD_FAVOURITE,
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.black87,
                                              textColor: Colors.white54,
                                              fontSize: 16.0);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  top: 15,
                                ),
                                color: Colors.transparent,
                                child: widget.image != null
                                    ? PhysicalModel(
                                        color: Colors.transparent,
                                        shadowColor: Colors.black,
                                        elevation: 40,
                                        borderRadius: BorderRadius.circular(10),
                                        clipBehavior: Clip.antiAlias,
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Imageview(
                                              image: widget.image,
                                              width: 140,
                                              height: 210,
                                              radius: 10,
                                            )),
                                      )
                                    : Image.asset(
                                        "assets/images/book-1.png",
                                        height: double.infinity,
                                        alignment: Alignment.topRight,
                                        fit: BoxFit.fitWidth,
                                      ),
                              ),
                            ],
                          ),
                          FutureBuilder<List<DownloadModel>>(
                              future: DownloadDatabaseHelper.instance
                                  .retrieveTodos(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if (ids.isNotEmpty) {
                                    ids.clear();
                                    for (var i = 0;
                                        i < snapshot.data.length;
                                        i++) {
                                      ids.add(snapshot.data[i].id);
                                      ('ID ======= ${snapshot.data[i].id}');
                                    }
                                  } else {
                                    for (var i = 0;
                                        i < snapshot.data.length;
                                        i++) {
                                      ids.add(snapshot.data[i].id);
                                      ('ID ======= ${snapshot.data[i].id}');
                                    }
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        top: 30, bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.07,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          margin: EdgeInsets.only(
                                              top: 0, bottom: 0),
                                          padding: EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color: buttonColorAccent,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: FlatButton(
                                            onPressed: () async {
                                              ('LINK ==== $link');
                                              ('LINK ==== ${widget.txt}');
                                              Directory appDocDir = Platform
                                                      .isAndroid
                                                  ? await getExternalStorageDirectory()
                                                  : await getApplicationDocumentsDirectory();
                                              String path = Platform.isIOS
                                                  ? appDocDir.path +
                                                      '/${widget.id}.epub'
                                                  : appDocDir.path
                                                          .split('Android')[0] +
                                                      'Ebook/${widget.id}.epub';
                                              if (link
                                                  .toString()
                                                  .contains('epub')) {
                                                if (ids
                                                    .toString()
                                                    .contains(id.toString())) {
                                                  ('PATH TITLE === ${widget.id}');
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return EpuB(
                                                        id: widget.id,
                                                        path: path);
                                                  }));
                                                } else {
                                                  setState(() {
                                                    isdownload = true;
                                                  });
                                                  detailsProvider
                                                      .downloadFile(
                                                          context,
                                                          link,
                                                          widget.id.toString(),
                                                          widget.id,
                                                          widget.image)
                                                      .then((value) {
                                                    DownloadDatabaseHelper
                                                        .instance
                                                        .insertTodo(
                                                            DownloadModel(
                                                                id: widget.id,
                                                                link: path,
                                                                image: widget
                                                                    .image));
                                                    setState(() {});
                                                  });
                                                }
                                              } else {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return PdfViewerPage(
                                                    bookid: widget.id,
                                                    txt: widget.txt,
                                                    image: widget.image,
                                                  );
                                                }));
                                              }
                                            },
                                            child: Text(
                                              isdownload == false
                                                  ? S
                                                      .of(context)
                                                      .detail_screen_READ
                                                  : 'Download',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                  );
                                } else if (snapshot.hasData == null) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  return Container();
                                }
                              }),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          discription != null
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Textrich(
                                    context: context,
                                    txt1: "Sinopsis",
                                    fontsize1: 30,
                                    txt2: " ",
                                    fontsize2: 15,
                                  ),
                                )
                              : Container(),
                          d != null ? discription : Container(),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: RichText(
                              text: TextSpan(
                                style: Theme.of(context).textTheme.headline5,
                                children: [
                                  TextSpan(
                                    text: S
                                        .of(context)
                                        .detail_screen_YOU_MIGHT_ALSO,
                                  ),
                                  TextSpan(
                                    text: S.of(context).detail_screen_LIKE,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 300,
                            child: exp.Progress(
                              spin: spin,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: le.length,
                                  itemBuilder: (context, index) {
                                    var txt = le[index]["book_title"]
                                        .replaceAll(' ', '_')
                                        .replaceAll(r"\'", "'");
                                    var auth = le[index]["author_name"];
                                    var image = le[index]["book_cover_img"];
                                    var authname = le[index]["author_name"];
                                    var link1 = le[index]["book_file_url"];
                                    var des = le[index]["book_description"];
                                    var id = le[index]["id"];
                                    var listBookRating = le[index]["rate_avg"];
                                    int i = int.parse(id);
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6.0, vertical: 0),
                                      child: Stack(
                                        children: <Widget>[
                                          Container(
                                            height: 300,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.4,
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  left: 10,
                                                  top: 24,
                                                  right: 150),
                                              height: 180,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Color(0xFF616066),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Expanded(
                                                    child: RichText(
                                                      text: TextSpan(
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'Helvetica Neue',
                                                            fontSize: 14),
                                                        children: [
                                                          TextSpan(
                                                            text: '$txt\n',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Helvetica Neue',
                                                                fontSize: 18),
                                                          ),
                                                          TextSpan(text: '\n'),
                                                          TextSpan(
                                                            text: auth,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 30,
                                            right: 10,
                                            child: image != null
                                                ? GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                        return DetailsScreen2(
                                                          txt: txt,
                                                          title: authname,
                                                          AuthorName: authname,
                                                          id: i,
                                                          image: image,
                                                          dis: des,
                                                          rating:
                                                              listBookRating,
                                                        );
                                                      }));
                                                    },
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Imageview(
                                                          image: image,
                                                          radius: 5,
                                                          height: 150,
                                                          width: 100,
                                                        )),
                                                  )
                                                : Image.asset(
                                                    "assets/images/book-3.png",
                                                    width: 150,
                                                    fit: BoxFit.fitWidth,
                                                  ),
                                          ),
                                          Positioned(
                                            height: 68,
                                            width: 300,
                                            bottom: -2,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 4.5,
                                                          left: 20),
                                                  child: Container(
                                                    height: 100,
                                                    child: BookRating2(
                                                      score: listBookRating,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                GestureDetector(
                                                  onTap: () async {
                                                    ('LINK ==== $link');
                                                    ('LINK ==== ${txt}');
                                                    if (link1
                                                        .toString()
                                                        .contains('epub')) {
                                                      Directory appDocDir = Platform
                                                              .isAndroid
                                                          ? await getExternalStorageDirectory()
                                                          : await getApplicationDocumentsDirectory();
                                                      String path = Platform
                                                              .isIOS
                                                          ? appDocDir.path +
                                                              '/${widget.id}.epub'
                                                          : appDocDir.path.split(
                                                                  'Android')[0] +
                                                              'Ebook/${widget.id}.epub';
                                                      ('PATH TITLE === ${txt}');
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                        return EpuB(
                                                            id: i, path: path);
                                                      }));
                                                    } else {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                        return PdfViewerPage(
                                                          bookid: i,
                                                          txt: txt.toString(),
                                                          image: image,
                                                        );
                                                      }));
                                                    }
                                                  },
                                                  child: Container(
                                                    height: 75,
                                                    width: 130,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: buttonColorAccent,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(20),
                                                        bottomRight:
                                                            Radius.circular(40),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      'Read',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          decoration:
                                                              TextDecoration
                                                                  .none,
                                                          fontFamily: 'Nunito'),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  S.of(context).details_screen_COMMENTS,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 25,
                                      fontFamily: 'Nunito'),
                                ),
                                // FlatButton(
                                //   onPressed: () {
                                //     setState(() {
                                //       commentBox = !commentBox;
                                //     });
                                //   },
                                //   child: Center(
                                //     child: Text('Add Comment'),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          // commentBox ?
                          user_id == null
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, bottom: 5),
                                  child: Form(
                                    key: _form,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          child: TextFormField(
                                            validator: (value) {
                                              if (value.isEmpty)
                                                return S
                                                    .of(context)
                                                    .details_screen_comments_textField_validation;
                                              else
                                                return null;
                                            },
                                            onSaved: (value) {},
                                            controller: commentController,
                                            autofocus: false,
                                            decoration: InputDecoration(
                                              hintText: S
                                                  .of(context)
                                                  .details_screen_comments_textField_hint_text,
                                              hintStyle: TextStyle(
                                                  color:
                                                      themeProvider.isLightTheme
                                                          ? Colors.black54
                                                          : Colors.white54,
                                                  fontWeight: FontWeight.w700),
                                              fillColor: Colors.white,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                                borderSide: BorderSide(
                                                    color: themeProvider
                                                            .isLightTheme
                                                        ? Colors.black54
                                                        : Colors.white54,
                                                    width: 2),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                                borderSide: BorderSide(
                                                    color: themeProvider
                                                            .isLightTheme
                                                        ? Colors.black54
                                                        : Colors.white54,
                                                    width: 2),
                                              ),
                                            ),
                                            keyboardType: TextInputType.text,
                                            style: TextStyle(
                                              fontFamily: "Poppins",
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        FloatingActionButton(
                                          backgroundColor: Colors.transparent,
                                          onPressed: sendComment,
                                          child: Center(
                                            child: SvgPicture.asset(
                                              "assets/images/1234.svg",
                                              fit: BoxFit.cover,
                                              height: 60,
                                              width: 40,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                          // : Container(),
                          SizedBox(
                            height: 20,
                          ),
                          FutureBuilder<AllComments>(
                            future: GetAllComments(widget.id),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                ('WIDGET ID  =-=== ${widget.id}');
                                return Column(
                                  children: [
                                    Visibility(
                                      visible: visi,
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.15,
                                        width:
                                            MediaQuery.of(context).size.height *
                                                0.8,
                                        child: Center(
                                            child: CircularProgressIndicator()),
                                      ),
                                    ),
                                    ListView.builder(
                                        reverse: true,
                                        primary: false,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount:
                                            snapshot.data.ebookApp.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onLongPress: () {
                                              var userId = snapshot
                                                  .data.ebookApp[index].userId;
                                              if (userId.toString() == userId) {
                                                setState(() {
                                                  deleteCommit = true;
                                                });
                                              } else {
                                                setState(() {
                                                  deleteCommit = false;
                                                });
                                              }
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return new AlertDialog(
                                                      content:
                                                          new SingleChildScrollView(
                                                              child:
                                                                  new ListBody(
                                                                      children: [
                                                            new Text(
                                                              "${snapshot.data.ebookApp[index].commentText}",
                                                            ),
                                                          ])),
                                                      actions: [
                                                        Visibility(
                                                          visible: deleteCommit,
                                                          child: FlatButton(
                                                            child: new Text(
                                                                "Delete"),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                              deleteComment(snapshot.data.ebookApp[index].id).then(
                                                                  (value) => value ==
                                                                              '1' ||
                                                                          value ==
                                                                              1
                                                                      ? showSnackBar(
                                                                          "Add succesfully")
                                                                      // Get
                                                                      //         .snackbar(
                                                                      //         "éxito",
                                                                      //         "Has eliminado correctamente el comentario",
                                                                      //         icon: Icon(
                                                                      //             Icons
                                                                      //                 .person,
                                                                      //             color:
                                                                      //                 Colors.white70),
                                                                      //         snackPosition:
                                                                      //             SnackPosition.TOP,
                                                                      //         backgroundColor:
                                                                      //             Colors.brown,
                                                                      //         borderRadius:
                                                                      //             20,
                                                                      //         margin:
                                                                      //             EdgeInsets.all(15),
                                                                      //         colorText:
                                                                      //             Colors.white70,
                                                                      //         duration:
                                                                      //             Duration(seconds: 4),
                                                                      //         isDismissible:
                                                                      //             true,
                                                                      //         dismissDirection:
                                                                      //             SnackDismissDirection.HORIZONTAL,
                                                                      //         forwardAnimationCurve:
                                                                      //             Curves.easeOutBack,
                                                                      //       )
                                                                      : showSnackBar(
                                                                          "Delete Succesfully")

                                                                  // Get
                                                                  //         .snackbar(
                                                                  //         "No se pudo borrar",
                                                                  //         "No ha podido eliminar el comentario",
                                                                  //         icon: Icon(
                                                                  //             Icons
                                                                  //                 .person,
                                                                  //             color:
                                                                  //                 Colors.white70),
                                                                  //         snackPosition:
                                                                  //             SnackPosition.TOP,
                                                                  //         backgroundColor:
                                                                  //             Colors.brown,
                                                                  //         borderRadius:
                                                                  //             20,
                                                                  //         margin:
                                                                  //             EdgeInsets.all(15),
                                                                  //         colorText:
                                                                  //             Colors.white70,
                                                                  //         duration:
                                                                  //             Duration(seconds: 4),
                                                                  //         isDismissible:
                                                                  //             true,
                                                                  //         dismissDirection:
                                                                  //             SnackDismissDirection.HORIZONTAL,
                                                                  //         forwardAnimationCurve:
                                                                  //             Curves.easeOutBack,
                                                                  //       ),
                                                                  );
                                                              setState(() {});
                                                            },
                                                          ),
                                                        ),
                                                        new FlatButton(
                                                          child: new Text("OK"),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              child: Container(
                                                color: Color(0xffA7A7A7),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.1,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.8,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 2),
                                                  child: Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 8,
                                                                horizontal: 2),
                                                        child: CircleAvatar(
                                                          radius: 30,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50),
                                                            child: Container(
                                                              width: 50,
                                                              height: 50,
                                                              child:
                                                                  Image.network(
                                                                snapshot
                                                                    .data
                                                                    .ebookApp[
                                                                        index]
                                                                    .userImage,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 8),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.7,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    snapshot
                                                                        .data
                                                                        .ebookApp[
                                                                            index]
                                                                        .userName,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontFamily:
                                                                            "Nunito",
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                  Text(
                                                                    snapshot
                                                                        .data
                                                                        .ebookApp[
                                                                            index]
                                                                        .dtRate
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontFamily:
                                                                            "Helvetica Neue",
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight.w300),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Flexible(
                                                              child: Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.7,
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.085,
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topLeft,
                                                                  child: Text(
                                                                    "${snapshot.data.ebookApp[index].commentText}",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    maxLines: 2,
                                                                    softWrap:
                                                                        false,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontFamily:
                                                                            "Helvetica Neue",
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  ],
                                );
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ),
                          // c == null
                          //     ? Center(
                          //         child: Shimmer.fromColors(
                          //             baseColor: Colors.white70,
                          //             highlightColor: Colors.blueAccent,
                          //             period: Duration(seconds: 2),
                          //             child: Icon(
                          //               Icons.all_inclusive_outlined,
                          //               size: 50,
                          //               color: Colors.black,
                          //             )),
                          //       )
                          //     : c.length == 0
                          //         ? Container(
                          //             height: 100,
                          //             child: Center(
                          //               child: Text(S
                          //                   .of(context)
                          //                   .details_screen_comments_NO_COMMENTS_FOUND),
                          //             ),
                          //           )
                          //         : Progress(
                          //             spin: spin,
                          //             child: ListView.builder(
                          //               physics: NeverScrollableScrollPhysics(),
                          //               shrinkWrap: true,
                          //               reverse: true,
                          //               scrollDirection: Axis.vertical,
                          //               itemCount: c.length,
                          //               itemBuilder: (context, index) {
                          //                 // var bookId = c[index]["book_id"];
                          //                 var userName = c[index]["user_name"];
                          //                 var commentText =
                          //                     c[index]["comment_text"];
                          //                 var time = c[index]["dt_rate"];
                          //                 // var image = c[index]['']
                          //                 // int id = int.parse(bookId);
                          //                 return GestureDetector(
                          //                   onLongPress: () {
                          //                     showDialog(
                          //                         context: context,
                          //                         builder:
                          //                             (BuildContext context) {
                          //                           return new AlertDialog(
                          //                             content:
                          //                                 new SingleChildScrollView(
                          //                                     child: new ListBody(
                          //                                         children: [
                          //                                   new Text(
                          //                                     "$commentText",
                          //                                   ),
                          //                                 ])),
                          //                             actions: [
                          //                               new FlatButton(
                          //                                 child:
                          //                                     new Text("Confirm"),
                          //                                 onPressed: () {
                          //                                   Navigator.of(context)
                          //                                       .pop();
                          //                                 },
                          //                               ),
                          //                             ],
                          //                           );
                          //                         });
                          //                   },
                          //                   child: Padding(
                          //                     padding: const EdgeInsets.symmetric(
                          //                         vertical: 2),
                          //                     child: Container(
                          //                       color: Color(0xff707070),
                          //                       height: MediaQuery.of(context)
                          //                               .size
                          //                               .height *
                          //                           0.1,
                          //                       width: MediaQuery.of(context)
                          //                               .size
                          //                               .height *
                          //                           0.8,
                          //                       child: Padding(
                          //                         padding:
                          //                             const EdgeInsets.symmetric(
                          //                                 horizontal: 2),
                          //                         child: Row(
                          //                           children: [
                          //                             Padding(
                          //                               padding: const EdgeInsets
                          //                                       .symmetric(
                          //                                   vertical: 8,
                          //                                   horizontal: 2),
                          //                               child: CircleAvatar(
                          //                                 radius: 30,
                          //                                 child: ClipRRect(
                          //                                   borderRadius:
                          //                                       BorderRadius
                          //                                           .circular(50),
                          //                                   child: Image.network(
                          //                                     'https://gumlet.assettype.com/freepressjournal%2F2020-07%2Fa19a7fee-8eef-4215-8bd4-c197fe4a7527%2FEb00vR8UwAADZVS.jpg?rect=0%2C41%2C1080%2C608&w=400&dpr=2.6',
                          //                                     width: 60,
                          //                                     height: 60,
                          //                                     fit: BoxFit.cover,
                          //                                   ),
                          //                                 ),
                          //                               ),
                          //                             ),
                          //                             SizedBox(
                          //                               width: 10,
                          //                             ),
                          //                             Padding(
                          //                               padding: const EdgeInsets
                          //                                       .symmetric(
                          //                                   vertical: 8),
                          //                               child: Column(
                          //                                 crossAxisAlignment:
                          //                                     CrossAxisAlignment
                          //                                         .start,
                          //                                 children: [
                          //                                   Container(
                          //                                     width: MediaQuery.of(
                          //                                                 context)
                          //                                             .size
                          //                                             .width *
                          //                                         0.7,
                          //                                     child: Row(
                          //                                       // mainAxisAlignment:
                          //                                       //     MainAxisAlignment
                          //                                       //         .spaceBetween,
                          //                                       children: [
                          //                                         Text(
                          //                                           '$userName',
                          //                                           style: TextStyle(
                          //                                               color: Colors
                          //                                                   .white,
                          //                                               fontFamily:
                          //                                                   "Nunito",
                          //                                               fontSize:
                          //                                                   18,
                          //                                               fontWeight:
                          //                                                   FontWeight
                          //                                                       .w500),
                          //                                         ),
                          //                                         Text(
                          //                                           "                                                          $time",
                          //                                           style: TextStyle(
                          //                                               color: Colors
                          //                                                   .white,
                          //                                               fontFamily:
                          //                                                   "Helvetica Neue",
                          //                                               fontSize:
                          //                                                   10,
                          //                                               fontWeight:
                          //                                                   FontWeight
                          //                                                       .w300),
                          //                                         )
                          //                                       ],
                          //                                     ),
                          //                                   ),
                          //                                   Flexible(
                          //                                     child: Container(
                          //                                       width: MediaQuery.of(
                          //                                                   context)
                          //                                               .size
                          //                                               .width *
                          //                                           0.7,
                          //                                       height: MediaQuery.of(
                          //                                                   context)
                          //                                               .size
                          //                                               .height *
                          //                                           0.085,
                          //                                       child: Align(
                          //                                         alignment:
                          //                                             Alignment
                          //                                                 .topLeft,
                          //                                         child: Text(
                          //                                           "$commentText",
                          //                                           textAlign:
                          //                                               TextAlign
                          //                                                   .start,
                          //                                           overflow:
                          //                                               TextOverflow
                          //                                                   .ellipsis,
                          //                                           maxLines: 2,
                          //                                           softWrap:
                          //                                               false,
                          //                                           style: TextStyle(
                          //                                               color: Colors
                          //                                                   .white,
                          //                                               fontFamily:
                          //                                                   "Helvetica Neue",
                          //                                               fontSize:
                          //                                                   12,
                          //                                               fontWeight:
                          //                                                   FontWeight
                          //                                                       .w400),
                          //                                         ),
                          //                                       ),
                          //                                     ),
                          //                                   )
                          //                                 ],
                          //                               ),
                          //                             ),
                          //                           ],
                          //                         ),
                          //                       ),
                          //                     ),
                          //                   ),
                          //                 );
                          //                 // return Column(
                          //                 //   children: <Widget>[
                          //                 //     Container(
                          //                 //       decoration: BoxDecoration(
                          //                 //         color: Colors.white
                          //                 //             .withOpacity(0.1),
                          //                 //         borderRadius:
                          //                 //             BorderRadius.circular(0),
                          //                 //       ),
                          //                 //       child: Column(
                          //                 //         crossAxisAlignment:
                          //                 //             CrossAxisAlignment.start,
                          //                 //         children: [
                          //                 //           Padding(
                          //                 //             padding:
                          //                 //                 const EdgeInsets.all(
                          //                 //                     8.0),
                          //                 //             child: Row(
                          //                 //               mainAxisAlignment:
                          //                 //                   MainAxisAlignment
                          //                 //                       .spaceBetween,
                          //                 //               children: [
                          //                 //                 Text(
                          //                 //                   '$userName',
                          //                 //                   maxLines: 1,
                          //                 //                   overflow: TextOverflow
                          //                 //                       .ellipsis,
                          //                 //                   style: TextStyle(
                          //                 //                     fontWeight:
                          //                 //                         FontWeight.w500,
                          //                 //                     fontSize: 20,
                          //                 //                     fontFamily:
                          //                 //                         'Nunito',
                          //                 //                   ),
                          //                 //                 ),
                          //                 //                 SizedBox(
                          //                 //                   width: 10,
                          //                 //                 ),
                          //                 //                 Text(
                          //                 //                   '$time',
                          //                 //                   style: TextStyle(
                          //                 //                     color: Colors.white
                          //                 //                         .withOpacity(
                          //                 //                             0.6),
                          //                 //                     fontWeight:
                          //                 //                         FontWeight.w200,
                          //                 //                     fontSize: 12,
                          //                 //                   ),
                          //                 //                 ),
                          //                 //               ],
                          //                 //             ),
                          //                 //           ),
                          //                 //           Padding(
                          //                 //             padding:
                          //                 //                 const EdgeInsets.only(
                          //                 //               bottom: 12,
                          //                 //               right: 8,
                          //                 //               left: 8,
                          //                 //               top: 5,
                          //                 //             ),
                          //                 //             child: ReadMoreText(
                          //                 //               '$commentText',
                          //                 //               trimLines: 2,
                          //                 //               colorClickableText:
                          //                 //                   Color.fromRGBO(
                          //                 //                       0, 179, 134, 1.0),
                          //                 //               trimMode: TrimMode.Line,
                          //                 //               trimCollapsedText: S
                          //                 //                   .of(context)
                          //                 //                   .read_more_text_SHOW_MORE,
                          //                 //               trimExpandedText: S
                          //                 //                   .of(context)
                          //                 //                   .read_more_text_SHOW_LESS,
                          //                 //               style: TextStyle(
                          //                 //                 fontWeight:
                          //                 //                     FontWeight.w300,
                          //                 //                 color: Colors.white
                          //                 //                     .withOpacity(0.7),
                          //                 //                 fontSize: 15,
                          //                 //               ),
                          //                 //               moreStyle: TextStyle(
                          //                 //                 fontSize: 16,
                          //                 //                 color: Color.fromRGBO(
                          //                 //                     0, 179, 134, 1.0),
                          //                 //               ),
                          //                 //             ),
                          //                 //           ),
                          //                 //         ],
                          //                 //       ),
                          //                 //     ),
                          //                 //     Divider(
                          //                 //       color: Color(0xff26242e),
                          //                 //       height: 2,
                          //                 //       thickness: 2,
                          //                 //     ),
                          //                 //   ],
                          //                 // );
                          //               },
                          //             ),
                          //           ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

// class BookInfo extends StatefulWidget {
//   const BookInfo({
//     Key key,
//     this.txt,
//     this.id,
//     this.image,
//     this.rating,
//     this.size,
//     this.buyBookUrl,
//     this.userId,
//   }) : super(key: key);
//   final String txt;
//   final String image;
//   final Size size;
//   final String rating;
//   final int id;
//   final String buyBookUrl;
//   final int userId;
//
//   @override
//   _BookInfoState createState() => _BookInfoState();
// }
//
// class _BookInfoState extends State<BookInfo> {
//   bool spin = false;
//
//   submitRating(int rating) async {
//     setState(() {
//       spin = true;
//     });
//     var response = await http.get(Uri.parse(
//         "$mainapilink/api_rating.php?book_id=${widget.id}&user_id=${widget.userId}&rate=$rating"));
//     if (response.statusCode == 200) {
//       var jsonResponse = convert.jsonDecode(response.body);
//       var second = jsonResponse["EBOOK_APP"];
//       String msg = second[0]['MSG'];
//       if (msg == "You have succesfully rated") {
//         Fluttertoast.showToast(
//             msg: msg,
//             backgroundColor: Colors.black,
//             fontSize: 20,
//             gravity: ToastGravity.BOTTOM,
//             textColor: Colors.white,
//             toastLength: Toast.LENGTH_LONG);
//         Navigator.pop(context);
//       } else if (msg == "You have already rated") {
//         Fluttertoast.showToast(
//             msg: msg,
//             backgroundColor: Colors.black,
//             fontSize: 20,
//             gravity: ToastGravity.BOTTOM,
//             textColor: Colors.white,
//             toastLength: Toast.LENGTH_LONG);
//         Navigator.pop(context);
//       }
//     } else {
//       ('Request failed with status: ${response.statusCode}.');
//     }
//     setState(() {
//       spin = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: <Widget>[
//             Container(
//               width: MediaQuery.of(context).size.width * 0.4,
//               alignment: Alignment.centerLeft,
//               child: Text(widget.txt,
//                   maxLines: 3,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(
//                       fontWeight: FontWeight.w700,
//                       fontSize: 25,
//                       fontFamily: 'Nunito')),
//             ),
//             Container(
//               color: Colors.transparent,
//               child: widget.image != null
//                   ? PhysicalModel(
//                       color: Colors.transparent,
//                       shadowColor: Colors.black,
//                       elevation: 40,
//                       borderRadius: BorderRadius.circular(10),
//                       clipBehavior: Clip.antiAlias,
//                       child: ClipRRect(
//                           borderRadius: BorderRadius.circular(10),
//                           child: Imageview(
//                             image: widget.image,
//                             width: 140,
//                             height: 210,
//                             radius: 10,
//                           )),
//                     )
//                   : Image.asset(
//                       "assets/images/book-1.png",
//                       height: double.infinity,
//                       alignment: Alignment.topRight,
//                       fit: BoxFit.fitWidth,
//                     ),
//             ),
//           ],
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 50, bottom: 10),
//           child: Row(
//             children: <Widget>[
//               GestureDetector(
//                 onTap: () {
//                   showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         double rat = 0;
//                         return AlertDialog(
//                           title: Text("Rate a Book"),
//                           content: Container(
//                             child: RatingBar.builder(
//                               initialRating: 3,
//                               minRating: 1,
//                               direction: Axis.horizontal,
//                               allowHalfRating: false,
//                               itemCount: 5,
//                               itemPadding:
//                                   EdgeInsets.symmetric(horizontal: 4.0),
//                               itemBuilder: (context, _) => Icon(
//                                 Icons.star,
//                                 color: Colors.amber,
//                               ),
//                               onRatingUpdate: (rating) {
//                                 (rating);
//                                 rat = rating;
//                                 (rat);
//                               },
//                             ),
//                           ),
//                           actions: [
//                             Button(
//                               buttonname: "Submit",
//                               press: () {
//                                 int rating = rat.toInt();
//                                 (rating);
//                                 submitRating(rating);
//                                 setState(() {});
//                               },
//                             ),
//                           ],
//                         );
//                       });
//                 },
//                 child: BookRating(score: widget.rating),
//               ),
//               IconButton(
//                 icon: Icon(
//                   Icons.favorite_border,
//                   size: 20,
//                   color: Colors.grey,
//                 ),
//                 onPressed: () {
//                   ///add into database.tr
//                   DatabaseHelper.instance.insertTodo(Todo(
//                       id: widget.id,
//                       rating: widget.rating,
//                       pdf: "pdf",
//                       coverimage: widget.image,
//                       authername: '',
//                       bookid: widget.id,
//                       title: widget.txt));
//
//                   Fluttertoast.showToast(
//                       msg: S.of(context).detail_screen_ADD_FAVOURITE,
//                       toastLength: Toast.LENGTH_SHORT,
//                       gravity: ToastGravity.BOTTOM,
//                       timeInSecForIosWeb: 1,
//                       backgroundColor: Colors.black87,
//                       textColor: Colors.white54,
//                       fontSize: 16.0);
//                 },
//               ),
//               Container(
//                 margin: EdgeInsets.only(top: 0, bottom: 0),
//                 padding: EdgeInsets.only(
//                   left: 10,
//                   right: 10,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 child: FlatButton(
//                   onPressed: () {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (context) {
//                       return PdfViewerPage(
//                         bookid: widget.id,
//                         txt: widget.txt,
//                       );
//                     }));
//                   },
//                   child: Text(
//                     S.of(context).detail_screen_READ,
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold, color: Colors.black54),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 width: 10,
//               ),
//               widget.buyBookUrl != null && widget.buyBookUrl.isNotEmpty
//                   ? Container(
//                       padding: EdgeInsets.only(
//                         left: 10,
//                         right: 10,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                       child: FlatButton(
//                         onPressed: () async {
//                           (widget.buyBookUrl);
//                           await launch(
//                             widget.buyBookUrl,
//                           );
//                         },
//                         child: Text(
//                           S.of(context).detail_screen_PURCHASE_BOOK,
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black54),
//                         ),
//                       ),
//                     )
//                   : Container(),
//             ],
//           ),
//         ),
//         SizedBox(
//           height: 20,
//         ),
//       ],
//     );
//   }
// }
