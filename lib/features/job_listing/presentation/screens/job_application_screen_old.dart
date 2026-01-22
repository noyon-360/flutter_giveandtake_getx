// import 'dart:io';

// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:giveandtake/core/network/constants/key_constants.dart';
// import 'package:giveandtake/core/network/services/secure_store_services.dart';
// import 'package:giveandtake/core/theme/app_colors.dart';
// import 'package:giveandtake/features/job_listing/data/models/job_application_request.dart';
// import 'package:giveandtake/features/job_listing/data/models/user_profile_model.dart';
// import 'package:giveandtake/features/job_listing/domain/usecases/get_user_profile_usecase.dart';
// import 'package:giveandtake/features/job_listing/domain/usecases/submit_job_application_usecase.dart';
// import 'package:giveandtake/features/plan_pricing/presentation/screens/plan_pricing_screen.dart';
// import 'package:path_provider/path_provider.dart';

// class JobApplicationScreen extends StatefulWidget {
//   final Map<String, dynamic> jobData;

//   const JobApplicationScreen({super.key, required this.jobData});

//   @override
//   State<JobApplicationScreen> createState() => _JobApplicationScreenState();
// }

// class _JobApplicationScreenState extends State<JobApplicationScreen> {
//   String visaOption = 'Yes';
//   final TextEditingController pitchController = TextEditingController();
//   final TextEditingController elevatorPitchController = TextEditingController();
//   PlatformFile? selectedResume;
//   bool agreeToShareCV = true;

//   UserProfileModel? userProfile;
//   bool isLoadingProfile = true;
//   bool isSubmittingApplication = false;
//   late final GetUserProfileUseCase _getUserProfileUseCase;
//   late final SubmitJobApplicationUseCase _submitJobApplicationUseCase;



//   @override
//   void initState() {
//     super.initState();
//     _getUserProfileUseCase = Get.find<GetUserProfileUseCase>();
//     _submitJobApplicationUseCase = Get.find<SubmitJobApplicationUseCase>();
//     _fetchUserProfile();
//   }

//   Future<void> _fetchUserProfile() async {
//     setState(() => isLoadingProfile = true);

//     try {
//       final result = await _getUserProfileUseCase.call();
      
//       result.fold(
//         (failure) {
//           setState(() => isLoadingProfile = false);
//           Get.snackbar(
//             'Warning',
//             'Could not load user profile data: ${failure.message}',
//             snackPosition: SnackPosition.BOTTOM,
//             backgroundColor: Colors.orange,
//             colorText: Colors.white,
//           );
//         },
//         (success) {
//           setState(() {
//             userProfile = success.data;
//             isLoadingProfile = false;
//           });
//         },
//       );
//     } catch (e) {
//       setState(() => isLoadingProfile = false);
//       Get.snackbar(
//         'Warning',
//         'Could not load user profile data',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.orange,
//         colorText: Colors.white,
//       );
//     }
//   }

//   Future<void> _pickResume() async {
//     final result = await FilePicker.platform.pickFiles(
//       withData: false,
//       allowMultiple: false,
//       type: FileType.custom,
//       allowedExtensions: ['pdf', 'doc', 'docx'],
//     );

//     if (result != null && result.files.isNotEmpty) {
//       setState(() {
//         selectedResume = result.files.first;
//       });
//     }
//   }

//   void _removeResume() {
//     setState(() {
//       selectedResume = null;
//     });
//   }

//   Future<void> _downloadFile(PlatformFile file) async {
//     try {
//       // Check if the file has a path
//       if (file.path == null) {
//         Get.snackbar(
//           'Error',
//           'File path not available',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//         return;
//       }

//       // Get the app's directory (no permission needed)
//       Directory? directory;
//       if (Platform.isAndroid) {
//         // Use app's external storage directory (accessible without permissions)
//         directory = await getExternalStorageDirectory();
//       } else if (Platform.isIOS) {
//         // For iOS, use the app's documents directory
//         directory = await getApplicationDocumentsDirectory();
//       }

//       if (directory == null) {
//         Get.snackbar(
//           'Error',
//           'Could not access storage directory',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//         return;
//       }

