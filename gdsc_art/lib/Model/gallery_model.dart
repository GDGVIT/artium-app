class GalleryModel {
  final String id;
  final String title;
  int likes;
  final String imageUrl;
  final String description;
  final ArtistModel artist;

  GalleryModel({
    required this.id,
    required this.title,
    required this.likes,
    required this.imageUrl,
    required this.description,
    required this.artist,
  });

  factory GalleryModel.fromJson(Map<String, dynamic> json) {
    return GalleryModel(
      id: json['_id'],
      title: json['title'],
      likes: json['likes'],
      imageUrl: json['image'],
      description: json['description'],
      artist: ArtistModel.fromJson(json['artist']),
    );
  }
}

class ArtistModel {
  final String id;
  final String name;

  ArtistModel({required this.id, required this.name});

  factory ArtistModel.fromJson(Map<String, dynamic> json) {
    return ArtistModel(
      id: json['_id'],
      name: json['name'],
    );
  }
}
