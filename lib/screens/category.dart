import 'dart:convert' as convert;

import 'package:elearn/screens/setting/detailscreen2.dart';
import 'package:elearn/screens/setting/reading_card_list2.dart';
import 'package:elearn/screens/view.dart';
import 'package:elearn/widgets/models_providers%20.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import '../consttants.dart';

class Newcate extends StatefulWidget {
  Newcate({
    this.catid,
    this.title,
    this.id,
  });
  final int catid;
  final String title;
  final String id;

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Newcate> {
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
        .get(Uri.parse('$mainapilink/api.php?${widget.id}=${widget.catid}'));
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
          backgroundColor: Colors.black,
          leadingWidth: 40,
          title: Text(
            'Category',
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
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.14,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text(
                  '${widget.title}',
                  style: TextStyle(
                      color: themeProvider.isLightTheme
                          ? Colors.black54
                          : Colors.white54,
                      fontSize: 28,
                      fontFamily: 'Helvetica Neue'),
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
                  child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 3,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: cat.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        var image = cat[index]["book_cover_img"];
                        var rating = cat[index]["rate_avg"];
                        var title = cat[index]["book_title"];
                        var auth = cat[index]["author_name"];
                        var authid = cat[index]["author_id"];
                        var authdes = cat[index]["author_description"];
                        var id = cat[index]["id"];
                        var i = int.parse(id);
                        return ReadingListCard2(
                          image: image,
                          rating: rating,
                          bookid: i,
                          radius: 35,
                          authid: int.parse(authid),
                          author_description: authdes,
                          title: title,
                          auth: auth,
                          pressDetails: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return DetailsScreen2(
                                rating: rating,
                                txt: title
                                    .replaceAll(' ', '_')
                                    .replaceAll(r"\'", "'"),
                                title: auth,
                                id: i,
                                image: image,
                              );
                            }));
                          },
                          pressRead: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return PdfViewerPage(
                                bookid: i,
                                image: image,
                                txt: widget.title,
                              );
                            }));
                          },
                        );
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