//       // Create a Documents folder in the app directory
//       final documentsPath = '${directory.path}/Documents';
//       final documentsDir = Directory(documentsPath);
//       if (!await documentsDir.exists()) {
//         await documentsDir.create(recursive: true);
//       }

//       // Create the destination path
//       final String newPath = '$documentsPath/${file.name}';
      
//       // Copy the file
//       final File sourceFile = File(file.path!);
//       await sourceFile.copy(newPath);

//       Get.snackbar(
//         'Success',
//         'File saved to app Documents folder: ${file.name}',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//         duration: const Duration(seconds: 3),
//       );
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to download file: $e',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   Future<void> _submit() async {
//     if (selectedResume == null) {
//       Get.snackbar(
//         'Error',
//         'Please upload a resume before submitting',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return;
//     }

//     setState(() => isSubmittingApplication = true);

//     try {
//       // Get userId from secure storage
//       final secureStore = SecureStoreServices();
//       final userId = await secureStore.retrieveData(KeyConstants.userId);
      
//       if (userId == null || userId.isEmpty) {
//         Get.snackbar(
//           'Error',
//           'User ID not found. Please login again.',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//         setState(() => isSubmittingApplication = false);
//         return;
//       }

//       final jobId = widget.jobData['_id'] ?? widget.jobData['id'] ?? '';
      
//       // Using placeholder resumeId
//       final resumeId = selectedResume?.name ?? 'temp-resume-id';
      
//       final request = JobApplicationRequest(
//         jobId: jobId,
//         userId: userId,
//         resumeId: resumeId,
//         status: 'pending',
//       );

//       final result = await _submitJobApplicationUseCase.call(request);

//       result.fold(
//         (failure) {
//           Get.snackbar(
//             'Error',
//             failure.message,
//             snackPosition: SnackPosition.BOTTOM,
//             backgroundColor: Colors.red,
//             colorText: Colors.white,
//           );
//         },
//         (success) {
//           Get.snackbar(
//             'Success',
//             'Application submitted successfully!',
//             snackPosition: SnackPosition.BOTTOM,
//             backgroundColor: Colors.green,
//             colorText: Colors.white,
//           );
          
//           // Navigate to success screen or plan pricing
//           Get.to(() => PlanPricingScreen());
//         },
//       );
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to submit application: $e',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       setState(() => isSubmittingApplication = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: AppColors.textBlack),
//           onPressed: () => Get.back(),
//         ),
//         title: const Text(
//           'Job application page',
//           style: TextStyle(color: AppColors.textBlack),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // User Profile Section
//             Center(
//               child: Column(
//                 children: [
//                   // Profile Image
//                   isLoadingProfile
//                       ? const CircleAvatar(
//                           radius: 50,
//                           backgroundColor: Colors.grey,
//                           child: CircularProgressIndicator(
//                             color: Colors.white,
//                             strokeWidth: 2,
//                           ),
//                         )
//                       : CircleAvatar(
//                           radius: 50,
//                           backgroundColor: Colors.grey[300],
//                           backgroundImage: (userProfile?.avatarUrl != null && 
//                                   userProfile!.avatarUrl!.isNotEmpty)
//                               ? NetworkImage(userProfile!.avatarUrl!)
//                               : null,
//                           child: (userProfile?.avatarUrl == null || 
//                                   userProfile!.avatarUrl!.isEmpty)
//                               ? Icon(
//                                   Icons.person, 
//                                   size: 60,
//                                   color: Colors.grey[600],
//                                 )
//                               : null,
//                         ),
//                   const SizedBox(height: 16),
//                   // User Name
//                   Text(
//                     isLoadingProfile
//                         ? 'Loading...'
//                         : userProfile?.name ?? 'User Name',
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   // User Title/Role - Show title first, then role as fallback
//                   Text(
//                     isLoadingProfile
//                         ? 'Loading...'
//                         : (userProfile?.title != null && userProfile!.title!.isNotEmpty)
//                             ? userProfile!.title!
//                             : (userProfile?.role != null && userProfile!.role.isNotEmpty)
//                                 ? userProfile!.role
//                                 : 'Role not specified',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       color: Colors.black54,
//                     ),
//                   ),

