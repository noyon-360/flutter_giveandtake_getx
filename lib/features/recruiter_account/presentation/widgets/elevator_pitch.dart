import 'package:chewie/chewie.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

import '../controller/recruiter_controller.dart';
import '../screens/video_upload_screen.dart';

class ElevatorPitchSection extends StatefulWidget {
  final String? videoUrl;
  final Map<String, String>? httpHeaders;
  final bool isOwnProfile;
  final VoidCallback? onDelete;
  final VoidCallback? onUpload;

  const ElevatorPitchSection({
    super.key,
    this.videoUrl,
    this.httpHeaders,
    this.isOwnProfile = false,
    this.onDelete,
    this.onUpload,
  });

  @override
  State<ElevatorPitchSection> createState() => _ElevatorPitchSectionState();
}

class _ElevatorPitchSectionState extends State<ElevatorPitchSection> {
  final recruiterController = Get.find<RecruiterController>();
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _isInitialized = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  @override
  void didUpdateWidget(covariant ElevatorPitchSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.videoUrl != oldWidget.videoUrl) {
      DPrint.log(
        "Video URL changed: ${oldWidget.videoUrl} -> ${widget.videoUrl}",
      );
      _disposeControllers();
      _initializeVideo();
    }
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    _chewieController?.dispose();
    _videoController?.dispose();
    _chewieController = null;
    _videoController = null;
    _isInitialized = false;
    _errorMessage = null;
  }

  int _retryCount = 0;
  final int _maxRetries = 5;

  void _initializeVideo() {
    DPrint.log(
      "Initializing Video (Attempt ${_retryCount + 1}): -> ${widget.videoUrl}",
    );
    _errorMessage = null;
    _isInitialized = false;

    if (widget.videoUrl != null &&
        widget.videoUrl!.isNotEmpty &&
        !widget.videoUrl!.endsWith('/')) {
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
                  if (!mounted) return;
                  DPrint.log("Video initialized successfully!");
                  _retryCount = 0; // Reset on success
                  _isInitialized = true;
                  _chewieController = ChewieController(
                    videoPlayerController: _videoController!,
                    autoPlay: false,
                    looping: false,
                    aspectRatio: _videoController!.value.aspectRatio,
                    placeholder: Container(
                      color: Colors.black,
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
                    errorBuilder: (context, errorMessage) {
                      return _buildErrorWidget(errorMessage);
                    },
                  );
                  setState(() {});
                })
                .catchError((error) {
                  debugPrint('Video init error: $error');
                  if (!mounted) return;

                  // Auto-retry if initialization fails (often 404 during backend processing)
                  if (_retryCount < _maxRetries) {
                    _retryCount++;
                    setState(() {
                      _errorMessage =
                          "Video is processing, please wait... (Attempt $_retryCount/$_maxRetries)";
                    });
                    DPrint.log(
                      "Retrying video initialization in 1 second... ($_retryCount/$_maxRetries)",
                    );
                    Future.delayed(const Duration(microseconds: 500), () {
                      if (mounted) {
                        _disposeControllers();
                        _initializeVideo();
                      }
                    });
                  } else {
                    setState(() {
                      _errorMessage =
                          "Failed to load video after multiple attempts. It might still be processing.";
                    });
                  }
                });
    }
  }

  Widget _buildErrorWidget(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.info_outline, color: Colors.white70, size: 40),
          const SizedBox(height: 8),
          const Text(
            'Video is processing or failed to load',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              _disposeControllers();
              _initializeVideo();
              setState(() {});
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white12,
              foregroundColor: Colors.white,
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: const Color(0xFF191919),
      ),
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
              if (widget.isOwnProfile &&
                  widget.videoUrl != null &&
                  widget.videoUrl!.isNotEmpty &&
                  !widget.videoUrl!.endsWith('/'))
                Obx(
                  () => IconButton(
                    onPressed: recruiterController.isVideoUploading.value
                        ? null
                        : () async {
                            await recruiterController.deleteElevatorVideo();
                            widget.onDelete?.call();
                          },
                    icon: Icon(
                      Icons.delete,
                      color: recruiterController.isVideoUploading.value
                          ? Colors.grey
                          : Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          widget.videoUrl != null &&
                  widget.videoUrl!.isNotEmpty &&
                  !widget.videoUrl!.endsWith('/')
              ? Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _errorMessage != null
                        ? _buildErrorWidget(_errorMessage!)
                        : _chewieController != null && _isInitialized
                        ? Chewie(controller: _chewieController!)
                        : const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                  ),
                )
              : widget.isOwnProfile
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "No pitch added yet.",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white70,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await Get.to(() => const VideoUploadScreen());
                          widget.onUpload?.call();
                        },
                        icon: const Icon(Icons.upload, color: Colors.white),
                        label: const Text(
                          "Upload New Video",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2B7FD0),
                        ),
                      ),
                    ],
                  ),
                )
              : const Text(
                  "No pitch added yet.",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
        ],
      ),
    );
  }
}
