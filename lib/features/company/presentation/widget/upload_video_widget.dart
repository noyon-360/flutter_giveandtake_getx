// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:karlfive/core/theme/app_colors.dart';
// import 'package:video_player/video_player.dart';

// class VideoUploadCardWidget extends StatefulWidget {
//   final String title;
//   final String subtitle;
//   final String buttonText;
//   final String fileType;

//   const VideoUploadCardWidget({
//     super.key,
//     required this.title,
//     required this.subtitle,
//     required this.buttonText,
//     required this.fileType,
//   });

//   @override
//   State<VideoUploadCardWidget> createState() => _VideoUploadCardWidgetState();
// }

// class _VideoUploadCardWidgetState extends State<VideoUploadCardWidget> {
//   VideoPlayerController? _controller;
//   bool _isVideoUploaded = false;
//   final ImagePicker _picker = ImagePicker();
//   File? _videoFile;

//   Future<void> _pickVideo() async {
//     final XFile? pickedFile =
//         await _picker.pickVideo(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       _videoFile = File(pickedFile.path);

//       _controller?.dispose();
//       _controller = VideoPlayerController.file(_videoFile!)
//         ..initialize().then((_) {
//           setState(() {
//             _isVideoUploaded = true;
//           });
//         });
//     }
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         border: Border.all(color: AppColors.textGrey),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Title
//           Text(
//             widget.title,
//             style: const TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           if (widget.subtitle.isNotEmpty) ...[
//             const SizedBox(height: 4),
//             Text(
//               widget.subtitle,
//               style: const TextStyle(color: Colors.grey, fontSize: 13),
//             ),
//             const SizedBox(height: 12),
//           ],
//           // Video Container
//           GestureDetector(
//             onTap: _pickVideo,
//             child: Container(
//               height: 197,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey.shade400),
//                 borderRadius: BorderRadius.circular(8),
//                 color: Colors.black,
//               ),
//               child: _isVideoUploaded && _controller != null && _controller!.value.isInitialized
//                   ? AspectRatio(
//                       aspectRatio: _controller!.value.aspectRatio,
//                       child: VideoPlayer(_controller!),
//                     )
//                   : Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Icon(
//                             Icons.videocam,
//                             size: 40,
//                             color: Colors.white,
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             widget.fileType,
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 13,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//             ),
//           ),
//           const SizedBox(height: 12),
//           // Centered Upload Button
//           Center(
//             child: SizedBox(
//               height: 40,
//               width: 140,
//               child: ElevatedButton(
//                 onPressed: _pickVideo,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primaryBlue,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   padding: EdgeInsets.zero,
//                 ),
//                 child: Text(
//                   widget.buttonText,
//                   style: const TextStyle(
//                     color: AppColors.primaryWhite,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:karlfive/core/theme/app_colors.dart';
import 'package:video_player/video_player.dart';

class VideoUploadCardWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final String fileType;

  /// ADD THIS
  final VoidCallback? onTap;

  const VideoUploadCardWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.fileType,
    this.onTap, // ADD THIS
  });

  @override
  State<VideoUploadCardWidget> createState() => _VideoUploadCardWidgetState();
}

class _VideoUploadCardWidgetState extends State<VideoUploadCardWidget> {
  VideoPlayerController? _controller;
  bool _isVideoUploaded = false;
  final ImagePicker _picker = ImagePicker();
  File? _videoFile;

  Future<void> _pickVideo() async {
    final XFile? pickedFile =
        await _picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      _videoFile = File(pickedFile.path);

      _controller?.dispose();
      _controller = VideoPlayerController.file(_videoFile!)
        ..initialize().then((_) {
          setState(() {
            _isVideoUploaded = true;
          });
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _handleTap() {
    // if navigation callback exists → use that
    if (widget.onTap != null) {
      widget.onTap!();
      return;
    }
    // else pick video directly
    _pickVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.textGrey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (widget.subtitle.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              widget.subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 12),
          ],

          // ▼▼▼ VIDEO CONTAINER — ACTS AS A BUTTON ▼▼▼
          GestureDetector(
            onTap: _handleTap,
            child: Container(
              height: 197,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
                color: Colors.black,
              ),
              child: _isVideoUploaded &&
                      _controller != null &&
                      _controller!.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: VideoPlayer(_controller!),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.videocam,
                            size: 40,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.fileType,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 12),

          // ▼▼ Upload Button ▼▼
          Center(
            child: SizedBox(
              height: 40,
              width: 140,
              child: ElevatedButton(
                onPressed: _handleTap, // USE SAME TAP
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: Text(
                  widget.buttonText,
                  style: const TextStyle(
                    color: AppColors.primaryWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
