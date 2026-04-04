import 'package:chewie/chewie.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

import '../controller/recruiter_controller.dart';

class ElevatorPitchSection extends StatefulWidget {
  final String? videoUrl;
  final Map<String, String>? httpHeaders;

  const ElevatorPitchSection({super.key, this.videoUrl, this.httpHeaders});

  @override
  State<ElevatorPitchSection> createState() => _ElevatorPitchSectionState();
}

class _ElevatorPitchSectionState extends State<ElevatorPitchSection> {
  final recruiterController = Get.find<RecruiterController>();
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();

    DPrint.log("Initial Video : -> ${widget.videoUrl}");
    if (widget.videoUrl != null && widget.videoUrl!.isNotEmpty) {
      _videoController =
          VideoPlayerController.networkUrl(
              Uri.parse(widget.videoUrl!),
              formatHint: VideoFormat.hls,
              videoPlayerOptions: VideoPlayerOptions(
                mixWithOthers: true,
                allowBackgroundPlayback: false,
              ),
              httpHeaders: widget.httpHeaders ?? {},
            )
            ..initialize()
                .then((_) {
                  _chewieController = ChewieController(
                    videoPlayerController: _videoController!,
                    autoPlay: false,
                    looping: false,
                    aspectRatio: _videoController!.value.aspectRatio,

                    placeholder: Container(
                      color: Colors.black,
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
                    errorBuilder: (context, errorMessage) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 48,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Failed to load video',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              errorMessage,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                  setState(() {});
                })
                .catchError((error) {
                  // Handle init failure (e.g., network/URL invalid)
                  debugPrint('Video init error: $error'); // Log for debugging
                  if (mounted) {
                    setState(() {
                      // Show error UI instead of spinner
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to load video: $error')),
                    );
                  }
                });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: const Color(0xFF191919),
      ),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Elevator Pitch",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              IconButton(
                onPressed: () {
                  recruiterController.deleteElevatorVideo();
                },
                icon: Icon(Icons.delete, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 10),

          //This prevents overflow
          Expanded(
            child: widget.videoUrl != null && widget.videoUrl!.isNotEmpty
                ? _chewieController != null &&
                          _videoController != null &&
                          _videoController!.value.isInitialized
                      ? Chewie(controller: _chewieController!)
                      : const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                : const Text(
                    "No pitch added yet.",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white70,
                      height: 1.4,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // Widget build(BuildContext context) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(4),
  //       color: const Color(0xFF191919),
  //     ),
  //     padding: const EdgeInsets.all(16),
  //     width: double.infinity,
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Text(
  //           "Elevator Pitch",
  //           style: TextStyle(
  //             fontSize: 18,
  //             fontWeight: FontWeight.bold,
  //             color: Colors.white,
  //           ),
  //         ),
  //         const SizedBox(height: 10),
  //         if (widget.videoUrl != null && widget.videoUrl!.isNotEmpty)
  //           _chewieController != null &&
  //               _videoController != null &&
  //               _videoController!.value.isInitialized
  //               ? AspectRatio(
  //             aspectRatio: _videoController!.value.aspectRatio,
  //             child: Chewie(controller: _chewieController!),
  //           )
  //               : const Center(
  //             child: CircularProgressIndicator(
  //               color: Colors.white,
  //             ),
  //           )
  //         else
  //           const Text(
  //             "No pitch added yet.",
  //             style: TextStyle(
  //               fontSize: 15,
  //               color: Colors.white70,
  //               height: 1.4,
  //             ),
  //           ),
  //       ],
  //     ),
  //   );
  // }
}
