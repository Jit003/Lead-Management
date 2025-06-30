import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as rxdart;
import '../services/url_helper.dart';

class ModernAudioPlayer extends StatefulWidget {
  final String label;
  final String audioPath;

  const ModernAudioPlayer({
    super.key,
    required this.label,
    required this.audioPath,
  });

  @override
  State<ModernAudioPlayer> createState() => _ModernAudioPlayerState();
}

class _ModernAudioPlayerState extends State<ModernAudioPlayer> {
  late final AudioPlayer _player;
  late final String fullUrl;

  @override
  void initState() {
    super.initState();
    fullUrl = getFullAudioUrl(widget.audioPath);
    _player = AudioPlayer();
  }



  Stream<DurationState> get _durationStateStream =>
      rxdart.Rx.combineLatest2<Duration?, Duration, DurationState>(
        _player.durationStream,
        _player.positionStream,
            (duration, position) => DurationState(
          position: position,
          total: duration ?? Duration.zero,
        ),
      );

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              StreamBuilder<PlayerState>(
                stream: _player.playerStateStream,
                builder: (context, snapshot) {
                  final state = snapshot.data;

                  final isLoading = state?.processingState == ProcessingState.loading ||
                      state?.processingState == ProcessingState.buffering;

                  final isPlaying = state?.playing ?? false;
                  final isCompleted =
                      state?.processingState == ProcessingState.completed;

                  if (isLoading) {
                    return const SizedBox(
                      height: 32,
                      width: 32,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    );
                  }

                  return IconButton(
                    icon: Icon(
                      isCompleted
                          ? Icons.replay
                          : (isPlaying ? Icons.pause : Icons.play_arrow),
                      color: Colors.orange,
                    ),
                    onPressed: () async {
                      final isPlaying = _player.playing;
                      final isCompleted = _player.playerState.processingState == ProcessingState.completed;

                      if (_player.audioSource == null) {
                        // Lazy-load only when audio is not yet set
                        try {
                          await _player.setUrl(fullUrl);
                        } catch (e) {
                          Get.snackbar("Audio Error", "Failed to load audio.");
                          return;
                        }
                      }

                      if (isCompleted) {
                        await _player.seek(Duration.zero);
                        await _player.play();
                      } else {
                        isPlaying ? await _player.pause() : await _player.play();
                      }
                    },
                  );
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: StreamBuilder<DurationState>(
                  stream: _durationStateStream,
                  builder: (context, snapshot) {
                    final durationState = snapshot.data;
                    final position = durationState?.position ?? Duration.zero;
                    final total = durationState?.total ?? Duration.zero;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Slider(
                          min: 0,
                          max: total.inMilliseconds.toDouble(),
                          value: position.inMilliseconds
                              .clamp(0, total.inMilliseconds)
                              .toDouble(),
                          onChanged: (value) {
                            _player.seek(Duration(milliseconds: value.toInt()));
                          },
                          activeColor: Colors.orange,
                          inactiveColor: Colors.orange.shade100,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_formatDuration(position),
                                style: const TextStyle(fontSize: 12)),
                            Text(_formatDuration(total),
                                style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}

class DurationState {
  final Duration position;
  final Duration total;

  DurationState({required this.position, required this.total});
}
