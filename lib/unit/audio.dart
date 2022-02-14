import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
// import 'package:rxdart/rxdart.dart';

abstract class UnitAudio {
  late AudioSession session;

  final void Function() notify;
  final AudioPlayer player = AudioPlayer();
  final ConcatenatingAudioSource queue = ConcatenatingAudioSource(children: []);

  UnitAudio({required this.notify});

  // int queueIndex = -1;
  bool _queueEditMode = false;
  bool get queueEditMode => _queueEditMode;
  set queueEditMode(bool value) => notifyIf<bool>(_queueEditMode, _queueEditMode = value);
  int get queueCount => player.sequence?.length ?? 0;

  // NOTE: overridable
  Future<void> init() async {
    session = await AudioSession.instance;
    // await session.configure(AudioSessionConfiguration.speech());
    await player.setShuffleModeEnabled(false);
    await player.setLoopMode(LoopMode.all);
    // await queueRefresh();
    // player.playbackEventStream.listen((e) {
    //   print('playbackEventStream');
    // }, onError: (Object e, StackTrace stackTrace) {
    //   // debugPrint('A stream error occurred: $e');
    // });
    // currentIndexChange
    player.sequenceStream.listen((e) {
      playerNotify();
    });

    // player.processingStateStream.listen((e) {
    //   print('player.processingStateStream ${e.index}');
    // });

    // player.durationStream.listen((e) {
    //   print('??? player.durationStream $e');
    // });

    player.currentIndexStream.listen((e) {
      playerNotify(currentIndexChange: true);
    });

    player.playerStateStream.listen((e) {
      playerNotify();
    });
  }

  /// NOTE: overridable
  /// currentIndexChange is true when queue index is shifting
  void playerNotify({bool currentIndexChange = false}) {
    notify();
  }

  void notifyIf<T>(T element, T value) {
    if (value != element) {
      notify();
    }
  }

  // NOTE: Update Queue
  Future<void> queueRefresh({bool preload: false, bool force: false}) async {
    if (force || player.playerState.playing == false) {
      await player.setAudioSource(queue, preload: preload).catchError((e) {
        // print('setAudioSource $e');
      });
    }
  }

  // NOTE: overridable remove
  Future<void> queueRemoveAtIndex(int index) async {
    await queue.removeAt(index);
    await queueRefresh();
  }

  // NOTE: play
  Future<void> queuePlayAtIndex(int index) async {
    await player.seek(Duration.zero, index: index).then((_) => player.play());
  }

  // NOTE: play
  Future<void> playOrPause() async {
    // player.seek(Duration.zero, index: player.effectiveIndices!.first).then()
    if (queue.length == 0) {
      await player.stop();
    } else if (player.playerState.playing != true) {
      await player.play();
    } else {
      await player.pause();
    }
  }

  // NOTE: pause
  // Future<void> pauses() async{
  //   await player.pause();
  // }
}
