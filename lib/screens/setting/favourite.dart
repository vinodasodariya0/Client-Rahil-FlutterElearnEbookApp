import 'dart:io';

import 'package:elearn/databasefavourite/downloadDb.dart';
import 'package:elearn/model/detailsProvider.dart';
import 'package:elearn/screens/databasefavourite/db.dart';
import 'package:elearn/widgets/reading_card_list.dart';
import 'package:elearn/widgets/richtxt.dart';
import 'package:elearn/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../explore.dart';
import '../view.dart';

class ReadTodoScreen extends StatefulWidget {
  @override
  _ReadTodoScreenState createState() => _ReadTodoScreenState();
}

class _ReadTodoScreenState extends State<ReadTodoScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PreferredSize();
  }

  List<String> flist = [];
  SharedPreferences p;
  PreferredSize() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    p = pref;
  }

  _deleteTodo(Todo todo) {
    DatabaseHelper.instance.deleteTodo(todo.id);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            TitleBar(
              ontap: () {
                Navigator.pop(context);
              },
              image: 'assets/images/previous.svg',
              appbartitle: 'Favourite',
            ),
            Container(
              margin: EdgeInsets.only(top: 60),
              height: MediaQuery.of(context).size.height,
              child: FutureBuilder<List<Todo>>(
                future: DatabaseHelper.instance.retrieveTodos(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 5,
                          crossAxisCount: 2,
                          mainAxisSpacing: 0,
                          childAspectRatio: 0.7),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        flist.add(snapshot.data[index].bookid.toString());
                        p.setStringList('favlist', flist);
                        return GestureDetector(
                          onLongPress: () {
                            _deleteTodo(snapshot.data[index]);
                            flist.clear();
                            setState(() {});
                          },
                          child: FavScreen(
                            image: snapshot.data[index].coverimage,
                            id: snapshot.data[index].bookid,
                            txt: snapshot.data[index].title,
                            txt2: snapshot.data[index].title,
                            link: snapshot.data[index].link,
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text("Oops!");
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FavScreen extends StatefulWidget {
  FavScreen({this.image, this.txt2, this.txt, this.id, this.link});

  final String image;
  final String txt;
  final String txt2;
  final String link;
  final int id;

  @override
  _FavScreenState createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  List id = [];
  @override
  Widget build(BuildContext context) {
    return Consumer<DetailsProvider>(builder:
        (BuildContext context, DetailsProvider detailsProvider, Widget child) {
      return FutureBuilder<List<DownloadModel>>(
          future: DownloadDatabaseHelper.instance.retrieveTodos(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (id.isNotEmpty) {
                id.clear();
                for (var i = 0; i < snapshot.data.length; i++) {
                  id.add(snapshot.data[i].id);
                }
              } else {
                for (var i = 0; i < snapshot.data.length; i++) {
                  id.add(snapshot.data[i].id);
                }
              }

              return Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0.0, horizontal: 30),
                  child: Column(children: [
                    GestureDetector(
                      onTap: () async {
                        ('PDF ===== ${widget.link}');
                        Directory appDocDir = Platform.isAndroid
                            ? await getExternalStorageDirectory()
                            : await getApplicationDocumentsDirectory();
                        String path = Platform.isIOS
                            ? appDocDir.path + '/${widget.id}.epub'
                            : appDocDir.path + '/Ebook/${widget.id}.epub';

                        if (widget.link.toString().contains('epub')) {
                          if (id.toString().contains(widget.id.toString())) {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return EpuB(id: widget.id, path: path);
                            })).then((value) {
                              setState(() {});
                            });
                          } else {
                            detailsProvider
                                .downloadFile(
                                    context,
                                    widget.link,
                                    widget.id.toString(),
                                    widget.id,
                                    widget.image)
                                .then((value) {
                              DownloadDatabaseHelper.instance.insertTodo(
                                  DownloadModel(
                                      id: widget.id,
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
                                bookid: widget.id,
                                image: widget.image,
                                txt: widget.txt,
                              ),
                            ),
                          );
                        }
                      },
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Imageview(
                            image: widget.image,
                            radius: 10,
                            height: 150,
                            width: 110,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 10),
                      child: Center(
                          child: Textrich(
                        context: context,
                        fontsize1: 15,
                        txt1: "${widget.txt}\n",
                        fontsize2: 10,
                        txt2: widget.txt2,
                      )),
                    )
                  ]),
                ),
              );
            } else if (snapshot.hasData == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Container();
            }
          });
    });
  }
}
