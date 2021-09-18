import 'dart:convert' as convert;

import 'package:elearn/screens/setting/detailscreen2.dart';
import 'package:elearn/screens/setting/reading_card_list2.dart';
import 'package:elearn/screens/view.dart';
import 'package:elearn/widgets/models_providers%20.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../consttants.dart';

class Gridvieww extends StatefulWidget {
  Gridvieww({this.id, this.title});

  String id;
  String title;

  @override
  _GridviewwState createState() => _GridviewwState();
}

class _GridviewwState extends State<Gridvieww> {
  bool _isLoading = true;
  void initState() {
    hello(id: widget.id, list: thriller);
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        hello(id: widget.id, list: thriller);
      }
    });
  }

  List thriller = [];
  int num = 1;
  List Bookslist;
  Future<dynamic> hello({String id, List list}) async {
    try {
      setState(() {
        _isLoading = true;
      });
      var response1 = await http.get(Uri.parse(
          '$mainapilink/api.php?method_name=home_section_id&homesection_id=$id&page=$num'));
      if (response1.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response1.body);

        Bookslist = jsonResponse["EBOOK_APP"];
        for (int i = 0; i < Bookslist.length; i++) {
          list.add(Bookslist[i]);
        }

        num++;

        setState(() {
          _isLoading = false;
        });
      } else {}
    } catch (e) {} finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  ScrollController _sc = new ScrollController();

  @override
  void dispose() {
    // TODO: implement dispose
    _sc.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          leadingWidth: 40,
          title: Text('${widget.title}'),
          titleTextStyle: TextStyle(
            color: themeProvider.isLightTheme ? Colors.black54 : Colors.white54,
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: SvgPicture.asset(
                'assets/images/1.svg',
                color: themeProvider.isLightTheme
                    ? Colors.black54
                    : Colors.white54,
                height: 6,
                width: 6,
              ),
            ),
          )),
      body: Column(
        children: <Widget>[
          Expanded(
            // color: Colors.white12,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: GridView.builder(
                  controller: _sc,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1 / 1.55,
                      crossAxisCount: 2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: thriller.length,
                  itemBuilder: (context, index) {
                    var bookfamous = thriller[index]["book_title"];
                    var auther = thriller[index]["author_name"];
                    var image = thriller[index]["book_cover_img"];
                    var rating = thriller[index]["rate_avg"];
                    var bookid = thriller[index]["id"];
                    var dis = thriller[index]["book_description"];
                    var i = int.parse(bookid);

                    return Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: ReadingListCard2(
                        // image: image,
                        image:
                            image != null ? image : 'assets/images/book-1.png',
                        title: bookfamous,
                        auth: auther,
                        bookid: i, radius: 35,
                        rating: rating,
                        pressDetails: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return DetailsScreen2(
                                  dis: dis,
                                  title: auther,
                                  image: image,
                                  txt: bookfamous
                                      .replaceAll(' ', '_')
                                      .replaceAll(r"\'", "'"),
                                  AuthorName: auther,
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
                                image: image,
                                bookid: i,
                                txt: bookfamous,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  //   },
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
