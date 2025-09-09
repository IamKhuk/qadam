import 'dart:convert';

import 'package:qadam/src/model/api/book_model.dart';

BookListModel bookListModelFromJson(String str) => BookListModel.fromJson(json.decode(str));

String bookListModelToJson(BookListModel data) => json.encode(data.toJson());

class BookListModel {
  List<BookModel> data;
  BookListLinks links;
  BookListMeta meta;

  BookListModel({
    required this.data,
    required this.links,
    required this.meta,
  });

  factory BookListModel.fromJson(Map<String, dynamic> json) => BookListModel(
    data: List<BookModel>.from(json["data"].map((x) => BookModel.fromJson(x))),
    links: BookListLinks.fromJson(json["links"]),
    meta: BookListMeta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "links": links.toJson(),
    "meta": meta.toJson(),
  };
}

class BookListLinks {
  String first;
  String last;
  dynamic prev;
  dynamic next;

  BookListLinks({
    required this.first,
    required this.last,
    required this.prev,
    required this.next,
  });

  factory BookListLinks.fromJson(Map<String, dynamic> json) => BookListLinks(
    first: json["first"],
    last: json["last"],
    prev: json["prev"],
    next: json["next"],
  );

  Map<String, dynamic> toJson() => {
    "first": first,
    "last": last,
    "prev": prev,
    "next": next,
  };
}

class BookListMeta {
  int currentPage;
  int from;
  int lastPage;
  List<Link> links;
  String path;
  int perPage;
  int to;
  int total;

  BookListMeta({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    required this.links,
    required this.path,
    required this.perPage,
    required this.to,
    required this.total,
  });

  factory BookListMeta.fromJson(Map<String, dynamic> json) => BookListMeta(
    currentPage: json["current_page"],
    from: json["from"],
    lastPage: json["last_page"],
    links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
    path: json["path"],
    perPage: json["per_page"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "from": from,
    "last_page": lastPage,
    "links": List<dynamic>.from(links.map((x) => x.toJson())),
    "path": path,
    "per_page": perPage,
    "to": to,
    "total": total,
  };
}

class Link {
  String url;
  String label;
  bool active;

  Link({
    required this.url,
    required this.label,
    required this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    url: json["url"],
    label: json["label"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "active": active,
  };
}