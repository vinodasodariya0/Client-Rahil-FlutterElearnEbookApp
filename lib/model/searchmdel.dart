// To parse this JSON data, do
//
//     final searchModel = searchModelFromJson(jsonString);

import 'dart:convert';

SearchModel searchModelFromJson(String str) =>
    SearchModel.fromJson(json.decode(str));

String searchModelToJson(SearchModel data) => json.encode(data.toJson());

class SearchModel {
  SearchModel({
    this.ebookApp,
  });

  List<EbookApp> ebookApp;

  factory SearchModel.fromJson(Map<String, dynamic> json) => SearchModel(
        ebookApp: List<EbookApp>.from(
            json["EBOOK_APP"].map((x) => EbookApp.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "EBOOK_APP": List<dynamic>.from(ebookApp.map((x) => x.toJson())),
      };
}

class EbookApp {
  EbookApp({
    this.id,
    this.catId,
    this.aid,
    this.bookTitle,
    this.bookDescription,
    this.bookCoverImg,
    this.bookBgImg,
    this.bookFileType,
    this.totalRate,
    this.rateAvg,
    this.bookViews,
    this.authorId,
    this.authorName,
    this.authorDescription,
    this.cid,
    this.categoryName,
  });

  String id;
  String catId;
  String aid;
  String bookTitle;
  String bookDescription;
  String bookCoverImg;
  String bookBgImg;
  String bookFileType;
  String totalRate;
  String rateAvg;
  String bookViews;
  String authorId;
  String authorName;
  String authorDescription;
  String cid;
  String categoryName;

  factory EbookApp.fromJson(Map<String, dynamic> json) => EbookApp(
        id: json["id"],
        catId: json["cat_id"],
        aid: json["aid"],
        bookTitle: json["book_title"],
        bookDescription: json["book_description"],
        bookCoverImg: json["book_cover_img"],
        bookBgImg: json["book_bg_img"],
        bookFileType: json["book_file_type"],
        totalRate: json["total_rate"],
        rateAvg: json["rate_avg"],
        bookViews: json["book_views"],
        authorId: json["author_id"],
        authorName: json["author_name"],
        authorDescription: json["author_description"],
        cid: json["cid"],
        categoryName: json["category_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cat_id": catId,
        "aid": aid,
        "book_title": bookTitle,
        "book_description": bookDescription,
        "book_cover_img": bookCoverImg,
        "book_bg_img": bookBgImg,
        "book_file_type": bookFileType,
        "total_rate": totalRate,
        "rate_avg": rateAvg,
        "book_views": bookViews,
        "author_id": authorId,
        "author_name": authorName,
        "author_description": authorDescription,
        "cid": cid,
        "category_name": categoryName,
      };
}
