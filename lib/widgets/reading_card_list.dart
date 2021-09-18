import 'dart:convert';
import 'dart:io';

import 'package:elearn/databasefavourite/downloadDb.dart';
import 'package:elearn/epub_viewer_lib/epub_viewer.dart';
import 'package:elearn/epub_viewer_lib/utils/util.dart';
import 'package:elearn/generated/l10n.dart';
import 'package:elearn/model/ContinueReadingmodel.dart';
import 'package:elearn/model/detailsProvider.dart';
import 'package:elearn/screens/databasefavourite/db.dart';
import 'package:elearn/screens/explore.dart';
import 'package:elearn/screens/view.dart';
import 'package:elearn/widgets/book_rating.dart';
import 'package:elearn/widgets/models_providers%20.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../consttants.dart';
import 'cat.dart';

class ReadingListCard extends StatefulWidget {
  final String image;
  final String title;
  final String auth;
  final int bookid;
  final int authid;
  final String rating;
  final String author_description;
  double radius;
  final Function pressDetails;
  final Function pressRead;

  ReadingListCard({
    Key key,
    this.image,
    this.title,
    this.bookid,
    this.auth,
    this.authid,
    this.author_description,
    this.rating,
    this.pressDetails,
    this.pressRead,
    this.radius,
  }) : super(key: key);

  @override
  _ReadingListCardState createState() => _ReadingListCardState();
}

class _ReadingListCardState extends State<ReadingListCard> {
  @override
  void initState() {
    EpubViewer.setConfig(
        themeColor: Colors.black,
        identifier: "book",
        scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
        allowSharing: true,
        enableTts: true,
        nightMode: true);
    PreferredSize();
    // TODO: implement initState
    super.initState();
    loadPDF(widget.bookid);
    getdir();
  }

  List<dynamic> flist = [];

