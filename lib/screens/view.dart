import 'dart:convert' as convert;
import 'dart:isolate';
import 'dart:ui';

import 'package:elearn/epub_viewer_lib/epub_viewer.dart';
import 'package:elearn/epub_viewer_lib/utils/util.dart';
import 'package:elearn/generated/l10n.dart';
import 'package:elearn/widgets/ApiServiceProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../consttants.dart';

const debug = true;

class PdfViewerPage extends StatefulWidget {
  PdfViewerPage({this.bookid, this.txt, this.image});

  final int bookid;
  final String txt;
  String image;
  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {

  String localPath;
//  String image;
  List cat = [];
  double progress = 0;
  int uid;
  prfrences() async {
    //     Provider.of<ThemeProvider>(context, listen: false);
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('continuename', widget.txt);
    // themeProvider.continueNameSet(widget.txt);
    pref.setInt('continueid', widget.bookid);
    uid = pref.getInt('uid');
    // themeProvider.continueIdSet(widget.bookid);
    pref.reload().then((value) {
      if (!mounted) return;
      setState(() {});
    });
  }

  bannerImage2() async {
    try {
      var response1 = await http.get(Uri.parse(
          "$mainapilink/api.php?continue_reading&con_user_id=$uid&con_book_id=${widget.bookid}"

          ));
      if (response1.statusCode == 200) {
        var i = convert.jsonDecode(response1.body);

      } else {}
    } catch (e) {}
  }

  Future<String> loadPDF(List cat, int id) async {
    final String bASEURL = "$mainapilink/api.php?book_id=$id";
    var response = await http.get(Uri.parse(bASEURL));
    var jsonResponse = convert.jsonDecode(response.body);
    var second = jsonResponse["EBOOK_APP"];
    cat = second;
    var i;
    SharedPreferences pref = await SharedPreferences.getInstance();


    pref.setString('continueimage', widget.image);
    setState(() {
      i = cat[0]["book_file_url"];
    });
    return i;
  }

  _init() async {
    await FlutterDownloader.initialize(debug: debug);
  }

  @override
  void initState() {

    _init();
    FlutterDownloader.registerCallback(downloadCallback);
    EpubViewer.setConfig(
        themeColor: Colors.black,
        identifier: "book",
        scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
        allowSharing: true,
        enableTts: true,
        nightMode: true);
    super.initState();
    prfrences();
    bannerImage2();
    loadPDF(cat, widget.bookid).then((value) {
      localPath = value;
      ApiServiceProvider.loadPDF(value).then((value) {
        if (!mounted) return;
        setState(() {
          (localPath);
        });
      });
    });
  }



  Widget epub() {
    EpubViewer.open("storage/emulated/0/Ebook/demo sway.epub");
  }

  @override
  Widget build(BuildContext context) {
    // EpubKitty.setConfig("iosBook", "#32a852", "vertical", true);
    bannerImage2();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              size: 25,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          "${widget.txt}...",
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Nunito'),
        ),
      ),

      ///progress bar with colored indicator
      body: Container(
        child: localPath != null
            ? localPath.contains('.epub')
                ? epub()
                : PDF(fitEachPage: true, preventLinkNavigation: true)
                    .cachedFromUrl(
                    localPath,
                    placeholder: (progress) {
                      currentProgressColor() {
                        if (progress >= 60 && progress < 80) {
                          return Colors.orange;
                        }
                        if (progress >= 80) {
                          return Colors.red;
                        } else {
                          return Colors.green;
                        }
                      }

                      return Center(
                        child: CircularPercentIndicator(
                          footer: Text(
                            "${progress.toString()} %",
                            style: TextStyle(
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                          animationDuration: 200,
                          animateFromLastPercent: true,
                          arcType: ArcType.FULL,
                          arcBackgroundColor: Colors.black12,
                          backgroundColor: Colors.white,
                          progressColor: currentProgressColor(),
                          percent: progress.toDouble() / 100,
                          animation: true,
                          radius: 100.0,
                          lineWidth: 12.0,
                          circularStrokeCap: CircularStrokeCap.butt,
                        ),
                      );
                    },
                    errorWidget: (error) =>
                        Center(child: Text(error.toString())),
                  )
            : Center(
                child: Text(
                  S.of(context).view_LOADING,
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                ),
              ),
      ),
    );
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    if (debug) {

    }
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }
}

class AutherView extends StatefulWidget {
  AutherView({this.bookid, this.txt});

  final int bookid;
  final String txt;

  @override
  _AutherViewState createState() => _AutherViewState();
}

class _AutherViewState extends State<AutherView> {
  String localPath;
  List cat = [];
  double progress = 0;

  Future<String> loadPDF(List cat, int id) async {
    final String bASEURL = "$mainapilink/api.php?author_id=1";
    var response = await http.get(Uri.parse(bASEURL));
    var jsonResponse = convert.jsonDecode(response.body);
    var second = jsonResponse["EBOOK_APP"];
    cat = second;
    var i;
    setState(() {
      i = cat[0]["book_file_url"];
    });
    return i;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadPDF(cat, widget.bookid).then((value) {
      localPath = value;
      (localPath);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "${widget.txt}...",
            style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Nunito'),
          ),
        ),

        ///progress bar with colored indicator
        body: PDF(
          fitEachPage: true,
        ).cachedFromUrl(localPath));
  }
}
