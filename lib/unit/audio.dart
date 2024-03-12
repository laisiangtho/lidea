import 'package:flutter/services.dart';

import 'package:rxdart/rxdart.dart';

import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';
// import 'package:audio_session/audio_session.dart';

import 'package:lidea/main.dart';

/// The implementation of AudioPlayerHandler.
///
/// This handler is backed by a just_audio player. The player's effective
/// sequence is mapped onto the handler's queue, and the player's state is
/// mapped onto the handler's state.
abstract class UnitAudio extends BaseAudioHandler with SeekHandler {
  final DataNest data;

  final _player = AudioPlayer();
  final _playlist = ConcatenatingAudioSource(children: []);
  final BehaviorSubject<List<MediaItem>> _recentSubject = BehaviorSubject.seeded([]);
  final expandoMediaItem = Expando<MediaItem>();

  final BehaviorSubject<String> message = BehaviorSubject.seeded('');

  void dispose() {
    message.close();
  }

  // positionDataStream
  Stream<AudioPositionType> get streamPositionData {
    return Rx.combineLatest3<Duration, Duration, Duration, AudioPositionType>(
      AudioService.position,
      playbackState.map((e) => e.bufferedPosition).distinct(),
      mediaItem.map((e) => e?.duration ?? Duration.zero).distinct(),
      (position, buffered, duration) => AudioPositionType(
        position: position,
        buffered: buffered,
        duration: duration,
      ),
    );
  }

  /// A stream reporting the combined state of the current queue and the current media item within that queue.
  Stream<AudioQueueStateType> get streamQueueState {
    return Rx.combineLatest3<List<MediaItem>, PlaybackState, List<int>, AudioQueueStateType>(
      queue,
      playbackState,
      _player.shuffleIndicesStream.whereType<List<int>>(),
      (queue, state, shuffleIndices) => AudioQueueStateType(
        queue,
        state.queueIndex,
        state.shuffleMode == AudioServiceShuffleMode.all ? shuffleIndices : null,
        state.repeatMode,
      ),
    ).where((state) {
      return state.shuffleIndices == null || state.queue.length == state.shuffleIndices!.length;
    });
  }

  /// A stream reporting the combined state of the current queue and the current media item within that queue.
  Stream<AudioMediaStateType> streamMediaState(String sid) {
    return Rx.combineLatest3<List<MediaItem>, PlaybackState, int?, AudioMediaStateType>(
      queue,
      playbackState,
      _player.currentIndexStream,
      (queue, state, index) {
        final queued = queue.indexWhere((e) => e.id == sid) >= 0;
        final id = (index != null && index < queue.length) ? queue[index].id : null;
        final playing = (id != null && id == sid) ? state.playing : false;
        return AudioMediaStateType(
          index: state.queueIndex,
          id: id,
          queued: queued,
          playing: playing,
        );
      },
    );
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    final enabled = shuffleMode == AudioServiceShuffleMode.all;
    if (enabled) {
      await _player.shuffle();
    }
    playbackState.add(playbackState.value.copyWith(shuffleMode: shuffleMode));
    await _player.setShuffleModeEnabled(enabled);
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    playbackState.add(playbackState.value.copyWith(repeatMode: repeatMode));
    await _player.setLoopMode(LoopMode.values[repeatMode.index]);
  }

