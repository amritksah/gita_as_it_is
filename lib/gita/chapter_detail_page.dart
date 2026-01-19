import 'package:flutter/material.dart';
import '../models/chapter_model.dart';
import '../models/verse_model.dart';
import '../utils/read_progress.dart'; // ✅ IMPORTANT
import 'verse_detail_page.dart';

class ChapterDetailPage extends StatefulWidget {
  final Chapter chapter;

  const ChapterDetailPage({
    super.key,
    required this.chapter,
  });

  @override
  State<ChapterDetailPage> createState() => _ChapterDetailPageState();
}

class _ChapterDetailPageState extends State<ChapterDetailPage> {
  /// ✅ Stores verse numbers that are fully read
  final Set<int> readVerses = {};

  @override
  void initState() {
    super.initState();
    _loadSavedProgress();
  }

  /// 🔄 Load ✔️ permanently saved verses
  Future<void> _loadSavedProgress() async {
    final saved =
        await ReadProgress.loadVerses(widget.chapter.id); // ✅ FIXED
    setState(() {
      readVerses.addAll(saved);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chapter ${widget.chapter.id}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF512DA8),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 📘 CHAPTER TITLE
            Text(
              widget.chapter.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),
            const Divider(thickness: 1),
            const SizedBox(height: 12),

            // 📖 VERSES TITLE
            const Text(
              'Verses',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // 📜 VERSES LIST
            Expanded(
              child: ListView.builder(
                itemCount: widget.chapter.verses.length,
                itemBuilder: (context, index) {
                  final Verse verse = widget.chapter.verses[index];
                  final bool isRead =
                      readVerses.contains(verse.number);

                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: isRead
                          ? const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            )
                          : const Icon(
                              Icons.menu_book,
                              color: Colors.grey,
                            ),
                      title: Center(
                        child: Text(
                          'BG ${widget.chapter.id}.${verse.number}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      ),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VerseDetailPage(
                              verses: widget.chapter.verses,
                              currentIndex: index,
                              chapterNumber: widget.chapter.id,
                              readVerses: readVerses, // ✅ SHARED SET
                            ),
                          ),
                        );

                        /// 🔁 Refresh ✔️ after returning
                        setState(() {});
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
