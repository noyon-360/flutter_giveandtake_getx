import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/theme/app_colors.dart';
import 'package:karlfive/features/job_listing/data/models/user_profile_model.dart';
import 'package:karlfive/features/job_listing/domain/usecases/get_user_profile_usecase.dart';
import 'package:karlfive/features/plan_pricing/presentation/screens/plan_pricing_screen.dart';

class JobApplicationScreen extends StatefulWidget {
  final Map<String, dynamic> jobData;

  const JobApplicationScreen({super.key, required this.jobData});

  @override
  State<JobApplicationScreen> createState() => _JobApplicationScreenState();
}

class _JobApplicationScreenState extends State<JobApplicationScreen> {
  String visaOption = 'Yes';
  final TextEditingController pitchController = TextEditingController();
  final RxList<PlatformFile> resumes = <PlatformFile>[].obs;
  int? primaryIndex;

  UserProfileModel? userProfile;
  bool isLoadingProfile = true;
  late final GetUserProfileUseCase _getUserProfileUseCase;

  @override
  void initState() {
    super.initState();
    _getUserProfileUseCase = Get.find<GetUserProfileUseCase>();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    setState(() => isLoadingProfile = true);

    try {
      final result = await _getUserProfileUseCase.call();

      result.fold(
        (failure) {
          print('Error fetching user profile: $failure');
          setState(() => isLoadingProfile = false);
          Get.snackbar(
            'Error',
            'Failed to fetch user profile',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        (success) {
          print('✅ User profile loaded successfully: ${success.data.name}');

          setState(() {
            userProfile = success.data;
            isLoadingProfile = false;
          });
        },
      );
    } catch (e) {
      print('Exception in _fetchUserProfile: $e');
      setState(() => isLoadingProfile = false);
      Get.snackbar(
        'Error',
        'Failed to load user data',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _pickResume() async {
    final result = await FilePicker.platform.pickFiles(
      withData: false,
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      resumes.addAll(result.files);
      if (primaryIndex == null && resumes.isNotEmpty) {
        primaryIndex = 0;
      }
      setState(() {});
    }
  }

  void _removeResume(int index) {
    resumes.removeAt(index);
    if (primaryIndex != null) {
      if (resumes.isEmpty)
        primaryIndex = null;
      else if (index == primaryIndex)
        primaryIndex = 0;
      else if (index < primaryIndex!)
        primaryIndex = primaryIndex! - 1;
    }
    setState(() {});
  }

  void _selectPrimary(int index) {
    primaryIndex = index;
    setState(() {});
  }

  void _downloadFile(PlatformFile file) {
    // For now show snackbar (real download requires backend or file url)
    Get.snackbar('Download', 'Would download: ${file.name}');
  }

  void _submit() {
    final data = {
      'jobId': widget.jobData['id'] ?? widget.jobData['raw']?['_id'],
      'visaRequired': visaOption,
      'elevatorPitchUrl': pitchController.text,
      'resumes': resumes.map((r) => r.name).toList(),
      'primaryResume': primaryIndex != null
          ? resumes[primaryIndex!].name
          : null,
    };

    // TODO: call API to submit application. For now show snackbar
    Get.snackbar(
      'Submitted',
      'Application data collected',
      snackPosition: SnackPosition.BOTTOM,
    );
    debugPrint('Application submitted: $data');
    Get.to(() => PlanPricingScreen());//TODO: Replace with actual success screen
  }

  @override
  Widget build(BuildContext context) {
    final raw = widget.jobData['raw'] ?? widget.jobData;
    final bool isCompanyJob = raw['companyId'] != null;
    final String company = isCompanyJob
        ? raw['companyId']['cname'] ?? ''
        : (raw['recruiterId'] != null
              ? '${raw['recruiterId']['firstName'] ?? ''} ${raw['recruiterId']['sureName'] ?? ''}'
              : widget.jobData['company'] ?? '');
    final String title = raw['title'] ?? widget.jobData['title'] ?? '';
    final String location = raw['location'] ?? widget.jobData['location'] ?? '';
    final String email = isCompanyJob
        ? raw['companyId']['cemail'] ?? ''
        : raw['recruiterId']?['emailAddress'] ?? '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textBlack),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Job application page',
          style: TextStyle(color: AppColors.textBlack),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, size: 28),
            ),
            const SizedBox(width: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        company,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        title,
                        style: const TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        location,
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Contact + social icons placeholder
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Location',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(location),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Email',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(email.isNotEmpty ? email : 'N/A'),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // // USER DATA SECTION
            // Container(
            //   padding: const EdgeInsets.all(16),
            //   decoration: BoxDecoration(
            //     border: Border.all(color: Colors.grey.shade300),
            //     borderRadius: BorderRadius.circular(8),
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       const Text(
            //         'Applicant Profile',
            //         style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            //       ),
            //       const SizedBox(height: 12),
            //       Row(
            //         children: [
            //           // User Avatar
            //           isLoadingProfile
            //               ? const CircleAvatar(
            //                   radius: 28,
            //                   backgroundColor: Colors.grey,
            //                   child: CircularProgressIndicator(
            //                     color: Colors.white,
            //                     strokeWidth: 2,
            //                   ),
            //                 )
            //               : CircleAvatar(
            //                   radius: 28,
            //                   backgroundColor: Colors.grey[300],
            //                   backgroundImage:
            //                       userProfile?.avatarUrl != null &&
            //                           userProfile!.avatarUrl!.isNotEmpty
            //                       ? NetworkImage(userProfile!.avatarUrl!)
            //                       : null,
            //                   child:
            //                       userProfile?.avatarUrl == null ||
            //                           userProfile!.avatarUrl!.isEmpty
            //                       ? const Icon(Icons.person, size: 28)
            //                       : null,
            //                 ),
            //           const SizedBox(width: 12),
            //           Expanded(
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Text(
            //                   isLoadingProfile
            //                       ? 'Loading...'
            //                       : userProfile?.name ?? 'N/A',
            //                   style: const TextStyle(
            //                     fontWeight: FontWeight.w700,
            //                     fontSize: 16,
            //                   ),
            //                 ),
            //                 const SizedBox(height: 4),
            //                 Text(
            //                   isLoadingProfile
            //                       ? 'Loading...'
            //                       : userProfile?.role ?? 'N/A',
            //                   style: const TextStyle(
            //                     color: Colors.black54,
            //                     fontSize: 14,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ],
            //       ),
            //       const SizedBox(height: 12),
            //       Row(
            //         children: [
            //           Expanded(
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 const Text(
            //                   'Email',
            //                   style: TextStyle(
            //                     fontWeight: FontWeight.w600,
            //                     fontSize: 12,
            //                   ),
            //                 ),
            //                 const SizedBox(height: 4),
            //                 Text(
            //                   isLoadingProfile
            //                       ? 'Loading...'
            //                       : userProfile?.email ?? 'N/A',
            //                   style: const TextStyle(
            //                     color: Colors.black87,
            //                     fontSize: 14,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //           Expanded(
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 const Text(
            //                   'Location',
            //                   style: TextStyle(
            //                     fontWeight: FontWeight.w600,
            //                     fontSize: 12,
            //                   ),
            //                 ),
            //                 const SizedBox(height: 4),
            //                 Text(
            //                   isLoadingProfile
            //                       ? 'Loading...'
            //                       : userProfile?.address ?? 'N/A',
            //                   style: const TextStyle(
            //                     color: Colors.black87,
            //                     fontSize: 14,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),

            // const SizedBox(height: 20),
            const Text(
              'Would you require Visa Sponsorship for the role you are applying for, now or in the next 2 Years?',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Radio<String>(
                      value: 'Yes',
                      groupValue: visaOption,
                      onChanged: (v) => setState(() => visaOption = v!),
                    ),
                    title: const Text('Yes'),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Radio<String>(
                      value: 'No',
                      groupValue: visaOption,
                      onChanged: (v) => setState(() => visaOption = v!),
                    ),
                    title: const Text('No'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Divider(color: Colors.grey.shade300),
            const Text(
              "Custom Questions",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            const Text(
              'What is your expected salary? *',
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: pitchController,
              decoration: InputDecoration(
                hintText: 'Enter Your answer here',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              'Resume (Required)',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            Obx(() {
              return Column(
                children: [
                  for (var i = 0; i < resumes.length; i++)
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.red.shade700,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'PDF',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  resumes[i].name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${(resumes[i].size / (1024 * 1024)).toStringAsFixed(2)} MB',
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => _downloadFile(resumes[i]),
                            icon: const Icon(Icons.download_outlined),
                          ),
                          // Radio<int>(
                          //   value: i,
                          //   groupValue: primaryIndex,
                          //   onChanged: (v) => _selectPrimary(v!),
                          // ),
                          IconButton(
                            onPressed: () => _removeResume(i),
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 8),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: _pickResume,
                        child: const Text('Upload Resume'),
                      ),
                      const SizedBox(width: 12),
                      const Text('DOC, PDF (5MB)'),
                    ],
                  ),
                ],
              );
            }),

            const SizedBox(height: 20),
            Row(
              children: [
                Checkbox(value: true, onChanged: (v) {}),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text('I agree to share my CV for this role'),
                ),
              ],
            ),

            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
