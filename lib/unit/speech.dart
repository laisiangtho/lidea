import 'package:flutter_tts/flutter_tts.dart';
// https://github.com/dlutton/flutter_tts
// https://github.com/ryanheise/audio_service
// http://translate.google.com/translate_tts?ie=utf-8&tl=en&q=Hello%20World.'

class UnitSpeech {
  late final FlutterTts api = FlutterTts();
  Future<void> init() async {
    await setLanguage();
  }

  Future<dynamic> speak(String text) async {
    // await setLanguage('en-UK');

    // await api.setVoice({"name": "Karen", "locale": "en-GB"});
    await api.speak(text);
  }

  Future<void> speakWith(String? text, {String? language}) async {
    await setLanguage(language: language);
    // await api.setSpeechRate(0.42);
    // await api.setVolume(0.5);
    // await api.setPitch(0.87);
    await api.setSpeechRate(0.4);
    await api.setVolume(1.0);
    await api.setPitch(0.9);

    await api.awaitSpeakCompletion(true);
    await api.awaitSynthCompletion(true);
    await speak(text ?? '');
  }

  Future<dynamic> setLanguage({String? language = 'en-GB'}) async {
    await api.setLanguage(language ?? 'en-GB');
  }

  Future<dynamic> get getLanguages => api.getLanguages;
  Future<dynamic> get getEngines => api.getEngines;
}
