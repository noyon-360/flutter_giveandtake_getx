import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giveandtake/core/common/widgets/app_scaffold.dart';
import 'package:video_player/video_player.dart';

import '../controller/recruiter_controller.dart';
import '../controller/upload_elevator_pitch.dart';

class VideoUploadScreen extends StatefulWidget {
  const VideoUploadScreen({super.key});

  @override
  State<VideoUploadScreen> createState() => _VideoUploadScreenState();
}

class _VideoUploadScreenState extends State<VideoUploadScreen> {
  final ElevatorPitchController elevatorPitchController = Get.put(
    ElevatorPitchController(),
  );

  final recruiterController = Get.find<RecruiterController>();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            Obx(() {
              final controller = elevatorPitchController;

              return GestureDetector(
                onTap: controller.isUploading.value
                    ? null
                    : controller.pickAndUploadVideo,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: const Color(0xFF191919),
                  ),
                  height: 250,
                  width: double.infinity,
                  child: controller.selectedVideoPath.value.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.image_outlined,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Drop your files here',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Choose file',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        )
                      : controller.isVideoInitialized.value
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            //  Video Player
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: AspectRatio(
                                aspectRatio: controller
                                    .videoPlayerController!
                                    .value
                                    .aspectRatio,
                                child: VideoPlayer(
                                  controller.videoPlayerController!,
                                ),
                              ),
                            ),

                            // / ⏸ Overlay
                            GestureDetector(
                              onTap: controller.togglePlayPause,
                              child: AnimatedOpacity(
                                opacity: controller.isPlaying.value ? 0.0 : 1.0,
                                duration: const Duration(milliseconds: 300),
                                child: Icon(
                                  controller.isPlaying.value
                                      ? Icons.pause_circle_filled
                                      : Icons.play_circle_fill,
                                  color: Colors.white,
                                  size: 70,
                                ),
                              ),
                            ),

                            // Bottom Control Bar
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: 0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black26,
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(6),
                                    bottomRight: Radius.circular(6),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Progress bar
                                    Obx(() {
                                      final progress =
                                          controller
                                                  .totalDuration
                                                  .value
                                                  .inMilliseconds ==
                                              0
                                          ? 0.0
                                          : controller
                                                    .currentPosition
                                                    .value
                                                    .inMilliseconds /
                                                controller
                                                    .totalDuration
                                                    .value
                                                    .inMilliseconds;
                                      return Slider(
                                        value: progress.clamp(0.0, 1.0),
                                        onChanged: (value) {
                                          final newPosition = Duration(
                                            milliseconds:
                                                (controller
                                                            .totalDuration
                                                            .value
                                                            .inMilliseconds *
                                                        value)
                                                    .toInt(),
                                          );
                                          controller.seekTo(newPosition);
                                        },
                                        activeColor: Colors.white,
                                        inactiveColor: Colors.grey,
                                      );
                                    }),

                                    // Timing and play/pause row
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            controller.formatDuration(
                                              controller.currentPosition.value,
                                            ),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            controller.isPlaying.value
                                                ? Icons.pause
                                                : Icons.play_arrow,
                                            color: Colors.white,
                                          ),
                                          onPressed: controller.togglePlayPause,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 8.0),
                                          child: Text(
                                            controller.formatDuration(
                                              controller.totalDuration.value,
                                            ),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                ),
              );
            }),

            SizedBox(height: 12),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                onPressed: recruiterController.isVideoUploading.value
                    ? null
                    : () => recruiterController.uploadVideo(
                        elevatorPitchController,
                      ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: Obx(
                  () => Text(
                    recruiterController.isVideoUploading.value
                        ? 'Uploading...'
                        : 'Upload Video',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
