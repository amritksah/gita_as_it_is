import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';

import '../main.dart';
import 'kirtan_data.dart';
import 'now_playing_page.dart';

class KirtanPlaylistPage extends StatelessWidget {
  const KirtanPlaylistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kirtan Playlist 🎶'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: kirtans.length,
        itemBuilder: (context, index) {
          final k = kirtans[index];

          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                k.coverImage,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(k.title),
            subtitle: Text(k.artist),
            trailing: const Icon(Icons.play_arrow),
            onTap: () async {
              // 🎵 BUILD MEDIA ITEMS
              final mediaItems = kirtans.map((e) {
                return MediaItem(
                    id: e.assetPath,
                    title: e.title,
                    artist: e.artist,
                    extras: {
                        'cover': e.coverImage, // ✅ STORE ASSET PATH HERE
                    },
                    );
              }).toList();

              // ▶️ SET PLAYLIST & START FROM TAPPED INDEX
              await audioHandler.setPlaylist(
                mediaItems,
                startIndex: index,
              );

              // 🔁 LOOP (Mahamantra use-case)
              await audioHandler.enableLoop();

              // 📱 OPEN NOW PLAYING
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NowPlayingPage(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
