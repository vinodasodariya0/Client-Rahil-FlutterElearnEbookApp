import 'dart:convert' as convert;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:elearn/generated/l10n.dart';
import 'package:elearn/widgets/beswtofday.dart';
import 'package:elearn/widgets/cat.dart';
import 'package:elearn/widgets/models_providers%20.dart';
import 'package:elearn/widgets/richtxt.dart';
import 'package:elearn/widgets/title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../consttants.dart';
import 'details_screen.dart';

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  List lat = [];
  bool spin = false;
  List auther = [];
  List all = [];

  latest() async {
    if (!mounted) return;
    setState(() {
      spin = true;
    });
    var response = await http.get(Uri.parse('$mainapilink/api.php?latest'));
    var res = await http.get(Uri.parse('$mainapilink/api.php?author_list'));
    var res1 = await http.get(Uri.parse('$mainapilink/api.php?allbook'));
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      ('RESPONSE === $jsonResponse');
      var second = jsonResponse["EBOOK_APP"];
      lat = second;

      if (!mounted) return;
      setState(() {
        spin = false;
      });
    } else {
      ('Request failed with status: ${response.statusCode}.');
    }
    if (res.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(res.body);
      var second = jsonResponse["EBOOK_APP"];
      auther = second;

      if (!mounted) return;
      setState(() {
        spin = false;
      });
    } else {
      ('Request failed with status: ${res.statusCode}.');
    }

    if (res1.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(res1.body);
      var second = jsonResponse["EBOOK_APP"];
      all = second;

      if (!mounted) return;
      setState(() {
        spin = false;
      });
    } else {
      ('Request failed with status: ${res1.statusCode}.');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    latest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          TitleBar(
            ontap: null,
            image: 'assets/images/web-browser.svg',
            appbartitle: S.of(context).explore_EXPLORE,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 10),
            child: Textrich(
              context: context,
              txt1: "${S.of(context).explore_LATEST}\n",
              txt2: S.of(context).explore_BOOKS,
              fontsize1: 26,
              fontsize2: 26,
            ),
          ),
          Container(
            height: 250,
            width: MediaQuery.of(context).size.width,
            child: Progress(
              spin: spin,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: lat.length,
                  itemBuilder: (context, index) {
                    var image = lat[index]["book_cover_img"];
                    var txt = lat[index]["book_title"];
                    var txt2 = lat[index]["author_name"];
                    var id = lat[index]["id"];
                    var rating = lat[index]["rate_avg"];
                    int i = int.parse(id);
                    return Latest(
                      image: image,
                      txt2: txt2,
                      txt: txt,
                      id: i,
                      rating: rating,
                    );
                  }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Textrich(
              context: context,
              txt1: "${S.of(context).explore_SEARCHED_BY}\n",
              txt2: S.of(context).explore_AUTHOR,
              fontsize1: 26,
              fontsize2: 26,
            ),
          ),
          Container(
            height: 250,
            width: MediaQuery.of(context).size.width,
            child: Progress(
              spin: spin,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: auther.length,
                  itemBuilder: (context, index) {
                    var image = auther[index]["author_image"];
                    var txt = auther[index]["author_name"];
                    var id = auther[index]["author_id"];
                    var des = auther[index]["author_description"];
                    int i = int.parse(id);

                    return Auther(
                      txt: txt,
                      image: image,
                      authid: i,
                      desc: des,
                    );
                  }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Textrich(
              context: context,
              txt1: "${S.of(context).explore_ALL_AVAILABLE} \n",
              txt2: S.of(context).explore_BOOKS_available,
              fontsize1: 26,
              fontsize2: 26,
            ),
          ),
          Container(
            height: 400,
            width: MediaQuery.of(context).size.width,
            child: GridView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, childAspectRatio: 17 / 16),
              itemCount: all.length,
              itemBuilder: (context, index) {
                var image = all[index]["book_cover_img"];
                var txt1 = all[index]["book_title"];
                var txt2 = all[index]["author_name"];
                var dis = all[index]["book_description"];
                var rat = all[index]["rate_avg"];
                var booktype = all[index]["category_name"];
                var catid = all[index]["id"];
                var link = all[index]["book_file_url"];
                var id = int.parse(catid);

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10),
                  child: Container(
                    height: 300,
                    child: BestOftheDay(
                      image: image,
                      txt1: txt1,
                      context: context,
                      txt2: txt2,
                      link: link,
                      txt: dis,
                      title: txt2,
                      rate: rat,
                      catid: id,
                      booktype: booktype,
                      size: MediaQuery.of(context).size,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
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

class Latest extends StatelessWidget {
  Latest({this.image, this.txt2, this.txt, this.id, this.rating});

  final String image;
  final String txt;
  final String txt2;
  final int id;
  final String rating;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 5),
        child: Column(children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return DetailsScreen(
                  // dis: dis,
                  image: image,
                  title: txt2,
                  txt: txt.replaceAll(' ', '_').replaceAll(r"\'", "'"),
                  id: id,
                  rating: rating,
                );
                // return PdfViewerPage(
                //   txt: txt,
                //   bookid: id,
                // );
              }));
            },
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Imageview(
                  image: image,
                  radius: 10,
                  height: 150,
                  width: 110,
                )),
          ),
          Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
              child: Container(
                width: 120,
                height: 50,
                child: Column(
                  children: [
                    Text(
                      "$txt",
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        decorationStyle: TextDecorationStyle.dotted,
                        fontSize: 18,
                        color: themeProvider.isLightTheme
                            ? Colors.black
                            : Colors.white,
                        fontFamily: "Nunito",
                      ),
                    ),
                    Text("$txt2",
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: themeProvider.isLightTheme
                              ? Colors.black
                              : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ))
                  ],
                ),
              )
              // Textrich(
              //   context: context,
              //   txt1: "$txt\n",
              //   fontsize1: 18,
              // ),
              ),
        ]),
      ),
    );
  }
}

