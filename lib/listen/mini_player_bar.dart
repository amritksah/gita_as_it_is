import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import '../main.dart';
import 'now_playing_page.dart';

class MiniPlayerBar extends StatefulWidget {
  const MiniPlayerBar({super.key});

  @override
  State<MiniPlayerBar> createState() => _MiniPlayerBarState();
}

class _MiniPlayerBarState extends State<MiniPlayerBar> {
  double _dragValue = 0;
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem,
      builder: (context, mediaSnap) {
        final media = mediaSnap.data;
        if (media == null) return const SizedBox.shrink();

        final coverPath = media.extras?['cover'] as String?;

        return StreamBuilder<PlaybackState>(
          stream: audioHandler.playbackState,
          builder: (context, stateSnap) {
            final playing = stateSnap.data?.playing ?? false;

            return StreamBuilder<Duration>(
              stream: AudioService.position,
              builder: (context, posSnap) {
                final position = posSnap.data ?? Duration.zero;
                final duration = media.duration ?? Duration.zero;

                final maxMs = duration.inMilliseconds > 0
                    ? duration.inMilliseconds.toDouble()
                    : 1.0;

                final currentMs = position.inMilliseconds
                    .clamp(0, maxMs.toInt())
                    .toDouble();

                final sliderValue =
                    _dragging ? _dragValue : currentMs;

                return Material(
                  color: Colors.blue,
                  elevation: 12,
                  child: SizedBox(
                    height: 88,
                    child: Column(
                      children: [
                        // 🔊 SEEK BAR
                        Slider(
                          min: 0,
                          max: maxMs,
                          value: sliderValue,
                          onChangeStart: (_) {
                            _dragging = true;
                          },
                          onChanged: (v) {
                            setState(() => _dragValue = v);
                          },
                          onChangeEnd: (v) {
                            _dragging = false;
                            audioHandler.seek(
                              Duration(milliseconds: v.toInt()),
                            );
                          },
                          activeColor: Colors.white,
                          inactiveColor: Colors.white54,
                        ),

                        // 🎵 CONTENT ROW
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const NowPlayingPage(),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8),
                              child: Row(
                                children: [
                                  // 🖼 COVER
                                  ClipOval(
                                    child: coverPath != null
                                        ? Image.asset(
                                            coverPath,
                                            width: 42,
                                            height: 42,
                                            fit: BoxFit.cover,
                                          )
                                        : const Icon(
                                            Icons.music_note,
                                            color: Colors.white,
                                            size: 32,
                                          ),
                                  ),
                                  const SizedBox(width: 10),

                                  // 🎶 TITLE
                                  Expanded(
                                    child: Text(
                                      media.title,
                                      maxLines: 1,
                                      overflow:
                                          TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  // ⏮
                                  IconButton(
                                    icon: const Icon(
                                      Icons.skip_previous,
                                      color: Colors.white,
                                    ),
                                    onPressed:
                                        audioHandler.skipToPrevious,
                                  ),

                                  // ▶️ / ⏸
                                  IconButton(
                                    icon: Icon(
                                      playing
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      color: Colors.white,
                                    ),
                                    onPressed: playing
                                        ? audioHandler.pause
                                        : audioHandler.play,
                                  ),

                                  // ⏭
                                  IconButton(
                                    icon: const Icon(
                                      Icons.skip_next,
                                      color: Colors.white,
                                    ),
                                    onPressed:
                                        audioHandler.skipToNext,
                                  ),
                                ],
                              ),
                            ),
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
      },
    );
  }
}