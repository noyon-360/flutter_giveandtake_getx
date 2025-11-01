import 'dart:io';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class ElevatorPitchController extends GetxController{

// final Repo recruiterRepo;
// final AuthStorageService authStorageService;
//
// ElevatorPitchController(this.authStorageService, this.recruiterRepo);

  final picker = ImagePicker();

  var isUploading = false.obs;
  var selectedVideoPath = ''.obs;
  var isVideoInitialized = false.obs;
  var isPlaying = false.obs;
  var currentPosition = Duration.zero.obs;
  var totalDuration = Duration.zero.obs;

  VideoPlayerController? videoPlayerController;

  Future<void> pickAndUploadVideo() async {
    try {
      final source = await Get.bottomSheet<ImageSource>(
        Container(
          color: const Color(0xFFFFFFFF),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.video_library),
                title: const Text('Pick from Gallery'),
                onTap: () => Get.back(result: ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.videocam),
                title: const Text('Record New Video'),
                onTap: () => Get.back(result: ImageSource.camera),
              ),
            ],
          ),
        ),
      );

      if (source == null) return;

      final XFile? video = await picker.pickVideo(
        source: source,
        maxDuration: const Duration(seconds: 60),
      );

      if (video == null) return;

      selectedVideoPath.value = video.path;
      isVideoInitialized.value = false;

      videoPlayerController?.dispose();

      videoPlayerController = VideoPlayerController.file(File(video.path))
        ..initialize().then((_) {
          isVideoInitialized.value = true;
          totalDuration.value = videoPlayerController!.value.duration;

          videoPlayerController!.setLooping(false);
          videoPlayerController!.play();
          isPlaying.value = true;

          //  Listen for position and video end
          videoPlayerController!.addListener(() {
            final position = videoPlayerController!.value.position;
            currentPosition.value = position;

            // Check if video finished
            if (position >= videoPlayerController!.value.duration &&
                !videoPlayerController!.value.isPlaying) {
              isPlaying.value = false;
            }
          });
        });
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }

  void togglePlayPause() {
    if (videoPlayerController == null) return;

    if (videoPlayerController!.value.isPlaying) {
      videoPlayerController!.pause();
      isPlaying.value = false;
    } else {
      // If the video is finished, replay from start
      if (currentPosition.value >=
          videoPlayerController!.value.duration) {
        videoPlayerController!.seekTo(Duration.zero);
      }
      videoPlayerController!.play();
      isPlaying.value = true;
    }
  }

  void seekTo(Duration position) {
    videoPlayerController?.seekTo(position);
  }

  String formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void onClose() {
    videoPlayerController?.dispose();
    super.onClose();
  }
}
