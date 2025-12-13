
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:karlfive/core/common/widgets/app_scaffold.dart';
// import 'package:video_player/video_player.dart';

// import '../../../recruiter_account/presentation/controller/recruiter_controller.dart';
// import '../../../recruiter_account/presentation/controller/upload_elevator_pitch.dart';
// import '../controller/company_details_controller.dart';


// class CompanyVideoUploadScreen extends StatefulWidget {
//   // Add this flag to know if it's for company or recruiter
//   final bool isCompanyPitch;
//   const CompanyVideoUploadScreen({super.key, this.isCompanyPitch = false});

//   @override
//   State<CompanyVideoUploadScreen> createState() => _CompanyVideoUploadScreenState();
// }

// class _CompanyVideoUploadScreenState extends State<CompanyVideoUploadScreen> {
//   final ElevatorPitchController elevatorPitchController =
//       Get.put(ElevatorPitchController());
//   final RecruiterController recruiterController = Get.find<RecruiterController>();

//   // We'll use this to refresh company profile if needed
//   CompanyDetailsController? _companyController;

//   @override
//   void initState() {
//     super.initState();

//     // Only try to find CompanyDetailsController if this is for company pitch
//     if (widget.isCompanyPitch) {
//       _companyController = Get.find<CompanyDetailsController>(tag: 'company_details');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AppScaffold(
//       appBar: AppBar(
//         title: Text(widget.isCompanyPitch ? "Company Elevator Pitch" : "Your Elevator Pitch"),
//         backgroundColor: const Color(0xFF2B7FD0),
//         foregroundColor: Colors.white,
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               const SizedBox(height: 20),

//               // Video Preview / Upload Area
//               Obx(() {
//                 final controller = elevatorPitchController;

//                 return GestureDetector(
//                   onTap: controller.isUploading.value
//                       ? null
//                       : controller.pickAndUploadVideo,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       color: const Color(0xFF191919),
//                       border: Border.all(color: Colors.grey.shade700),
//                     ),
//                     height: 280,
//                     width: double.infinity,
//                     child: controller.selectedVideoPath.value.isEmpty
//                         ? _buildUploadPlaceholder()
//                         : controller.isVideoInitialized.value
//                             ? _buildVideoPlayer(controller)
//                             : const Center(
//                                 child: CircularProgressIndicator(
//                                   color: Colors.white,
//                                 ),
//                               ),
//                   ),
//                 );
//               }),

//               const SizedBox(height: 24),

//               // Upload Button
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: elevatorPitchController.selectedVideoPath.value.isEmpty ||
//                           recruiterController.isLoading.value
//                       ? null
//                       : () async {
//                           // Call upload with context of who is uploading
//                           final success = await recruiterController.uploadVideo(
//                             elevatorPitchController,
//                             isCompanyPitch: widget.isCompanyPitch,
//                           );

//                           if (success && mounted) {
//                             Get.back(); // Close upload screen

//                             // If company pitch was uploaded → refresh company profile
//                             if (widget.isCompanyPitch) {
//                               _companyController?.fetchCompanyProfile();
//                               Get.snackbar(
//                                 "Success",
//                                 "Company elevator pitch uploaded!",
//                                 backgroundColor: Colors.green,
//                                 colorText: Colors.white,
//                               );
//                             }
//                           }
//                         },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF2B7FD0),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: Obx(() => Text(
//                         recruiterController.isLoading.value
//                             ? 'Uploading... Please wait'
//                             : 'Upload Elevator Pitch',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       )),
//                 ),
//               ),

//               const SizedBox(height: 12),
//               const Text(
//                 "Tip: Record a 30–60 second video introducing your company and why candidates should join!",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(color: Colors.grey, fontSize: 13),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildUploadPlaceholder() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Image.asset(
//           'assets/icons/gallery.png',
//           height: 48,
//           width: 48,
//           color: Colors.white70,
//         ),
//         const SizedBox(height: 16),
//         const Text(
//           'Tap to record or select a video',
//           style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500),
//         ),
//         const SizedBox(height: 8),
//         const Text(
//           'Max 60 seconds • MP4 recommended',
//           style: TextStyle(color: Colors.white60, fontSize: 12),
//         ),
//       ],
//     );
//   }

//   Widget _buildVideoPlayer(ElevatorPitchController controller) {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         ClipRRect(
//           borderRadius: BorderRadius.circular(12),
//           child: AspectRatio(
//             aspectRatio: controller.videoPlayerController!.value.aspectRatio,
//             child: VideoPlayer(controller.videoPlayerController!),
//           ),
//         ),

//         // Play/Pause Overlay
//         GestureDetector(
//           onTap: controller.togglePlayPause,
//           child: AnimatedOpacity(
//             opacity: controller.isPlaying.value ? 0.0 : 1.0,
//             duration: const Duration(milliseconds: 300),
//             child: const Icon(
//               Icons.play_circle_fill,
//               color: Colors.white,
//               size: 80,
//             ),
//           ),
//         ),

//         // Bottom Controls
//         Positioned(
//           bottom: 0,
//           left: 0,
//           right: 0,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.bottomCenter,
//                 end: Alignment.topCenter,
//                 colors: [Colors.black.withOpacity(0.7), Colors.transparent],
//               ),
//             ),
//             child: Column(
//               children: [
//                 Obx(() {
//                   final progress = controller.totalDuration.value.inMilliseconds == 0
//                       ? 0.0
//                       : controller.currentPosition.value.inMilliseconds /
//                           controller.totalDuration.value.inMilliseconds;
//                   return Slider(
//                     value: progress.clamp(0.0, 1.0),
//                     onChanged: (v) {
//                       final pos = Duration(
//                         milliseconds:
//                             (controller.totalDuration.value.inMilliseconds * v).toInt(),
//                       );
//                       controller.seekTo(pos);
//                     },
//                     activeColor: Colors.white,
//                     inactiveColor: Colors.grey.shade600,
//                   );
//                 }),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         controller.formatDuration(controller.currentPosition.value),
//                         style: const TextStyle(color: Colors.white, fontSize: 12),
//                       ),
//                       Text(
//                         controller.formatDuration(controller.totalDuration.value),
//                         style: const TextStyle(color: Colors.white, fontSize: 12),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }