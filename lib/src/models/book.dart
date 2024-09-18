class ResponseBooks {
  int? total;
  String? limit;
  String? offset;
  List<Book>? data;

  ResponseBooks({this.total, this.limit, this.offset, this.data});

  ResponseBooks.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['data'] != null) {
      data = <Book>[];
      json['data'].forEach((v) {
        data!.add(new Book.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['limit'] = this.limit;
    data['offset'] = this.offset;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Book {
  int? id;
  String? title;
  int? authorId;
  int? year;
  String? genre;
  String? language;
  String? description;
  String? createdAt;
  String? updatedAt;
  Author? author;

  Book(
      {this.id,
        this.title,
        this.authorId,
        this.year,
        this.genre,
        this.language,
        this.description,
        this.createdAt,
        this.updatedAt,
        this.author});

  Book.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    authorId = json['author_id'];
    year = json['year'];
    genre = json['genre'];
    language = json['language'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    author =
    json['author'] != null ? new Author.fromJson(json['author']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['author_id'] = this.authorId;
    data['year'] = this.year;
    data['genre'] = this.genre;
    data['language'] = this.language;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.author != null) {
      data['author'] = this.author!.toJson();
    }
    return data;
  }
}

class Author {
  int? id;
  String? name;
  String? birthDate;

  Author({this.id, this.name, this.birthDate});

  Author.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    birthDate = json['birth_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['birth_date'] = this.birthDate;
    return data;
  }
}
