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
  // final List<MediaItem> queue;
  final int? index;
  final String? id;
  final bool queued;
  final bool playing;

  const AudioMediaStateType({
    // this.queue,
    this.index,
    this.id,
    this.queued = false,
    this.playing = false,
  });
}

class AudioPositionType {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  AudioPositionType(this.position, this.bufferedPosition, this.duration);
}
