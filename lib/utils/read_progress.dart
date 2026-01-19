import 'package:shared_preferences/shared_preferences.dart';

class ReadProgress {
  static String _key(int chapter) => 'read_chapter_$chapter';

  /// 💾 Save ONE verse as read
  static Future<void> saveVerse(int chapter, int verse) async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> stored =
        prefs.getStringList(_key(chapter)) ?? [];

    if (!stored.contains(verse.toString())) {
      stored.add(verse.toString());
      await prefs.setStringList(_key(chapter), stored);
    }
  }

  /// 📥 Load all read verses of a chapter
  static Future<Set<int>> loadVerses(int chapter) async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> stored =
        prefs.getStringList(_key(chapter)) ?? [];

    return stored.map(int.parse).toSet();
  }
}
