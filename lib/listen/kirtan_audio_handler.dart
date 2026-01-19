import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class KirtanAudioHandler extends BaseAudioHandler
    with QueueHandler, SeekHandler {
  final AudioPlayer _player = AudioPlayer();

  /// ✅ REQUIRED: queueIndex stream (NOT provided by BaseAudioHandler)
  final BehaviorSubject<int?> _queueIndex =
      BehaviorSubject<int?>.seeded(0);

  Stream<int?> get queueIndexStream => _queueIndex.stream;

  KirtanAudioHandler() {
    /// 🔁 Playback state updates
    _player.playbackEventStream.listen((event) {
      playbackState.add(
        playbackState.value.copyWith(
          playing: _player.playing,
          controls: [
            MediaControl.skipToPrevious,
            _player.playing
                ? MediaControl.pause
                : MediaControl.play,
            MediaControl.skipToNext,
          ],
          processingState:
              _mapProcessingState(_player.processingState),
          updatePosition: _player.position,
          bufferedPosition: _player.bufferedPosition,
          speed: _player.speed,
        ),
      );
    });

    /// 🎵 Current index + MediaItem sync
    _player.currentIndexStream.listen((index) {
      if (index == null ||
          index < 0 ||
          index >= queue.value.length) return;

      _queueIndex.add(index);

      final item = queue.value[index];
      mediaItem.add(
        item.copyWith(duration: _player.duration),
      );
    });

    /// ⏱ Duration update
    _player.durationStream.listen((duration) {
      final item = mediaItem.value;
      if (item == null || duration == null) return;

      mediaItem.add(item.copyWith(duration: duration));
    });

    /// ▶️ Auto next on completion
    _player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        skipToNext();
      }
    });
  }

  /// 📜 PLAYLIST
  Future<void> setPlaylist(
    List<MediaItem> items, {
    int startIndex = 0,
  }) async {
    queue.add(items);
    _queueIndex.add(startIndex);

    await _player.setAudioSource(
      ConcatenatingAudioSource(
        children:
            items.map((e) => AudioSource.asset(e.id)).toList(),
      ),
      initialIndex: startIndex,
    );

    play();
  }

  /// ▶️ CONTROLS
  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) =>
      _player.seek(position);

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index < 0 || index >= queue.value.length) return;
    await _player.seek(Duration.zero, index: index);
    play();
  }

  @override
  Future<void> skipToNext() async {
    if (_player.hasNext) {
      await _player.seekToNext();
      play();
    }
  }

  @override
  Future<void> skipToPrevious() async {
    if (_player.hasPrevious) {
      await _player.seekToPrevious();
      play();
    }
  }

  /// 🔁 LOOP
  Future<void> enableLoop() async {
    await _player.setLoopMode(LoopMode.one);
  }

  /// 🧹 CLEANUP (NO super.dispose ❌)
  Future<void> disposeHandler() async {
    await _player.dispose();
    await _queueIndex.close();
  }

  /// 🔄 STATE MAP
  AudioProcessingState _mapProcessingState(
      ProcessingState state) {
    switch (state) {
      case ProcessingState.idle:
        return AudioProcessingState.idle;
      case ProcessingState.loading:
        return AudioProcessingState.loading;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
    }
  }
}
