import 'verse_model.dart';

class Chapter {
  final int id;
  final String title;
  final List<Verse> verses;

  Chapter({
    required this.id,
    required this.title,
    required this.verses,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'],
      title: json['title'] ?? '',
      verses: (json['verses'] as List)
          .map((v) => Verse.fromJson(v))
          .toList(),
    );
  }
}
