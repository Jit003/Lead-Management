
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class VoiceRecorderController extends GetxController {
  final FlutterSoundRecorder recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer player = FlutterSoundPlayer();

  final RxBool isRecording = false.obs;
  final RxBool isPlaying = false.obs;

  String? recordedFilePath;
  bool _isRecorderInitialized = false;
  bool _isPlayerInitialized = false;

  @override
  void onInit() async {
    super.onInit();
    await init();
  }

  Future<void> init() async {
    try {
      await _requestPermissions();
      await _initRecorder();
      await _initPlayer();
    } catch (e) {
      print("Initialization error: $e");
      Get.snackbar("Error", "Failed to initialize recorder/player");
    }
  }

  Future<void> _requestPermissions() async {
    var statuses = await [
      Permission.microphone,
      Permission.storage,
      Permission.mediaLibrary,
    ].request();

    if (!statuses[Permission.microphone]!.isGranted ||
        !statuses[Permission.storage]!.isGranted) {
      print("Microphone and storage permission required");
      await [Permission.microphone, Permission.storage].request();
    }
  }

  Future<void> _initRecorder() async {
    try {
      await recorder.openRecorder();
      _isRecorderInitialized = true;
    } catch (e) {
      print("Recorder initialization error: $e");
    }
  }

  Future<void> _initPlayer() async {
    try {
      await player.openPlayer();
      _isPlayerInitialized = true;
    } catch (e) {
      print("Player initialization error: $e");
    }
  }

  Future<void> startRecording() async {
    if (!_isRecorderInitialized) {
      await _initRecorder();
    }
    if (await recorder.isRecording) return; 

    final dir = await getTemporaryDirectory();
    recordedFilePath = "${dir.path}/recorded_voice_${DateTime.now().millisecondsSinceEpoch}.aac";

    try {
      await recorder.startRecorder(
        toFile: recordedFilePath,
        codec: Codec.aacADTS,
      );
      isRecording.value = true;
    } catch (e) {
      print("Recording error: $e");
      Get.snackbar("Error", "Failed to start recording");
    }
  }

  Future<void> stopRecording() async {
    if (!await recorder.isRecording) return; 
    try {
      await recorder.stopRecorder();
      isRecording.value = false;
      print("Recording saved: $recordedFilePath");
    } catch (e) {
      print("Stop recording error: $e");
    }
  }

  Future<void> playRecording() async {
    if (recordedFilePath == null || !File(recordedFilePath!).existsSync()) {
      Get.snackbar("Error", "No recording found");
      return;
    }

    if (!_isPlayerInitialized) {
      await _initPlayer();
    }
    if (await player.isPlaying) {
      await stopPlaying();
      return;
    }

    try {
      await player.startPlayer(
        fromURI: recordedFilePath!,
        codec: Codec.aacADTS,
        whenFinished: () {
          isPlaying.value = false;
        },
      );
      isPlaying.value = true;
    } catch (e) {
      print("Playback error: $e");
      Get.snackbar("Error", "Failed to play recording");
    }
  }

  Future<void> stopPlaying() async {
    if (await player.isPlaying) {
      try {
        await player.stopPlayer();
        isPlaying.value = false;
      } catch (e) {
        print("Stop playback error: $e");
      }
    }
  }

  @override
  void onClose() {
    recorder.closeRecorder();
    player.closePlayer();
    super.onClose();
  }
}