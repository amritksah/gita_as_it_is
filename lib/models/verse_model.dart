class Verse {
  final int number;
  final String sanskrit;
  final String transliteration;
  final String wordMeanings;

  // English
  final String translation;
  final String purport;

  // Hindi (nullable)
  final String? translationHi;
  final String? purportHi;

  Verse({
    required this.number,
    required this.sanskrit,
    required this.transliteration,
    required this.wordMeanings,
    required this.translation,
    required this.purport,
    this.translationHi,
    this.purportHi,
  });

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      number: json['number'],
      sanskrit: json['sanskrit'],
      transliteration: json['transliteration'],
      wordMeanings: json['word_meanings'],

      translation: json['translation'],
      purport: json['purport'],

      // Hindi fields (safe)
      translationHi: json['translation_hi'],
      purportHi: json['purport_hi'],
    );
  }
}
