import 'dart:convert' as convert;

import 'package:elearn/screens/details_screen.dart';
import 'package:elearn/screens/explore.dart';
import 'package:elearn/screens/view.dart';
import 'package:elearn/widgets/reading_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../consttants.dart';

class Category extends StatefulWidget {
  Category(
      {this.catid,
      this.title,
      this.id,
      this.image,
      this.name,
      this.description});

  final int catid;
  final String title;
  final int id;
  final String image;
  final String name;
  final String description;

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  void initState() {
    // TODO: implement initState
    categories();
    super.initState();
  }

  List cat = [];

  categories() async {
    if (!mounted) return;
    setState(() {
      spin = true;
    });
    var response = await http
        .get(Uri.parse('$mainapilink/api.php?author_id=${widget.id}'));
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      var second = jsonResponse["EBOOK_APP"];
      cat = second;
      // (cat);
      if (!mounted) return;
      setState(() {
        spin = false;
      });
    } else {}
  }

  bool spin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
          backgroundColor: Colors.black,
          leadingWidth: 40,
          title: Text(
            'Auther',
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: Text(
                        '${widget.name}',
                        maxLines: 2,
                        // overflow: TextOverflow.fade,
                        // softWrap: false,
                        // textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'Helvetica Neue',
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    PhysicalModel(
                      elevation: 13,
                      shape: BoxShape.rectangle,
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      shadowColor: Colors.black87,
                      child: Imageview(
                        image: widget.image,
                        radius: 10,
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.width * 0.4,
                      ),
                    ),
                    // Image.network(
                    //   '${widget.image}',
                    //   height: MediaQuery.of(context).size.height * 0.3,
                    //   width: MediaQuery.of(context).size.width * 0.4,
                    // )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Html(
                    data: '${widget.description}',
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Stack(
                children: [
                  ModalProgressHUD(
                    inAsyncCall: spin,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: GridView.builder(
                          physics: new NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: cat.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            var image = cat[index]["book_cover_img"];
                            var rating = cat[index]["rate_avg"];
                            var title = cat[index]["book_title"];
                            var auth = cat[index]["author_name"];
                            var id = cat[index]["id"];
                            var i = int.parse(id);

                            return ReadingListCard(
                              image: image,
                              rating: rating,
                              radius: 35,
                              title: title,
                              auth: auth,
                              bookid: i,
                              pressDetails: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return DetailsScreen(
                                    rating: rating,
                                    txt: title
                                        .replaceAll(' ', '_')
                                        .replaceAll(r"\'", "'"),
                                    id: i,
                                    title: auth,
                                    image: image,
                                  );
                                }));
                              },
                              pressRead: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return PdfViewerPage(
                                    bookid: i,
                                    txt: widget.title,
                                    image: image,
                                  );
                                }));
                              },
                            );
                          }),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
