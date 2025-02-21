class HistoryModel {
  final String src;
  final Artist artist;
  final Art art;
  final String id;

  HistoryModel({
    required this.src,
    required this.artist,
    required this.art,
    required this.id,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      src: json['src'],
      artist: Artist.fromJson(json['artist']),
      art: Art.fromJson(json['art']),
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'src': src,
      'artist': artist.toJson(),
      'art': art.toJson(),
      '_id': id,
    };
  }
}

class Artist {
  final String name;
  final String period;

  Artist({
    required this.name,
    required this.period,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      name: json['name'],
      period: json['period'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'period': period,
    };
  }
}

class Art {
  final String year;

  Art({
    required this.year,
  });

  factory Art.fromJson(Map<String, dynamic> json) {
    return Art(
      year: json['year'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'year': year,
    };
  }
}