  PreferredSize() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      flist = pref.getStringList('favlist');
    });
  }

  bool loading = false;
  String path;

  Future<ContinueReading> loadPDF(int id) async {
    try {
      setState(() {
        loading = true;
      });
      final String bASEURL = "$mainapilink/api.php?book_id=$id";
      var response = await http.get(Uri.parse(bASEURL));
      var jsonResponse = jsonDecode(response.body);
      var second = jsonResponse["EBOOK_APP"];

      var i;
      SharedPreferences pref = await SharedPreferences.getInstance();

      pref.setString('continueimage', widget.image);
      setState(() {
        path = second[0]["book_file_url"];
        loading = false;
      });

      return continueReadingFromJson(response.body);
    } catch (e) {
      (e);
      setState(() {
        loading = false;
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Directory appDocDir;

  Future<Directory> getdir() async {
    appDocDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return appDocDir;
  }

  List id = [];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Consumer<DetailsProvider>(builder:
        (BuildContext context, DetailsProvider detailsProvider, Widget child) {
      return loading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Container(
                margin: EdgeInsets.only(
                  bottom: 10,
                ),
                height: MediaQuery.of(context).size.height * 0.28,
                width: MediaQuery.of(context).size.width * 0.5,
                // width: 202,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: background,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            // BoxShadow(
                            //   offset: Offset(2, 3),
                            //   spreadRadius: 2,
                            //   color: Colors.black.withOpacity(.6),
                            // ),
                          ],
                        ),
                      ),
                    ),

                    // book images
                    GestureDetector(
                      onTap: widget.pressDetails,
                      child: widget.image != null
                          ? GestureDetector(
                              onTap: widget.pressDetails,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 0, 10),
                                child: PhysicalModel(
                                  color: themeProvider.isLightTheme
                                      ? Colors.black
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(7),
                                  elevation: 30,
                                  shape: BoxShape.rectangle,
                                  shadowColor: Colors.black,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(3),
                                      child: Imageview(
                                        image: widget.image,
                                        width: 100,
                                        height: 100,
                                        radius: 8,
                                      )),
                                ),
                              ))
                          : Image.asset(
                              'assets/images/book-1.png',
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                    ),

                    Positioned(
                      top: 60,
                      right: -7,
                      child: Material(
                        color: Colors.transparent,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            BookRating(score: widget.rating),
                            IconButton(
                              icon: Icon(
                                Icons.favorite_border,
                                size: 25,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                // ("containes  ${flist.contains(27)}");

                                ///add into database.tr
                                DatabaseHelper.instance.insertTodo(Todo(
                                    id: widget.bookid,
                                    rating: widget.rating.toString(),
                                    pdf: "pdf",
                                    coverimage: widget.image,
                                    link: path,
                                    authername: widget.auth,
                                    bookid: widget.bookid,
                                    title: widget.title));

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
                      ),
                    ),
                    Positioned(
                      top: 160,
                      left: 0,
                      width: 211,
                      child: Container(
                        height: 93,
                        width: 202,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 24),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return Category(
                                      title: widget.auth,
                                      catid: widget.authid,
                                      id: widget.authid,
                                      name: widget.auth,
                                      image: widget.image,
                                      description: widget.author_description,
                                    );
                                  }));
                                },
                                child: RichText(
                                  maxLines: 2,
                                  text: TextSpan(
                                    style: TextStyle(color: kBlackColor),
                                    children: [
                                      TextSpan(
                                        text: "${widget.title}\n",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          color: Color(0xffD1D1D1),
                                        ),
                                      ),
                                      TextSpan(
                                        text: widget.auth,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Spacer(
                              flex: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: widget.pressDetails,
                                    child: Container(
                                      width: 101,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      alignment: Alignment.center,
                                      child: Text(
                                        S.of(context).reading_card_list_DETAILS,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            decoration: TextDecoration.none,
                                            fontFamily: 'Nunito'),
                                      ),
                                    ),
                                  ),
                                  FutureBuilder<List<DownloadModel>>(
                                      future: DownloadDatabaseHelper.instance
                                          .retrieveTodos(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          if (id.isNotEmpty) {
                                            id.clear();
                                            for (var i = 0;
                                                i < snapshot.data.length;
                                                i++) {
                                              id.add(snapshot.data[i].id);
                                            }
                                          } else {
                                            for (var i = 0;
                                                i < snapshot.data.length;
                                                i++) {
                                              id.add(snapshot.data[i].id);
                                            }
                                          }

                                          return Container(
                                            height: 40,
                                            // width: 50,
                                            decoration: BoxDecoration(
                                                color: buttonColorAccent,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                )),
                                            child: _buildDownloadReadButton(
                                                appDocDir: appDocDir,
                                                context: context,
                                                image: widget.image,
                                                provider: detailsProvider,
                                                idData: id,
                                                title: widget.title
                                                    .replaceAll(' ', '_')
                                                    .replaceAll(r"\'", "'"),
                                                link: path,
                                                id: widget.bookid),
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
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
    });
  }

  _buildDownloadReadButton(
      {Directory appDocDir,
      DetailsProvider provider,
      BuildContext context,
      var title,
      var link,
      var image,
      List idData,
      var id}) {
    String path = Platform.isIOS
        ? appDocDir.path + '/$id.epub'
        : appDocDir.path + '/Ebook/$id.epub';

    if (link.toString().contains('epub')) {
      if (idData.toString().contains(id.toString())) {
        return FlatButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return EpuB(id: widget.bookid, path: path);
            }));
          },
          child: Text('Read Book',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Nunito')),
        );
      } else {
        return FlatButton(
          onPressed: () {
            provider
                .downloadFile(context, link, id.toString(), id, widget.image)
                .whenComplete(() {
              DownloadDatabaseHelper.instance.insertTodo(DownloadModel(
                  id: widget.bookid, link: path, image: widget.image));
              setState(() {});
            });
          },
          child: Text(
            'Download',
            style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.normal),
          ),
        );
      }
    } else {
      return FlatButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PdfViewerPage(
                bookid: id,
                image: image,
                txt: title,
              ),
            ),
          );
        },
        child: Text('Read Book',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Nunito',
                fontSize: 10,
                fontWeight: FontWeight.normal)),
      );
    }
  }
}

class EpuB extends StatefulWidget {
  EpuB({this.id, this.path});

  int id;
  String path;

  @override
  _EpuBState createState() => _EpuBState();
}

class _EpuBState extends State<EpuB> {
  @override
  void initState() {
    // TODO: implement initState
    EpubViewer.setConfig(
        themeColor: Colors.black,
        identifier: "book",
        scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
        allowSharing: true,
        enableTts: true,
        nightMode: true);
    bannerImage2();
    super.initState();
  }

  bannerImage2() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();

      var uid = pref.getInt('uid');

      var response1 = await http.get(Uri.parse(
          "$mainapilink/api.php?continue_reading&con_user_id=$uid&con_book_id=${widget.id}"));
      if (response1.statusCode == 200) {
        var i = jsonDecode(response1.body);
      } else {}
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    var i = widget.path;

    return Container(child: epub(path: i));
  }

  Widget epub({path}) {
    EpubViewer.open(path);
  }
}
