import 'package:flutter/material.dart';

import '../models/chapter_model.dart';
import '../services/gita_service.dart';
import 'chapter_detail_page.dart';

class ChaptersPage extends StatelessWidget {
  const ChaptersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bhagavad Gītā – 18 Chapters'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Chapter>>(
        future: GitaService.loadChapters(),
        builder: (context, snapshot) {
          // ⏳ Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ❌ Error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Unable to load chapters',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            );
          }

          final chapters = snapshot.data ?? [];

          if (chapters.isEmpty) {
            return const Center(child: Text('No chapters found'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: chapters.length,
            itemBuilder: (context, index) {
              final chapter = chapters[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 14),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  leading: CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.deepPurple,
                    child: Text(
                      chapter.id.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Center(
                    child: Text(
                      'Chapter ${chapter.id}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  subtitle: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        chapter.title,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ChapterDetailPage(chapter: chapter),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
