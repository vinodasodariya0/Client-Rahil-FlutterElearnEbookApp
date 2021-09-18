import 'package:elearn/databasefavourite/downloadDb.dart';
import 'package:elearn/generated/l10n.dart';
import 'package:elearn/model/searchmdel.dart';
import 'package:elearn/screens/view.dart';
import 'package:elearn/widgets/models_providers%20.dart';
import 'package:elearn/widgets/reading_card_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../consttants.dart';
import 'details_screen.dart';

// ignore: must_be_immutable
class Search extends StatefulWidget {
  Search({this.searched});

  var searched;

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool spin = false;


  Future<SearchModel> searching(text) async {
    final String bASEURL =
        "$mainapilink/api.php?search_text=${widget.searched}";
    var response = await http.get(Uri.parse(bASEURL));
    return searchModelFromJson(response.body);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  List id = [];
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return SafeArea(
        top: true,
        child: Material(
          color: Theme.of(context).backgroundColor,
          child: Container(
              height: MediaQuery.of(context).size.height,
              color: Theme.of(context).backgroundColor,
              child: ModalProgressHUD(
                inAsyncCall: spin,
                child: ListView(children: [
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 5),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Image.asset(
                              'assets/images/1.png',
                              height: 30,
                              width: 30,
                              color: themeProvider.isLightTheme
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Search Results",
                          style: TextStyle(
                              color: themeProvider.isLightTheme
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: 20,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Rubik'),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Container(
                        height: MediaQuery.of(context).size.height,
                        color: Theme.of(context).backgroundColor,
                        child: FutureBuilder<List<DownloadModel>>(
                            future:
                                DownloadDatabaseHelper.instance.retrieveTodos(),
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
                                return FutureBuilder<SearchModel>(
                                  future: searching(widget.searched),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return GridView.builder(
                                        itemCount:
                                            snapshot.data.ebookApp.length,
                                        scrollDirection: Axis.vertical,
                                        itemBuilder: (context, index) {
                                          var id =
                                              snapshot.data.ebookApp[index].id;
                                          var title = snapshot
                                              .data.ebookApp[index].bookTitle
                                              .replaceAll(' ', '_')
                                              .replaceAll(r"\'", "'");
                                          var image = snapshot.data
                                              .ebookApp[index].bookCoverImg;
                                          var cat = snapshot
                                              .data.ebookApp[index].authorName;
                                          var view = snapshot
                                              .data.ebookApp[index].rateAvg;

                                          var i = int.parse(id);

                                          return Center(
                                            child: Container(
                                              // height: 280,
                                              child: ReadingListCard(
                                                image: image,
                                                rating: view,
                                                title: title,
                                                auth: cat,
                                                radius: 35,
                                                bookid: i,
                                                pressDetails: () {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return DetailsScreen(
                                                      rating: view,
                                                      txt: title,
                                                      id: i,
                                                      title: cat,
                                                      image: image,
                                                    );
                                                  }));
                                                },
                                                pressRead: () {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return PdfViewerPage(
                                                      bookid: i,
                                                      image: image,
                                                      txt: title,
                                                    );
                                                  }));
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                mainAxisSpacing: 5,
                                                childAspectRatio: 0.7,
                                                crossAxisCount: 2,
                                                crossAxisSpacing: 0),
                                      );
                                    }


                                    else if (snapshot.hasData == null) {
                                      return Center(
                                        child: Text(
                                          S.of(context).search_NO_BOOKS_FOUND,
                                          style: TextStyle(
                                              fontSize: 25,
                                              decoration: TextDecoration.none,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontFamily: 'Nunito'),
                                        ),
                                      );
                                    } else {
                                      return Center(
                                        child: Shimmer.fromColors(
                                            baseColor: Colors.white70,
                                            highlightColor: Colors.blueAccent,
                                            period: Duration(seconds: 2),
                                            child: Icon(
                                              Icons.all_inclusive_outlined,
                                              size: 60,
                                              color: Colors.black,
                                            )),
                                      );
                                    }
                                  },
                                );
                              } else if (snapshot.hasData == null) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                return Container();
                              }
                            })),
                  ),
                ]),
              )),
        ));
  }
}
