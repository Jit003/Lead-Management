
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:record/record.dart'; // Add this for audio recording
import '../../controller/voice_record_controller.dart';
import '../../constant/app_color.dart';

class VoiceRecorderWidget extends StatelessWidget {
  final VoiceRecorderController controller = Get.put(VoiceRecorderController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Color(0xFFE5E5E5), width: 1),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (controller.isRecording.value) {
                        await controller.stopRecording();
                      } else {
                        await controller.startRecording();
                      }
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: controller.isRecording.value
                            ? const Color(0xFFFF4444)
                            : AppColor.btnColor,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: (controller.isRecording.value
                                    ? const Color(0xFFFF4444)
                                    : const Color(0xFF1A1A1A))
                                .withOpacity(0.2),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        controller.isRecording.value
                            ? Icons.stop_rounded
                            : Icons.mic_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.isRecording.value
                              ? 'Recording in progress...'
                              : 'Tap to start voice recording',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: controller.isRecording.value
                                ? const Color(0xFFFF4444)
                                : const Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          controller.isRecording.value
                              ? 'Tap button to stop recording'
                              : 'Record lead details for better accuracy',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Play button after recording
              if (!controller.isRecording.value &&
                  controller.recordedFilePath != null &&
                  controller.recordedFilePath!.isNotEmpty)
                ElevatedButton.icon(
                  onPressed: () async => await controller.playRecording(),
                  icon: Icon(controller.isPlaying.value
                      ? Icons.stop
                      : Icons.play_arrow),
                  label: Text(controller.isPlaying.value
                      ? "Stop Playing"
                      : "Listen Recording"),
                )
            ],
          ),
        ));
  }
}