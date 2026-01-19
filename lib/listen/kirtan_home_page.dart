import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';

import '../main.dart';
import 'kirtan_data.dart';
import 'now_playing_page.dart';

class KirtanHomePage extends StatelessWidget {
  const KirtanHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kirtan 🎶'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: kirtans.length,
        itemBuilder: (context, index) {
          final k = kirtans[index];

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  k.coverImage,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                k.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(k.artist),
              trailing: const Icon(
                Icons.play_circle_fill,
                size: 36,
              ),
              onTap: () async {
                /// 🔹 Build MediaItem list ONCE
                final mediaItems = kirtans.map((e) {
                  return MediaItem(
                    id: e.assetPath, // audio path
                    title: e.title,
                    artist: e.artist,
                    artUri: Uri.parse(
                      'asset:///${e.coverImage}',
                    ),
                  );
                }).toList();

                /// 🔹 If playlist empty → set it
                if (audioHandler.queue.value.isEmpty) {
                  await audioHandler.setPlaylist(
                    mediaItems,
                    startIndex: index,
                  );
                } else {
                  /// 🔹 Just jump to selected kirtan
                  await audioHandler.skipToQueueItem(index);
                }

                await audioHandler.play();

                /// 🔹 Open Now Playing
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NowPlayingPage(),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
