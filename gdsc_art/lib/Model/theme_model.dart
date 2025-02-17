class ThemeModel {
  final String id;
  final String title;
  final String slug;
  final List<String> themeImages;
  final String description;
  final String infoLink;
  final String workTitle;
  final List<String> workImages;
  final String workDescription;

  ThemeModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.themeImages,
    required this.description,
    required this.infoLink,
    required this.workTitle,
    required this.workImages,
    required this.workDescription,
  });

  factory ThemeModel.fromJson(Map<String, dynamic> json) {
    return ThemeModel(
      id: json['_id'],
      title: json['theme_title'],
      slug: json['slug'],
      themeImages: List<String>.from(json['theme_images']),
      description: json['theme_description'],
      infoLink: json['info_link'],
      workTitle: json['work_title'],
      workImages: List<String>.from(json['work_images']),
      workDescription: json['work_description'],
    );
  }
}