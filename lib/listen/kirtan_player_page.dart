import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import '../main.dart';
import 'kirtan_model.dart';

class KirtanPlayerPage extends StatelessWidget {
  final Kirtan kirtan;

  const KirtanPlayerPage({super.key, required this.kirtan});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem,
      builder: (context, mediaSnapshot) {
        final media = mediaSnapshot.data;

        return StreamBuilder<PlaybackState>(
          stream: audioHandler.playbackState,
          builder: (context, stateSnapshot) {
            final state = stateSnapshot.data;
            final playing = state?.playing ?? false;
            final position = state?.updatePosition ?? Duration.zero;
            final duration = media?.duration ?? Duration.zero;

            return Scaffold(
              appBar: AppBar(
                title: Text('${kirtan.title} 🎶'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.repeat_one),
                    tooltip: 'Loop',
                    onPressed: () {
                      audioHandler.enableLoop();
                    },
                  ),
                ],
              ),
              body: Container(
                padding: const EdgeInsets.all(24),
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFFF3E0),
                      Color(0xFFFFE0B2)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 🖼 COVER IMAGE
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        kirtan.coverImage,
                        width: 220,
                        height: 220,
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 🎶 TITLE
                    Text(
                      kirtan.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      kirtan.artist,
                      style:
                          const TextStyle(color: Colors.black54),
                    ),

                    const SizedBox(height: 32),

                    // 🎚 SEEK BAR (SYNCED)
                    Slider(
                      min: 0,
                      max: duration.inMilliseconds > 0
                          ? duration.inMilliseconds.toDouble()
                          : 1,
                      value: position.inMilliseconds
                          .clamp(0, duration.inMilliseconds)
                          .toDouble(),
                      onChanged: (v) {
                        audioHandler.seek(
                          Duration(milliseconds: v.toInt()),
                        );
                      },
                    ),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        _time(position),
                        _time(duration),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // ▶️ PLAY / PAUSE
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.deepOrange,
                      child: IconButton(
                        iconSize: 42,
                        color: Colors.white,
                        icon: Icon(
                          playing
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                        onPressed: () {
                          playing
                              ? audioHandler.pause()
                              : audioHandler.play();
                        },
                      ),
                    ),

                    const SizedBox(height: 36),

                    const Text(
                      'हरे कृष्ण हरे कृष्ण\n'
                      'कृष्ण कृष्ण हरे हरे\n'
                      'हरे राम हरे राम\n'
                      'राम राम हरे हरे',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _time(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return Text(
      '${two(d.inMinutes)}:${two(d.inSeconds % 60)}',
    );
  }
}