  @override
  Future<void> setSpeed(double speed) async {
    await _player.setSpeed(speed);
  }

  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume);
  }

  void setMessage(String value) {
    message.value = value;
  }

  @override
  Future<List<MediaItem>> getChildren(String parentMediaId, [Map<String, dynamic>? options]) async {
    switch (parentMediaId) {
      case AudioService.recentRootId:
        // When the user resumes a media session, tell the system what the most
        // recently played item was.
        return _recentSubject.value;
      default:
        // Allow client to browse the media library.
        // return _mediaList.items[parentMediaId]!;
        return queue.value;
    }
  }

  @override
  ValueStream<Map<String, dynamic>> subscribeToChildren(String parentMediaId) {
    switch (parentMediaId) {
      case AudioService.recentRootId:
        final stream = _recentSubject.map((_) => <String, dynamic>{});
        return _recentSubject.hasValue
            ? stream.shareValueSeeded(<String, dynamic>{})
            : stream.shareValue();
      default:
        // return Stream.value(_mediaList.items[parentMediaId])
        //     .map((_) => <String, dynamic>{})
        //     .shareValue();
        return Stream.value(queue.value).map((_) => <String, dynamic>{}).shareValue();
    }
  }

  /// Add to Playlist then play if not playing,
  /// if playing then paused
  @override
  Future<void> addQueueItem(MediaItem item) async {
    final index = queue.value.indexWhere((e) => e.id == item.id);
    if (index == -1) {
      await _playlist.add(await generateAudioSourceItem(item));
      if (_player.playing == false) {
        // await skipToQueueItem(0);
        await skipToNext();
      }
    } else {
      if (index == playbackState.value.queueIndex) {
        if (_player.playing) {
          await pause();
        } else {
          await play();
        }
      } else {
        await skipToQueueItem(index);
      }
    }
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    await _playlist.addAll(await generateAudioSourceList(mediaItems));
  }

  @override
  Future<void> insertQueueItem(int index, MediaItem mediaItem) async {
    await _playlist.insert(index, await generateAudioSourceItem(mediaItem));
  }

  @override
  Future<void> updateQueue(List<MediaItem> queue) async {
    await _playlist.clear();
    await _playlist.addAll(await generateAudioSourceList(queue));
  }

  @override
  Future<void> updateMediaItem(MediaItem mediaItem) async {
    final index = queue.value.indexWhere((e) => e.id == mediaItem.id);
    expandoMediaItem[_player.sequence![index]] = mediaItem;
  }

  @override
  Future<void> removeQueueItem(MediaItem mediaItem) async {
    final index = queue.value.indexOf(mediaItem);
    await _playlist.removeAt(index);
  }

  Future<void> moveQueueItem(int currentIndex, int newIndex) async {
    await _playlist.move(currentIndex, newIndex);
  }

  @override
  Future<void> skipToNext() async {
    await _player.seekToNext();
    _playIfNotPlay();
  }

  @override
  Future<void> skipToPrevious() async {
    await _player.seekToPrevious();
    _playIfNotPlay();
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index < 0 || index >= _playlist.children.length) return;
    // This jumps to the beginning of the queue item at [index].
    await _player.seek(
      Duration.zero,
      index: _player.shuffleModeEnabled ? _player.shuffleIndices![index] : index,
    );
    _playIfNotPlay();
  }

  Future<void> skipToQueueItemId(String mediaId) async {
    if (mediaId.isEmpty || _playlist.children.isEmpty) return;
    final index = queue.value.indexWhere((item) => item.id == mediaId);
    if (index < 0) return;
    await _player.seek(Duration.zero, index: index);
    _playIfNotPlay();
  }

  @override
  Future<void> play() {
    return _player.play();
  }

  @override
  Future<void> pause() {
    return _player.pause();
  }

  @override
  Future<void> seek(Duration position) {
    return _player.seek(position);
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    await playbackState.firstWhere((state) => state.processingState == AudioProcessingState.idle);
  }

  UnitAudio({required this.data}) {
    prepareInitialized();
  }

  Future<void> prepareInitialized() async {
    // final session = await AudioSession.instance;
    // await session.configure(const AudioSessionConfiguration.speech());

    // await _player.setShuffleModeEnabled(false);
    // await _player.setLoopMode(LoopMode.all);
    await setRepeatMode(AudioServiceRepeatMode.all);
    await setShuffleMode(AudioServiceShuffleMode.none);

    // Broadcast speed changes. Debounce so that we don't flood the notification with updates.
    _player.speedStream.debounceTime(const Duration(milliseconds: 250)).listen((speed) {
      playbackState.add(playbackState.value.copyWith(speed: speed));
    });

    // Load and broadcast the initial queue
    // await updateQueue(_mediaList.items[MediaLibrary.albumsRootId]!);

    // Load the playlist.
    // _playlist.addAll(queue.value.map(await generateAudioSourceItem).toList());

    // For Android 11, record the most recent item so it can be resumed.
    mediaItem.whereType<MediaItem>().listen((item) {
      return _recentSubject.add([item]);
    });

    // Broadcast media item changes.
    Rx.combineLatest4<int?, List<MediaItem>, bool, List<int>?, MediaItem?>(
        _player.currentIndexStream,
        queue,
        _player.shuffleModeEnabledStream,
        _player.shuffleIndicesStream, (index, queue, shuffleModeEnabled, shuffleIndices) {
      final queueIndex = getQueueIndex(index, shuffleModeEnabled, shuffleIndices);
      return (queueIndex != null && queueIndex < queue.length) ? queue[queueIndex] : null;
    }).whereType<MediaItem>().distinct().listen(mediaItem.add);

    _player.shuffleModeEnabledStream.listen((enabled) {
      return _broadcastState(_player.playbackEvent);
    });

    // Broadcast the current queue.
    _effectiveSequence.map((sequence) {
      return sequence.map((source) {
        return expandoMediaItem[source]!;
      }).toList();
    }).pipe(queue);

    // In this example, the service stops when reaching the end.
    _player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        stop();
        _player.seek(Duration.zero, index: 0);
      }
    }).onError(setMessageOnException);

    // Broadcast media item changes.
    // _player.currentIndexStream.listen((index) {
    //   // if (index != null) mediaItem.add(queue.value[index]);
    //   if (index != null) print('??? currentIndexStream $index');
    // });

    // Propagate all events from the audio player to AudioService clients.
    _player.playbackEventStream.listen(_broadcastState).onError(setMessageOnException);

    await _setIfNotSet();
  }

  // Handle Exception and notify to UI
  Future<void> setMessageOnException(dynamic e) async {
    await stop();
    if (e is PlayerException) {
      // Source error: No internet, No audio
      setMessage(e.message ?? 'No Internet');
    } else if (e is PlayerInterruptedException) {
      // Loading interrupted: playlist empty, no playlist
      setMessage(e.message ?? 'Audio interrupted');
    } else if (e is PlatformException) {
      setMessage(e.message ?? 'Platform exception');
    } else {
      if (_playlist.length > 0) {
        setMessage('Unknown error');
      } else {
        // SocketException
        setMessage('No Internet');
      }
    }
  }

  /// Computes the effective queue index taking shuffle mode into account.
  int? getQueueIndex(int? currentIndex, bool shuffleModeEnabled, List<int>? shuffleIndices) {
    final effectiveIndices = _player.effectiveIndices ?? [];
    final shuffleIndicesInv = List.filled(effectiveIndices.length, 0);
    for (var i = 0; i < effectiveIndices.length; i++) {
      shuffleIndicesInv[effectiveIndices[i]] = i;
    }
    return (shuffleModeEnabled && ((currentIndex ?? 0) < shuffleIndicesInv.length))
        ? shuffleIndicesInv[currentIndex ?? 0]
        : currentIndex;
  }

  /// Broadcasts the current state to all clients.
  void _broadcastState(PlaybackEvent event) {
    final playing = _player.playing;
    final queueIndex =
        getQueueIndex(event.currentIndex, _player.shuffleModeEnabled, _player.shuffleIndices);
    playbackState.add(playbackState.value.copyWith(
      controls: [
        MediaControl.skipToPrevious,
        if (playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: queueIndex,
    ));
  }

  /// A stream of the current effective sequence from just_audio.
  Stream<List<IndexedAudioSource>> get _effectiveSequence {
    return Rx.combineLatest3<List<IndexedAudioSource>?, List<int>?, bool,
            List<IndexedAudioSource>?>(
        _player.sequenceStream, _player.shuffleIndicesStream, _player.shuffleModeEnabledStream,
        (sequence, shuffleIndices, shuffleModeEnabled) {
      if (sequence == null) return [];
      if (!shuffleModeEnabled) return sequence;
      if (shuffleIndices == null) return null;
      if (shuffleIndices.length != sequence.length) return null;
      return shuffleIndices.map((i) => sequence[i]).toList();
    }).whereType<List<IndexedAudioSource>>();
  }

  /// overridable: Transform MediaItem to AudioSource
  ///
  Future<AudioSource> generateAudioSourceItem(MediaItem item) async {
    final src = AudioSource.uri(Uri.parse(item.id));
    expandoMediaItem[src] = item;
    return src;
  }

  /// no need to override: Transform list of MediaItem to AudioSource
  /// using generateAudioSourceItem
  ///
  Future<List<AudioSource>> generateAudioSourceList(List<MediaItem> items) async {
    // return await items.map(generateAudioSourceItem).toList();
    return Stream.fromIterable(items).asyncMap(generateAudioSourceItem).toList();
  }

  Future<void> _playIfNotPlay() async {
    await _setIfNotSet();
    if (!_player.playing) {
      await play();
    }
  }

  Future<void> _setIfNotSet() async {
    try {
      if (_player.audioSource == null && _playlist.length > 0) {
        // setMessage('Loading');
        await _player.setAudioSource(_playlist).catchError((e) {
          setMessageOnException(e);
          return null;
        });
      }
    } catch (e) {
      setMessage('?');
    }
  }
}