//                 ],
//               ),
//             ),
            
//             const SizedBox(height: 32),

//             // Contact Information
//             Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Location',
//                         style: TextStyle(fontWeight: FontWeight.w600),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         isLoadingProfile
//                             ? 'Loading...'
//                             : (userProfile?.address != null && userProfile!.address.isNotEmpty
//                                 ? userProfile!.address 
//                                 : 'Location not provided'),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Email',
//                         style: TextStyle(fontWeight: FontWeight.w600),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         isLoadingProfile
//                             ? 'Loading...'
//                             : (userProfile?.email != null && userProfile!.email.isNotEmpty
//                                 ? userProfile!.email 
//                                 : 'Email not provided'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             Divider(color: Colors.grey.shade300),
//             const Text(
//               "Custom Questions",
//               style: TextStyle(fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 20),
            
//             // Elevator Pitch URL
//             const Text(
//               'Elevator Pitch URL',
//               style: TextStyle(fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 8),
//             TextField(
//               controller: elevatorPitchController,
//               decoration: InputDecoration(
//                 hintText: 'Enter Your Profile Url',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),
//             const Text(
//               'What is your expected salary? *',
//               style: TextStyle(fontWeight: FontWeight.w400),
//             ),
//             const SizedBox(height: 8),
//             TextField(
//               controller: pitchController,
//               decoration: InputDecoration(
//                 hintText: 'Enter Your answer here',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),
//             const Text(
//               'Resume',
//               style: TextStyle(fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'Choose Your Updated Resume',
//               style: TextStyle(fontSize: 14, color: Colors.black54),
//             ),
//             const SizedBox(height: 12),

//             // Resume Section - Single Resume Upload
//             if (selectedResume != null)
//               Container(
//                 margin: const EdgeInsets.symmetric(vertical: 8),
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey.shade300),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 48,
//                       height: 48,
//                       decoration: BoxDecoration(
//                         color: Colors.red.shade700,
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                       alignment: Alignment.center,
//                       child: const Text(
//                         'PDF',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             selectedResume!.name,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             '${(selectedResume!.size / (1024 * 1024)).toStringAsFixed(2)} MB',
//                             style: const TextStyle(color: Colors.black54),
//                           ),
//                         ],
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () => _downloadFile(selectedResume!),
//                       icon: const Icon(Icons.download_outlined),
//                     ),
//                     const SizedBox(width: 8),
//                     IconButton(
//                       onPressed: _removeResume,
//                       icon: const Icon(Icons.delete, color: Colors.red),
//                     ),
//                   ],
//                 ),
//               ),
            
//             const SizedBox(height: 12),
//             ElevatedButton(
//               onPressed: _pickResume,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.white,
//                 foregroundColor: AppColors.primaryBlue,
//                 side: BorderSide(color: AppColors.primaryBlue),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: const Text('Upload Resume'),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'DOC, PDF (5MB)',
//               style: TextStyle(fontSize: 12, color: Colors.black54),
//             ),

//             const SizedBox(height: 20),
//             Row(
//               children: [
//                 Checkbox(
//                   value: agreeToShareCV,
//                   onChanged: (v) {
//                     setState(() {
//                       agreeToShareCV = v ?? true;
//                     });
//                   },
//                 ),
//                 const SizedBox(width: 2),
//                 const Expanded(
//                   child: Text('I agree to share my EVP for this role'),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 12),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: isSubmittingApplication ? null : _submit,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primaryBlue,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   child: isSubmittingApplication
//                       ? const Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             SizedBox(
//                               width: 20,
//                               height: 20,
//                               child: CircularProgressIndicator(
//                                 color: Colors.white,
//                                 strokeWidth: 2,
//                               ),
//                             ),
//                             SizedBox(width: 12),
//                             Text(
//                               'Submitting...',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                           ],
//                         )
//                       : const Text(
//                           'Submit',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 40),
//           ],
//         ),
//       ),
//     );
//   }
// }
