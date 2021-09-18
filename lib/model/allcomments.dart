// To parse this JSON data, do
//
//     final allComments = allCommentsFromJson(jsonString);

import 'dart:convert';

AllComments allCommentsFromJson(String str) =>
    AllComments.fromJson(json.decode(str));

String allCommentsToJson(AllComments data) => json.encode(data.toJson());

class AllComments {
  AllComments({
    this.ebookApp,
  });

  List<EbookApp> ebookApp;

  factory AllComments.fromJson(Map<String, dynamic> json) => AllComments(
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
    this.bookId,
    this.userId,
    this.userImage,
    this.userName,
    this.userEmail,
    this.commentText,
    this.dtRate,
    this.commentOn,
  });

  String id;
  String bookId;
  String userId;
  String userImage;
  String userName;
  String userEmail;
  String commentText;
  String dtRate;
  String commentOn;

  factory EbookApp.fromJson(Map<String, dynamic> json) => EbookApp(
        id: json["id"],
        bookId: json["book_id"],
        userId: json["user_id"],
        userImage: json["user_image"],
        userName: json["user_name"],
        userEmail: json["user_email"],
        commentText: json["comment_text"],
        dtRate: json["dt_rate"],
        commentOn: json["comment_on"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "book_id": bookId,
        "user_id": userId,
        "user_image": userImage,
        "user_name": userName,
        "user_email": userEmail,
        "comment_text": commentText,
        "dt_rate": dtRate,
        "comment_on": commentOn,
      };
}
