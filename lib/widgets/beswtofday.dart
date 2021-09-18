// import 'package:admob_flutter/admob_flutter.dart';
import 'dart:io';

import 'package:elearn/databasefavourite/downloadDb.dart';
import 'package:elearn/generated/l10n.dart';
import 'package:elearn/model/detailsProvider.dart';
import 'package:elearn/screens/details_screen.dart';
import 'package:elearn/screens/explore.dart';
import 'package:elearn/screens/view.dart';
import 'package:elearn/widgets/reading_card_list.dart';
import 'package:elearn/widgets/two_side_rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'book_rating.dart';

class BestOftheDay extends StatefulWidget {
  BestOftheDay(
      {this.size,
      this.context,
      this.image,
      this.txt,
      this.rate,
      this.txt2,
      this.txt1,
      this.title,
      this.link,
      this.booktype,
      this.catid});

  final Size size;
  final BuildContext context;
  final String image;
  final String link;
  final String txt;
  final String txt1;
  final String txt2;
  final String title;
  final String booktype;

  ///catid
  final int catid;
  final String rate;

  @override
  _BestOftheDayState createState() => _BestOftheDayState();
}

class _BestOftheDayState extends State<BestOftheDay> {
  // AdmobInterstitial interstitialAd;
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

  void showSnackBar(String content) {
    if (!mounted) return;
    setState(() {});
    scaffoldState.currentState.showSnackBar(
      SnackBar(
        content: Text(content),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  @override
  void dispose() {
    // interstitialAd.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  List ids = [];

  @override
  Widget build(BuildContext context) {
    var discription = Html(
      data: """${widget.txt}""",
    );
    return Consumer<DetailsProvider>(builder:
        (BuildContext context, DetailsProvider detailsProvider, Widget child) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        height: 300,
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(
                  left: 24,
                  top: 20,
                  right: widget.size.width * .35,
                ),
                height: 230,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Color(0xFF26242e),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: Offset(2, 2),
                          blurRadius: 5,
                          spreadRadius: 3)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Text(
                        widget.booktype != null
                            ? widget.booktype
                            : S.of(context).beswtofday_TIME,
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    Text(
                      widget.txt1 != null
                          ? widget.txt1
                          : S.of(context).beswtofday_HOW_TO_WIN,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.txt2 != null
                          ? widget.txt2
                          : S.of(context).beswtofday_GARY_VENCHUK,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.normal),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10.0),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                              right: 10.0,
                            ),
                            child: BookRating(score: widget.rate),
                          ),
                          Expanded(
                            child: Container(
                              height: 70,
                              width: 200,
                              child: Html(
                                  data: widget.txt != null
                                      ? widget.txt
                                      : S
                                          .of(context)
                                          .beswtofday_WHEN_EARTH_WAS_FLAT,
                                  style: {
                                    "body": Style(
                                      color: Colors.white,
                                      fontSize: FontSize.medium,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 5,
              child: widget.image != null
                  ? GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return DetailsScreen(
                            // dis: dis,
                            image: widget.image,
                            txt: widget.txt1,
                            id: widget.catid,
                            rating: widget.rate,
                            title: widget.title,
                          );
                        })).then((value) {
                          setState(() {});
                        });
                      },
                      child: PhysicalModel(
                          color: Colors.transparent,
                          elevation: 40,
                          shadowColor: Colors.black54,
                          borderRadius: BorderRadius.circular(10),
                          child: Card(
                            borderOnForeground: false,
                            color: Colors.black54,
                            elevation: 50,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide.none),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Imageview(
                                  image: widget.image,
                                  radius: 5,
                                  height: 180,
                                  width: 100,
                                )),
                          )),
                    )
                  : Image.asset(
                      "assets/images/book-3.png",
                      width: widget.size.width * .37,
                    ),
            ),
            FutureBuilder<List<DownloadModel>>(
                future: DownloadDatabaseHelper.instance.retrieveTodos(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (ids.isNotEmpty) {
                      ids.clear();
                      for (var i = 0; i < snapshot.data.length; i++) {
                        ids.add(snapshot.data[i].id);
                      }
                    } else {
                      for (var i = 0; i < snapshot.data.length; i++) {
                        ids.add(snapshot.data[i].id);
                      }
                    }
                    return Positioned(
                      bottom: 0,
                      right: 0,
                      child: SizedBox(
                        height: 50,
                        width: widget.size.width * .3,
                        child: TwoSideRoundedButton(
                          text: S.of(context).detail_screen_READ,
                          radious: 24,
                          press: () async {
                            Directory appDocDir = Platform.isAndroid
                                ? await getExternalStorageDirectory()
                                : await getApplicationDocumentsDirectory();
                            String path = Platform.isIOS
                                ? appDocDir.path + '/${widget.catid}.epub'
                                : appDocDir.path +
                                    '/Ebook/${widget.catid}.epub';
                            if (widget.link.toString().contains('epub')) {
                              if (ids
                                  .toString()
                                  .contains(widget.catid.toString())) {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return EpuB(id: widget.catid, path: path);
                                })).then((value) {
                                  setState(() {});
                                });
                              } else {
                                detailsProvider
                                    .downloadFile(
                                        context,
                                        widget.link,
                                        widget.catid.toString(),
                                        widget.catid,
                                        widget.image)
                                    .then((value) {
                                  DownloadDatabaseHelper.instance.insertTodo(
                                      DownloadModel(
                                          id: widget.catid,
                                          link: path,
                                          image: widget.image));
                                  setState(() {});
                                });
                              }
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PdfViewerPage(
                                    bookid: widget.catid,
                                    image: widget.image,
                                    txt: widget.title,
                                  ),
                                ),
                              );
                            }
                          },
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
                })
          ],
        ),
      );
    });
  }
}
