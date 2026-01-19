import 'package:shared_preferences/shared_preferences.dart';

class FavoritesManager {
  static const String _key = 'favorite_verses';

  /// ➕ Add verse
  static Future<void> add(String verseKey) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> favorites = prefs.getStringList(_key) ?? [];

    if (!favorites.contains(verseKey)) {
      favorites.add(verseKey);
      await prefs.setStringList(_key, favorites);
    }
  }

  /// ❌ Remove verse
  static Future<void> remove(String verseKey) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> favorites = prefs.getStringList(_key) ?? [];

    favorites.remove(verseKey);
    await prefs.setStringList(_key, favorites);
  }

  /// 📥 Load all favorites
  static Future<List<String>> load() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  /// ❤️ Check if favorite
  static Future<bool> isFavorite(String verseKey) async {
    final favorites = await load();
    return favorites.contains(verseKey);
  }
}
