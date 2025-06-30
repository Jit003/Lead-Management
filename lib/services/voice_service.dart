import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';

final FlutterTts flutterTts = FlutterTts();
final player = AudioPlayer();


Future<void> speak(String audio) async {
  flutterTts.setLanguage('en');
  flutterTts.setPitch(1);
  flutterTts.speak(audio);
}
Future<void> playLocalVoice(String relativePath) async {
  String fullPath = '/$relativePath';
  await player.play(DeviceFileSource(fullPath));
}
