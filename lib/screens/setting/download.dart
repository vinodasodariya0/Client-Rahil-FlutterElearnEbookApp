import 'dart:async';
import 'dart:io';

import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:elearn/consttants.dart';
import 'package:elearn/databasefavourite/downloadDb.dart';
import 'package:elearn/widgets/models_providers%20.dart';
import 'package:elearn/widgets/reading_card_list.dart';
import 'package:elearn/widgets/richtxt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class Download extends StatefulWidget {
  @override
  _DownloadState createState() => _DownloadState();
}

class _DownloadState extends State<Download> {
  List file = new List();
  Directory downloadsDirectory;
  var fileOrDir;

  directory() async {
    if (Platform.isAndroid) {
      downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;
    } else {
      downloadsDirectory = await getLibraryDirectory();
    }
    //App Document Directory + folder name
    final List<FileSystemEntity> _appDocDirFolder =
        Directory(downloadsDirectory.path + '/elearn/').listSync();
    (_appDocDirFolder);
    setState(() {
      file = _appDocDirFolder;
    });
    for (fileOrDir in file) {
      if (fileOrDir is File) {
        (fileOrDir.absolute);
      } else if (fileOrDir is Directory) {
        (fileOrDir.uri);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    directory();

    super.initState();
  }

  Future<void> deleteFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete().whenComplete(() {
          setState(() {
            directory();
          });
        });
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          leadingWidth: 40,
          title: Text(
            'Downloads',
            style: TextStyle(color: Colors.white),
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SafeArea(
            child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: themeProvider.isLightTheme
              ? Color(0xFFFFFFFF)
              : Color(0xFF26242e),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 68.0),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: FutureBuilder<List<DownloadModel>>(
                      future: DownloadDatabaseHelper.instance.retrieveTodos(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return GridView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data.length,
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 4,
                              crossAxisCount: 2,
                              mainAxisSpacing: 5,
                              childAspectRatio: 0.84,
                            ),
                            itemBuilder: (context, index) {
                              String i = snapshot.data[index].link.toString();

                              int ind = i.lastIndexOf("/");
                              if (ind > 0) i = i.substring(ind);
                              i = i.substring(0, i.length);
                              var dir;
                              for (fileOrDir in file) {
                                if (fileOrDir is File) {
                                  dir = fileOrDir.uri;
                                } else if (fileOrDir is Directory) {
                                  dir = fileOrDir.uri;
                                }
                              }

                              return GestureDetector(
                                onTap: () async {
                                  if (snapshot.data[index].link
                                      .toString()
                                      .contains('epub')) {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return EpuB(
                                          id: snapshot.data[index].id,
                                          path: snapshot.data[index].link);
                                    }));
                                  } else {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return Downloadpdf(
                                        txt: i,
                                        path: snapshot.data[index].link,
                                      );
                                    }));
                                  }
                                },
                                onLongPress: () async {
                                  await DownloadDatabaseHelper.instance
                                      .deleteTodo(snapshot.data[index].id);
                                  setState(() {
                                    //deleteFile(snapshot.data[index].id);
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      Image(
                                        image: NetworkImage(
                                            "$mainapilink/images/${snapshot.data[index].image}"),
                                        height: 180,
                                        width: 150,
                                        fit: BoxFit.fitHeight,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Expanded(
                                        child: Textrich(
                                          context: context,
                                          txt1: i,
                                          fontsize1: 15,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } else if (snapshot.data == null) {
                          return Center(
                            child: Text("No Downloads Available"),
                          );
                        } else {
                          return null;
                        }
                      }),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}

class Downloadpdf extends StatefulWidget {
  Downloadpdf({this.txt, this.path});

  final String txt;
  final String path;

  @override
  _DownloadpdfState createState() => _DownloadpdfState();
}

class _DownloadpdfState extends State<Downloadpdf> {
  String pathPDF = "";
  String landscapePathPdf = "";
  String remotePDFpath = "";
  String corruptedPathPDF = "";

  var i;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
      body: Container(
          color: Colors.black,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: pathPDF != null || pathPDF.isNotEmpty
              ? PDFScreen(path: widget.path)
              : Center(
                  child: Text(
                    'Loading',
                    style: TextStyle(color: Colors.black),
                  ),
                )),
    );
  }
}

class PDFScreen extends StatefulWidget {
  final String path;

  PDFScreen({Key key, this.path}) : super(key: key);

  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  Completer<PDFViewController> _controller;
  int pages = 0;
  int currentPage = 0;
  int total = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  void initState() {
    // TODO: implement initState
    _controller = Completer<PDFViewController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: <Widget>[
            PDF(fitEachPage: true, preventLinkNavigation: true).cachedFromUrl(
              widget.path,
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
              errorWidget: (error) => Center(child: Text(error.toString())),
            ),
            errorMessage.isEmpty
                ? !isReady
                    ? Center()
                    : Container()
                : Center(
                    child: Text(errorMessage),
                  )
          ],
        ),
        floatingActionButton: RaisedButton(
            onPressed: null,
            color: ThemeProvider().isLightTheme != true
                ? Colors.black
                : Colors.white,
            child: Text(
              'page: $currentPage',
              style: TextStyle(
                  color: ThemeProvider().isLightTheme != true
                      ? Colors.white54
                      : Colors.black54),
            )));
  }
}
