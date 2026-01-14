// import 'package:chewie/chewie.dart';
// import 'package:flutx_core/flutx_core.dart';
// import 'package:video_player/video_player.dart';
// import 'package:flutter/material.dart';

// class ElevatorPitchCompanySection extends StatefulWidget {
//   final String? videoUrl;
//   final Map<String, String>? httpHeaders;

//   const ElevatorPitchCompanySection({super.key, this.videoUrl, this.httpHeaders});

//   @override
//   State<ElevatorPitchCompanySection> createState() => _ElevatorPitchCompanySectionState();
// }

// class _ElevatorPitchCompanySectionState extends State<ElevatorPitchCompanySection> {
//   VideoPlayerController? _videoController;
//   ChewieController? _chewieController;



//   @override
//   void initState() {
//     super.initState();

//     DPrint.log("Initial Video : -> ${widget.videoUrl}");
//     if (widget.videoUrl != null && widget.videoUrl!.isNotEmpty) {
//       _videoController = VideoPlayerController.networkUrl(
//           Uri.parse(widget.videoUrl!),
//         formatHint: VideoFormat.hls,
//         videoPlayerOptions: VideoPlayerOptions(
//           mixWithOthers: true,
//           allowBackgroundPlayback: false,
//         ),
//           httpHeaders: widget.httpHeaders ?? {},
//       )
//         ..initialize().then((_) {
//           _chewieController = ChewieController(
//             videoPlayerController: _videoController!,
//             autoPlay: false,
//             looping: false,
//             aspectRatio: _videoController!.value.aspectRatio,

//             placeholder: Container(
//               color: Colors.black,
//               child: Center(
//                 child: CircularProgressIndicator(color: Colors.white),
//               ),
//             ),
//             errorBuilder: (context, errorMessage) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.error_outline, color: Colors.red, size: 48),
//                     SizedBox(height: 16),
//                     Text(
//                       'Failed to load video',
//                       style: TextStyle(color: Colors.white, fontSize: 16),
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       errorMessage,
//                       style: TextStyle(color: Colors.grey, fontSize: 12),
//                       textAlign: TextAlign.center,
//                     ),

//                   ],
//                 ),
//               );
//             },
//           );
//           setState(() {});
//         }).catchError((error) {
//           // Handle init failure (e.g., network/URL invalid)
//           debugPrint('Video init error: $error');  // Log for debugging
//           if (mounted) {
//             setState(() {
//               // Show error UI instead of spinner
//             });
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('Failed to load video: $error')),
//             );
//           }
//         });
//     }
//   }

//   @override
//   void dispose() {
//     _videoController?.dispose();
//     _chewieController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(4),
//         color: const Color(0xFF191919),
//       ),
//       padding: const EdgeInsets.all(16),
//       width: double.infinity,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // const Text(
//           //   "Elevator Pitch",
//           //   style: TextStyle(
//           //     fontSize: 18,
//           //     fontWeight: FontWeight.bold,
//           //     color: Colors.white,
//           //   ),
//           // ),
//           const SizedBox(height: 10),
//           if (widget.videoUrl != null && widget.videoUrl!.isNotEmpty)
//             _chewieController != null &&
//                 _videoController != null &&
//                 _videoController!.value.isInitialized
//                 ? AspectRatio(
//               aspectRatio: _videoController!.value.aspectRatio,
//               child: Chewie(controller: _chewieController!),
//             )
//                 : const Center(
//               child: CircularProgressIndicator(
//                 color: Colors.white,
//               ),
//             )
//           else
//             const Text(
//               "No pitch added yet.",
//               style: TextStyle(
//                 fontSize: 15,
//                 color: Colors.white70,
//                 height: 1.4,
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
import 'package:chewie/chewie.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ElevatorPitchCompanySection extends StatefulWidget {
  final String? videoUrl;
  final Map<String, String>? httpHeaders;

  const ElevatorPitchCompanySection({
    super.key,
    this.videoUrl,
    this.httpHeaders,
  });

  @override
  State<ElevatorPitchCompanySection> createState() =>
      _ElevatorPitchCompanySectionState();
}

class _ElevatorPitchCompanySectionState
    extends State<ElevatorPitchCompanySection> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();

    DPrint.log("Initial Video URL: ${widget.videoUrl}");

    if (widget.videoUrl != null && widget.videoUrl!.isNotEmpty) {
      _initializeVideo();
    }
  }

  Future<void> _initializeVideo() async {
    try {
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl!),
        formatHint: VideoFormat.hls,
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
          allowBackgroundPlayback: false,
        ),
        httpHeaders: widget.httpHeaders ?? {},
      );

      await _videoController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: false,
        looping: false,
        aspectRatio: _videoController!.value.aspectRatio,
        showControls: true,
        placeholder: Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
        errorBuilder: (context, errorMessage) {
          return _errorWidget(errorMessage);
        },
      );

      if (mounted) setState(() {});
    } catch (e) {
      debugPrint("Video init error: $e");
      _hasError = true;
      if (mounted) setState(() {});
    }
  }

  Widget _errorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.error_outline, color: Colors.red, size: 40),
          SizedBox(height: 12),
          Text(
            'Failed to load video',
            style: TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // No video URL
    if (widget.videoUrl == null || widget.videoUrl!.isEmpty) {
      return const Center(
        child: Text(
          "No pitch added yet.",
          style: TextStyle(
            fontSize: 15,
            color: Colors.white70,
          ),
        ),
      );
    }

    // Error state
    if (_hasError) {
      return _errorWidget("Unable to load video");
    }

    // Loading state
    if (_videoController == null ||
        _chewieController == null ||
        !_videoController!.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    // SUCCESS — Video Player
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: AspectRatio(
        aspectRatio: _videoController!.value.aspectRatio,
        child: Chewie(controller: _chewieController!),
      ),
    );
  }
}