class Auther extends StatelessWidget {
  Auther({this.image, this.txt, this.authid, this.desc, this.id});

  final int authid;
  final int id;
  final String image;
  final String txt;
  final String desc;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Category(
                title: txt,
                catid: authid,
                id: authid,
                name: txt,
                image: image,
                description: desc,
              );
            }));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
            child: PhysicalModel(
              elevation: 13,
              shape: BoxShape.rectangle,
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              shadowColor: Colors.black87,
              child: Imageview(
                image: image,
                radius: 10,
                height: 150,
                width: 100,
              ),
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: Container(
              width: 100,
              height: 50,
              child: Text(
                "$txt\n",
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  decorationStyle: TextDecorationStyle.dotted,
                  fontSize: 18,
                  color:
                      themeProvider.isLightTheme ? Colors.black : Colors.white,
                  fontFamily: "Nunito",
                ),
              ),
            )),
      ],
    );
  }
}

class Imageview extends StatelessWidget {
  const Imageview({@required this.image, this.radius, this.height, this.width});

  final String image;
  final double radius;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        filterQuality: FilterQuality.low,
        fit: BoxFit.cover,
        height: width / 0.69,
        width: width,
        placeholder: (context, url) => Shimmer.fromColors(
            baseColor: Colors.white70,
            highlightColor: Colors.blueAccent,
            period: Duration(seconds: 2),
            child: Icon(
              Icons.all_inclusive_outlined,
              size: 30,
              color: Colors.black,
            )),
        imageUrl: "$mainapilink/images/$image",
        placeholderFadeInDuration: Duration(seconds: 2),
        errorWidget: (context, url, error) => Image.asset(
          "assets/images/book-3.png",
          width: MediaQuery.of(context).size.width * .37,
        ),
      ),
    );
  }
}
