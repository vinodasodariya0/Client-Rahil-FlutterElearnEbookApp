import 'dart:convert';

ContinueReading continueReadingFromJson(String str) =>
    ContinueReading.fromJson(json.decode(str));

String continueReadingToJson(ContinueReading data) =>
    json.encode(data.toJson());

class ContinueReading {
  ContinueReading({
    this.ebookApp,
  });

  List<EbookApp> ebookApp;

  factory ContinueReading.fromJson(Map<String, dynamic> json) =>
      ContinueReading(
        ebookApp: List<EbookApp>.from(
            json["EBOOK_APP"].map((x) => EbookApp.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "EBOOK_APP": List<dynamic>.from(ebookApp.map((x) => x.toJson())),
      };
}

class EbookApp {
  EbookApp({
    this.userId,
    this.id,
    this.catId,
    this.msg,
    this.success,
    this.aid,
    this.featured,
    this.bookTitle,
    this.bookBuyUrl,
    this.bookDescription,
    this.bookCoverImg,
    this.bookBgImg,
    this.bookFileType,
    this.bookFileUrl,
    this.totalRate,
    this.rateAvg,
    this.bookViews,
    this.authorId,
    this.authorName,
    this.authorDescription,
    this.cid,
    this.categoryName,
  });
  String msg;
  String success;
  String userId;
  String id;
  String catId;
  String aid;
  String featured;
  String bookTitle;
  String bookBuyUrl;
  String bookDescription;
  String bookCoverImg;
  String bookBgImg;
  String bookFileType;
  String bookFileUrl;
  String totalRate;
  String rateAvg;
  String bookViews;
  String authorId;
  String authorName;
  String authorDescription;
  String cid;
  String categoryName;

  factory EbookApp.fromJson(Map<String, dynamic> json) => EbookApp(
        msg: json["msg"],
        success: json["success"],
        userId: json["user_id"],
        id: json["id"],
        catId: json["cat_id"],
        aid: json["aid"],
        featured: json["featured"],
        bookTitle: json["book_title"],
        bookBuyUrl: json["book_buy_url"],
        bookDescription: json["book_description"],
        bookCoverImg: json["book_cover_img"],
        bookBgImg: json["book_bg_img"],
        bookFileType: json["book_file_type"],
        bookFileUrl: json["book_file_url"],
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
        "msg": msg,
        "success": success,
        "user_id": userId,
        "id": id,
        "cat_id": catId,
        "aid": aid,
        "featured": featured,
        "book_title": bookTitle,
        "book_buy_url": bookBuyUrl,
        "book_description": bookDescription,
        "book_cover_img": bookCoverImg,
        "book_bg_img": bookBgImg,
        "book_file_type": bookFileType,
        "book_file_url": bookFileUrl,
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
