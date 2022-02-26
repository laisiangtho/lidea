part of 'main.dart';

/// An [AudioHandler] for playing a list of podcast episodes.
/// This class exposes the interface and not the implementation.
abstract class AudioHandlerType implements AudioHandler {
  ValueStream<String> get message;
  void setMessage(String value);
  ValueStream<double> get speed;
  // Future<void> setSpeed(double volume);
  ValueStream<double> get volume;
  Future<void> setVolume(double volume);
  Future<void> moveQueueItem(int currentIndex, int newIndex);
  Stream<AudioPositionType> get positionDataStream;
  Stream<Duration> get bufferedPositionStream;
  Stream<Duration?> get durationStream;
  Stream<AudioQueueStateType> get queueState;
  Stream<AudioMediaStateType> mediaState(String trackId);
}

class AudioQueueStateType {
  static const AudioQueueStateType empty =
      AudioQueueStateType([], null, [], AudioServiceRepeatMode.none);

  final List<MediaItem> queue;
  final int? queueIndex;
  final List<int>? shuffleIndices;
  final AudioServiceRepeatMode repeatMode;

  const AudioQueueStateType(this.queue, this.queueIndex, this.shuffleIndices, this.repeatMode);

  bool get hasPrevious {
    return repeatMode != AudioServiceRepeatMode.none || (queueIndex ?? 0) > 0;
  }

  bool get hasNext {
    return repeatMode != AudioServiceRepeatMode.none || (queueIndex ?? 0) + 1 < queue.length;
  }

  List<int> get indices {
    return shuffleIndices ?? List.generate(queue.length, (i) => i);
  }
}

// To be used in other list
class AudioMediaStateType {
  final dynamic id;
  final int? index;
  final bool queued;
  final bool playing;
  // final double caching;
  // final bool cached;
  final AudioCacheType cache;
  // final bool cached;

  const AudioMediaStateType({
    // this.queue,
    this.id,
    this.index,
    this.queued = false,
    this.playing = false,
    // this.caching = 0.0,
    // this.cached = false,
    this.cache = const AudioCacheType(),
    // this.cached = false,
  });
}

class AudioCacheType {
  final int id;
  final double caching;
  final bool progress;

  const AudioCacheType({
    this.id = 0,
    this.caching = 0.0,
    this.progress = false,
  });

  AudioCacheType copyWith({
    int? id,
    double? caching,
    bool? progress,
  }) {
    return AudioCacheType(
      id: id ?? this.id,
      caching: caching ?? this.caching,
      progress: progress ?? this.progress,
    );
  }
}

class AudioPositionType {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  AudioPositionType(this.position, this.bufferedPosition, this.duration);
}
