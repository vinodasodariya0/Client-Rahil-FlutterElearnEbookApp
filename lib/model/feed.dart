import 'dart:convert';

class Feed {
  String xmlLang;
  String xmlns;
  String xmlnsDcterms;
  String xmlnsThr;
  String xmlnsApp;
  String xmlnsOpensearch;
  String xmlnsOpds;
  String xmlnsXsi;
  String xmlnsOdl;
  String xmlnsSchema;
  Id id;
  Id title;
  Id updated;
  Id icon;
  Author author;
  List<Link> link;
  Id opensearchTotalResults;
  Id opensearchItemsPerPage;
  Id opensearchStartIndex;
  List<Entry> entry;

  Feed(
      {this.xmlLang,
      this.xmlns,
      this.xmlnsDcterms,
      this.xmlnsThr,
      this.xmlnsApp,
      this.xmlnsOpensearch,
      this.xmlnsOpds,
      this.xmlnsXsi,
      this.xmlnsOdl,
      this.xmlnsSchema,
      this.id,
      this.title,
      this.updated,
      this.icon,
      this.author,
      this.link,
      this.opensearchTotalResults,
      this.opensearchItemsPerPage,
      this.opensearchStartIndex,
      this.entry});

  Feed.fromJson(Map<String, dynamic> json) {
    xmlLang = json['xml:lang'];
    xmlns = json[r'xmlns'];
    xmlnsDcterms = json[r'xmlns$dcterms'];
    xmlnsThr = json[r'xmlns$thr'];
    xmlnsApp = json[r'xmlns$app'];
    xmlnsOpensearch = json[r'xmlns$opensearch'];
    xmlnsOpds = json[r'xmlns$opds'];
    xmlnsXsi = json[r'xmlns$xsi'];
    xmlnsOdl = json[r'xmlns$odl'];
    xmlnsSchema = json[r'xmlns$schema'];
    id = json['id'] != null ? new Id.fromJson(json['id']) : null;
    title = json['title'] != null ? new Id.fromJson(json['title']) : null;
    updated = json['updated'] != null ? new Id.fromJson(json['updated']) : null;
    icon = json['icon'] != null ? new Id.fromJson(json['icon']) : null;
    author =
        json['author'] != null ? new Author.fromJson(json['author']) : null;
    if (json['link'] != null) {
      link = new List<Link>();
      json['link'].forEach((v) {
        link.add(new Link.fromJson(v));
      });
    }
    opensearchTotalResults = json[r'opensearch$totalResults'] != null
        ? new Id.fromJson(json[r'opensearch$totalResults'])
        : null;
    opensearchItemsPerPage = json[r'opensearch$itemsPerPage'] != null
        ? new Id.fromJson(json[r'opensearch$itemsPerPage'])
        : null;
    opensearchStartIndex = json[r'opensearch$startIndex'] != null
        ? new Id.fromJson(json[r'opensearch$startIndex'])
        : null;
    if (json['entry'] != null) {
      String t = json['entry'].runtimeType.toString();
      if (t == 'List<dynamic>' || t == '_GrowableList<dynamic>') {
        entry = new List<Entry>();
        json['entry'].forEach((v) {
          entry.add(new Entry.fromJson(v));
        });
      } else {
        entry = new List<Entry>();
        entry.add(new Entry.fromJson(json['entry']));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['xml:lang'] = this.xmlLang;
    data[r'xmlns'] = this.xmlns;
    data[r'xmlns$dcterms'] = this.xmlnsDcterms;
    data[r'xmlns$thr'] = this.xmlnsThr;
    data[r'xmlns$app'] = this.xmlnsApp;
    data[r'xmlns$opensearch'] = this.xmlnsOpensearch;
    data[r'xmlns$opds'] = this.xmlnsOpds;
    data[r'xmlns$xsi'] = this.xmlnsXsi;
    data[r'xmlns$odl'] = this.xmlnsOdl;
    data[r'xmlns$schema'] = this.xmlnsSchema;
    if (this.id != null) {
      data['id'] = this.id.toJson();
    }
    if (this.title != null) {
      data['title'] = this.title.toJson();
    }
    if (this.updated != null) {
      data['updated'] = this.updated.toJson();
    }
    if (this.icon != null) {
      data['icon'] = this.icon.toJson();
    }
    if (this.author != null) {
      data['author'] = this.author.toJson();
    }
    if (this.link != null) {
      data['link'] = this.link.map((v) => v.toJson()).toList();
    }
    if (this.opensearchTotalResults != null) {
      data[r'opensearch$totalResults'] = this.opensearchTotalResults.toJson();
    }
    if (this.opensearchItemsPerPage != null) {
      data[r'opensearch$itemsPerPage'] = this.opensearchItemsPerPage.toJson();
    }
    if (this.opensearchStartIndex != null) {
      data[r'opensearch$startIndex'] = this.opensearchStartIndex.toJson();
    }
    if (this.entry != null) {
      data['entry'] = this.entry.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Id {
  String t;

  Id({this.t});

  Id.fromJson(Map<String, dynamic> json) {
    t = json[r'$t'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[r'$t'] = this.t;
    return data;
  }
}

class Author {
  Id name;
  Id uri;
  Id email;

  Author({this.name, this.uri, this.email});

  Author.fromJson(Map<String, dynamic> json) {
    name = json['name'] != null ? new Id.fromJson(json['name']) : null;
    uri = json['uri'] != null ? new Id.fromJson(json['uri']) : null;
    email = json['email'] != null ? new Id.fromJson(json['email']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.name != null) {
      data['name'] = this.name.toJson();
    }
    if (this.uri != null) {
      data['uri'] = this.uri.toJson();
    }
    if (this.email != null) {
      data['email'] = this.email.toJson();
    }
    return data;
  }
}

class Link {
  String rel;
  String type;
  String href;
  String title;
  String opdsActiveFacet;
  String opdsFacetGroup;
  String thrCount;

  Link(
      {this.rel,
      this.type,
      this.href,
      this.title,
      this.opdsActiveFacet,
      this.opdsFacetGroup,
      this.thrCount});

  Link.fromJson(Map<String, dynamic> json) {
    rel = json['rel'];
    type = json['type'];
    href = json['href'];
    title = json['title'];
    opdsActiveFacet = json['opds:activeFacet'];
    opdsFacetGroup = json['opds:facetGroup'];
    thrCount = json['thr:count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rel'] = this.rel;
    data['type'] = this.type;
    data['href'] = this.href;
    data['title'] = this.title;
    data['opds:activeFacet'] = this.opdsActiveFacet;
    data['opds:facetGroup'] = this.opdsFacetGroup;
    data['thr:count'] = this.thrCount;
    return data;
  }
}
// To parse this JSON data, do
//
//     final entry = entryFromJson(jsonString);

Entry entryFromJson(String str) => Entry.fromJson(json.decode(str));

String entryToJson(Entry data) => json.encode(data.toJson());

class Entry {
  Entry({
    this.ebookApp,
  });

  List<EbookApp> ebookApp;

  factory Entry.fromJson(Map<String, dynamic> json) => Entry(
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
    this.featured,
    this.bookTitle,
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
    this.relatedBooks,
    this.userComments,
  });

  String id;
  String catId;
  String aid;
  String featured;
  String bookTitle;
  String bookDescription;
  String bookCoverImg;
  dynamic bookBgImg;
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
  List<EbookApp> relatedBooks;
  List<UserComment> userComments;

  factory EbookApp.fromJson(Map<String, dynamic> json) => EbookApp(
        id: json["id"],
        catId: json["cat_id"],
        aid: json["aid"],
        featured: json["featured"] == null ? null : json["featured"],
        bookTitle: json["book_title"],
        bookDescription: json["book_description"],
        bookCoverImg: json["book_cover_img"],
        bookBgImg: json["book_bg_img"],
        bookFileType: json["book_file_type"],
        bookFileUrl:
            json["book_file_url"] == null ? null : json["book_file_url"],
        totalRate: json["total_rate"],
        rateAvg: json["rate_avg"],
        bookViews: json["book_views"],
        authorId: json["author_id"],
        authorName: json["author_name"],
        authorDescription: json["author_description"],
        cid: json["cid"],
        categoryName: json["category_name"],
        relatedBooks: json["related_books"] == null
            ? null
            : List<EbookApp>.from(
                json["related_books"].map((x) => EbookApp.fromJson(x))),
        userComments: json["user_comments"] == null
            ? null
            : List<UserComment>.from(
                json["user_comments"].map((x) => UserComment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cat_id": catId,
        "aid": aid,
        "featured": featured == null ? null : featured,
        "book_title": bookTitle,
        "book_description": bookDescription,
        "book_cover_img": bookCoverImg,
        "book_bg_img": bookBgImg,
        "book_file_type": bookFileType,
        "book_file_url": bookFileUrl == null ? null : bookFileUrl,
        "total_rate": totalRate,
        "rate_avg": rateAvg,
        "book_views": bookViews,
        "author_id": authorId,
        "author_name": authorName,
        "author_description": authorDescription,
        "cid": cid,
        "category_name": categoryName,
        "related_books": relatedBooks == null
            ? null
            : List<dynamic>.from(relatedBooks.map((x) => x.toJson())),
        "user_comments": userComments == null
            ? null
            : List<dynamic>.from(userComments.map((x) => x.toJson())),
      };
}

class UserComment {
  UserComment({
    this.bookId,
    this.userName,
    this.commentText,
    this.userImage,
    this.dtRate,
  });

  String bookId;
  String userName;
  String commentText;
  String userImage;
  String dtRate;

  factory UserComment.fromJson(Map<String, dynamic> json) => UserComment(
        bookId: json["book_id"],
        userName: json["user_name"],
        commentText: json["comment_text"],
        userImage: json["user_image"],
        dtRate: json["dt_rate"],
      );

  Map<String, dynamic> toJson() => {
        "book_id": bookId,
        "user_name": userName,
        "comment_text": commentText,
        "user_image": userImage,
        "dt_rate": dtRate,
      };
}

class Author1 {
  Id name;
  Id uri;

  Author1({this.name, this.uri});

  Author1.fromJson(Map<String, dynamic> json) {
    name = json['name'] != null ? new Id.fromJson(json['name']) : null;
    uri = json['uri'] != null ? new Id.fromJson(json['uri']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.name != null) {
      data['name'] = this.name.toJson();
    }
    if (this.uri != null) {
      data['uri'] = this.uri.toJson();
    }
    return data;
  }
}

class Category {
  String label;
  String term;
  String scheme;

  Category({this.label, this.term, this.scheme});

  Category.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    term = json['term'];
    scheme = json['scheme'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['term'] = this.term;
    data['scheme'] = this.scheme;
    return data;
  }
}

class Link1 {
  String type;
  String rel;
  String title;
  String href;

  Link1({this.type, this.rel, this.title, this.href});

  Link1.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    rel = json['rel'];
    title = json['title'];
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['rel'] = this.rel;
    data['title'] = this.title;
    data['href'] = this.href;
    return data;
  }
}

class SchemaSeries {
  String schemaPosition;
  String schemaName;
  String schemaUrl;

  SchemaSeries({this.schemaPosition, this.schemaName, this.schemaUrl});

  SchemaSeries.fromJson(Map<String, dynamic> json) {
    schemaPosition = json[r'schema:position'];
    schemaName = json[r'schema:name'];
    schemaUrl = json[r'schema:url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[r'schema:position'] = this.schemaPosition;
    data[r'schema:name'] = this.schemaName;
    data[r'schema:url'] = this.schemaUrl;
    return data;
  }
}
