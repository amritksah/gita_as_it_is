import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import '../main.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem,
      builder: (context, snapshot) {
        final item = snapshot.data;
        if (item == null) return const SizedBox();

        return Container(
          height: 64,
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade900,
            boxShadow: const [BoxShadow(blurRadius: 4)],
          ),
          child: Row(
            children: [
              const SizedBox(width: 12),
              const Icon(Icons.music_note, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              StreamBuilder<bool>(
                stream: audioHandler.playbackState
                    .map((s) => s.playing)
                    .distinct(),
                builder: (context, snap) {
                  final playing = snap.data ?? false;
                  return IconButton(
                    icon: Icon(
                      playing ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      playing
                          ? audioHandler.pause()
                          : audioHandler.play();
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
