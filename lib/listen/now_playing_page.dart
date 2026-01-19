import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import '../main.dart';

class NowPlayingPage extends StatefulWidget {
  const NowPlayingPage({super.key});

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage> {
  bool _dragging = false;
  double _dragValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade800,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Now Playing',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder<MediaItem?>(
        stream: audioHandler.mediaItem,
        builder: (context, mediaSnap) {
          final media = mediaSnap.data;

          if (media == null) {
            return const Center(
              child: Text(
                'No Kirtan Playing',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final duration = media.duration ?? Duration.zero;
          final coverPath = media.extras?['cover'] as String?;

          return StreamBuilder<PlaybackState>(
            stream: audioHandler.playbackState,
            builder: (context, stateSnap) {
              final playing = stateSnap.data?.playing ?? false;

              return StreamBuilder<Duration>(
                stream: AudioService.position,
                builder: (context, posSnap) {
                  final position =
                      posSnap.data ?? Duration.zero;

                  final maxMs = duration.inMilliseconds > 0
                      ? duration.inMilliseconds.toDouble()
                      : 1.0;

                  final currentMs = position
                      .inMilliseconds
                      .clamp(0, maxMs.toInt())
                      .toDouble();

                  final sliderValue =
                      _dragging ? _dragValue : currentMs;

                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        // 🖼 IMAGE
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(24),
                          child: coverPath != null
                              ? Image.asset(
                                  coverPath,
                                  width: 260,
                                  height: 260,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 260,
                                  height: 260,
                                  color: Colors
                                      .blue.shade700,
                                  child: const Icon(
                                    Icons.music_note,
                                    color: Colors.white,
                                    size: 100,
                                  ),
                                ),
                        ),

                        const SizedBox(height: 28),

                        // 🎶 TITLE
                        Text(
                          media.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        if (media.artist != null)
                          Padding(
                            padding:
                                const EdgeInsets.only(
                                    top: 6),
                            child: Text(
                              media.artist!,
                              style: const TextStyle(
                                  color:
                                      Colors.white70),
                            ),
                          ),

                        const SizedBox(height: 30),

                        // 🎚 SEEK BAR
                        Slider(
                          min: 0,
                          max: maxMs,
                          value: sliderValue,
                          onChangeStart: (_) {
                            _dragging = true;
                          },
                          onChanged: (v) {
                            setState(
                                () => _dragValue = v);
                          },
                          onChangeEnd: (v) {
                            _dragging = false;
                            audioHandler.seek(
                              Duration(
                                  milliseconds:
                                      v.toInt()),
                            );
                          },
                          activeColor: Colors.white,
                          inactiveColor:
                              Colors.white54,
                        ),

                        // ⏱ TIME
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                          children: [
                            _time(position),
                            _time(duration),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // ⏮ ▶️ ⏭ CONTROLS
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            IconButton(
                              iconSize: 42,
                              color: Colors.white,
                              icon: const Icon(
                                  Icons.skip_previous),
                              onPressed:
                                  audioHandler
                                      .skipToPrevious,
                            ),
                            IconButton(
                              iconSize: 80,
                              color: Colors.white,
                              icon: Icon(
                                playing
                                    ? Icons
                                        .pause_circle_filled
                                    : Icons
                                        .play_circle_filled,
                              ),
                              onPressed: playing
                                  ? audioHandler.pause
                                  : audioHandler.play,
                            ),
                            IconButton(
                              iconSize: 42,
                              color: Colors.white,
                              icon: const Icon(
                                  Icons.skip_next),
                              onPressed:
                                  audioHandler
                                      .skipToNext,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _time(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return Text(
      '${two(d.inMinutes)}:${two(d.inSeconds % 60)}',
      style:
          const TextStyle(color: Colors.white70),
    );
  }
}