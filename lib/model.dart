class Truyen {
  final String id;
  String? embedding;
  final String title;
  String? description;
  int? points;
  int? views;
  String? author;
  String? type;
  String? publicdate;
  String? create;
  String? contextYear;
  String? source;
  String? imageBanner;

  Truyen(
      {required this.id,
      required this.title,
      this.embedding,
      this.description,
      this.points,
      this.views,
      this.author,
      this.type,
      this.publicdate,
      this.create,
      this.contextYear,
      this.imageBanner,
      this.source});

  factory Truyen.fromJson(Map<dynamic, dynamic> json) {
    return Truyen(
        id: json['id'],
        title: json['title'],
        author: json['author'],
        contextYear: json['context_year'],
        create: json['create'],
        description: json['description'],
        embedding: json['embedding'],
        imageBanner: json['image_banner'],
        points: json['points'],
        publicdate: '${json['publicdate']}',
        source: json['source'],
        type: json['type'],
        views: json['views']);
  }

  Map getJson() {
    Map map = {'id': id, 'title': title};

    if (embedding != null) {
      map['embedding'] = embedding;
    }

    if (description != null) {
      map['description'] = description;
    }

    if (author != null) {
      map['author'] = author;
    }

    if (type != null) {
      map['type'] = type;
    }

    if (publicdate != null && publicdate?.isNotEmpty == true) {
      map['publicdate'] = publicdate;
    }

    if (contextYear != null) {
      map['context_year'] = contextYear;
    }

    if (source != null) {
      map['source'] = source;
    }

    if (imageBanner != null) {
      map['image_banner'] = imageBanner;
    }

    return map;
  }

  Map getJsonUpdate() {
    Map map = {};

    if (embedding != null) {
      map['embedding'] = embedding;
    }

    if (description != null) {
      map['description'] = description;
    }

    if (author != null) {
      map['author'] = author;
    }

    if (type != null) {
      map['type'] = type;
    }

    if (publicdate != null) {
      map['publicdate'] = publicdate;
    }

    if (contextYear != null) {
      map['context_year'] = contextYear;
    }

    if (source != null) {
      map['source'] = source;
    }

    if (imageBanner != null) {
      map['image_banner'] = imageBanner;
    }

    return map;
  }
}

class Category {
  final String idTruyen;
  final String category;

  Category({required this.idTruyen, required this.category});
}

enum CodeCategory {
  kiem_hiep,
  truyen_ma,
}

enum CodeContenYear { TN60, TN70, TN80, TN90, HienDai, CoDai, KhongXacDinh }

enum CodeSource {
  internet_archive,
  spotify_podcast,
  youtube_playlist,
  youtube_video
}

class CategoryEmbedding {
  final String name;
  List? embedding;

  CategoryEmbedding({required this.name});
}
