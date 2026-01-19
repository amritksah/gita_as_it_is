import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

import '../models/chapter_model.dart';

class GitaService {
  static Future<List<Chapter>> loadChapters() async {
    try {
      debugPrint('📦 Loading gita_data.json...');

      final jsonString =
          await rootBundle.loadString('assets/data/gita_data.json');

      debugPrint('✅ JSON loaded successfully');
      debugPrint(jsonString);

      final data = json.decode(jsonString);

      final chaptersJson = data['chapters'] as List;

      debugPrint('📖 Chapters count: ${chaptersJson.length}');

      return chaptersJson
          .map((e) => Chapter.fromJson(e))
          .toList();
    } catch (e, stack) {
      debugPrint('❌ ERROR LOADING JSON: $e');
      debugPrint(stack.toString());
      rethrow;
    }
  }
}
