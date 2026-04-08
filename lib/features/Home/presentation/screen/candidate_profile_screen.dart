import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giveandtake/core/network/api_client.dart';
import 'package:giveandtake/core/network/constants/api_constants.dart';
import 'package:giveandtake/features/Home/presentation/controllers/candidate_dashboard_controller.dart';
import 'package:giveandtake/features/Home/presentation/screen/edit_candidate_profile_screen.dart';
import 'package:giveandtake/features/auth/presentation/controller/auth_controller.dart';
import 'package:giveandtake/features/company/data/model/candidate_resume_response_model.dart';
import 'package:giveandtake/features/profile_dasboard/presentation/controller/profile_controller.dart';

class CandidateProfileScreen extends StatefulWidget {
  const CandidateProfileScreen({super.key});

  @override
  State<CandidateProfileScreen> createState() => _CandidateProfileScreenState();
}

class _CandidateProfileScreenState extends State<CandidateProfileScreen> {
  late final CandidateDashboardController _dashboardController;
  late final ProfileController _profileController;

  @override
  void initState() {
    super.initState();
    _dashboardController = Get.isRegistered<CandidateDashboardController>()
        ? Get.find<CandidateDashboardController>()
        : Get.put(CandidateDashboardController());
    _profileController = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController());

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _refreshProfile();
    });
  }

  Future<void> _refreshProfile() async {
    await Future.wait([
      _dashboardController.fetchDashboardData(),
      _profileController.fetchUser(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (_dashboardController.isLoadingResume.value &&
              _dashboardController.resumeData.value == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final resumeData = _dashboardController.resumeData.value;
          final resume = resumeData?.resume;
          final topName = _displayName(resume);
          final topEmail =
              (resume?.email?.trim().isNotEmpty ?? false)
                  ? resume!.email!.trim()
                  : (_profileController.user?.email ?? '');
          final phoneNumber = _profileController.user?.phoneNum ?? '';

          return RefreshIndicator(
            onRefresh: _refreshProfile,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 28),
              children: [
                const SizedBox(height: 8),
                Center(
                  child: _buildAvatar(
                    photoUrl: resume?.photo,
                    fallbackAvatarUrl: _profileController.user?.avatarUrl,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  topName.isEmpty ? 'Candidate Profile' : topName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF222222),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  topEmail,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6A6A6A),
                  ),
                ),
                const SizedBox(height: 18),
                const Divider(height: 1, color: Color(0xFFE5E5E5)),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () async {
                      if (resumeData == null) return;
                      await Get.to(
                        () => const EditCandidateProfileScreen(),
                        arguments: resumeData,
                      );
                      await _refreshProfile();
                    },
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                ),
                _buildReadOnlyField(
                  label: 'First Name',
                  value: resume?.firstName ?? '',
                ),
                _buildReadOnlyField(
                  label: 'Last Name',
                  value: resume?.lastName ?? '',
                ),
                _buildReadOnlyField(
                  label: 'Email Address',
                  value: topEmail,
                ),
                _buildReadOnlyField(label: 'Phone', value: phoneNumber),
                _buildReadOnlyField(
                  label: 'Country',
                  value: resume?.country ?? '',
                ),
                _buildReadOnlyField(
                  label: 'City/State',
                  value: resume?.city ?? '',
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: OutlinedButton(
                          onPressed: () => _showDeactivateDialog(context),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFE53935)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3),
                            ),
                            foregroundColor: Colors.black,
                          ),
                          child: const Text(
                            'Deactivate Account',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () => _showDeleteDialog(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD50000),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          child: const Text(
                            'Delete Account',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22),
                  child: Text(
                    "We're sorry to see you leave! Your account and its data will be permanently deleted in the next 30 days. Please consider deactivating your account first and then delete it after a break.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.45,
                      color: Color(0xFFD50000),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  String _displayName(Resume? resume) {
    final first = resume?.firstName?.trim() ?? '';
    final last = resume?.lastName?.trim() ?? '';
    return '$first $last'.trim();
  }

  Widget _buildAvatar({
    required String? photoUrl,
    required String? fallbackAvatarUrl,
  }) {
    final imageUrl = (photoUrl?.trim().isNotEmpty ?? false)
        ? photoUrl!.trim()
        : ((fallbackAvatarUrl?.trim().isNotEmpty ?? false)
              ? fallbackAvatarUrl!.trim()
              : null);

    if (imageUrl == null) {
      return Container(
        width: 110,
        height: 110,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFEDEDED),
        ),
        child: const Icon(Icons.person, size: 54, color: Color(0xFF8E8E8E)),
      );
    }

    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: 110,
        height: 110,
        fit: BoxFit.cover,
        placeholder: (_, __) => Container(
          width: 110,
          height: 110,
          color: const Color(0xFFEDEDED),
        ),
        errorWidget: (_, __, ___) => Container(
          width: 110,
          height: 110,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFEDEDED),
          ),
          child: const Icon(Icons.person, size: 54, color: Color(0xFF8E8E8E)),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1E1E1E),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: value,
            enabled: false,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: value,
              hintStyle: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6A6A6A),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 16,
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF8A8A8A)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF8A8A8A)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context) async {
    final email =
        _profileController.user?.email ??
        _dashboardController.resumeData.value?.resume?.email ??
        '';
    final passwordCtrl = TextEditingController();
    var isProcessing = false;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setStateDialog) {
            return AlertDialog(
              title: const Center(child: Text('Confirm Account Deletion')),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Please confirm your identity to permanently delete your account. You can still log back in within 30 days to restore it.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Color(0xFF666666)),
                    ),
                    const SizedBox(height: 12),
                    _buildDialogLabel('Email'),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: email,
                      enabled: false,
                      decoration: _dialogInputDecoration(
                        fillColor: const Color(0xFFF6F7F8),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDialogLabel('Password'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: passwordCtrl,
                      obscureText: true,
                      decoration: _dialogInputDecoration(
                        hintText: 'Enter your password',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isProcessing
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: isProcessing
                      ? null
                      : () async {
                          final password = passwordCtrl.text.trim();
                          if (password.isEmpty) {
                            Get.snackbar('Error', 'Please enter your password');
                            return;
                          }

                          setStateDialog(() => isProcessing = true);
                          try {
                            final response = await ApiClient()
                                .patch<Map<String, dynamic>>(
                                  ApiConstants.user.deactivate,
                                  data: {
                                    'email': email,
                                    'password': password,
                                  },
                                  fromJsonT: (json) =>
                                      (json as Map?)?.cast<String, dynamic>() ??
                                      <String, dynamic>{},
                                );

                            response.fold(
                              (fail) {
                                setStateDialog(() => isProcessing = false);
                                Get.snackbar(
                                  'Error',
                                  fail.message,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              },
                              (success) {
                                setStateDialog(() => isProcessing = false);
                                Navigator.of(dialogContext).pop();
                                Get.snackbar(
                                  'Success',
                                  success.message,
                                  backgroundColor: const Color(0xFF10B287),
                                  colorText: Colors.white,
                                );
                                Future.delayed(
                                  const Duration(milliseconds: 600),
                                  () {
                                    try {
                                      Get.find<AuthController>().logout();
                                    } catch (_) {}
                                  },
                                );
                              },
                            );
                          } catch (e) {
                            setStateDialog(() => isProcessing = false);
                            Get.snackbar(
                              'Error',
                              'Request failed: $e',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD50000),
                  ),
                  child: isProcessing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Delete Account',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showDeactivateDialog(BuildContext context) async {
    final email =
        _profileController.user?.email ??
        _dashboardController.resumeData.value?.resume?.email ??
        '';
    final passwordCtrl = TextEditingController();
    var isProcessing = false;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setStateDialog) {
            return AlertDialog(
              title: const Center(child: Text('Confirm Deactivation')),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Please confirm your identity to deactivate your account. You can reactivate anytime.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Color(0xFF666666)),
                    ),
                    const SizedBox(height: 12),
                    _buildDialogLabel('Email'),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: email,
                      enabled: false,
                      decoration: _dialogInputDecoration(
                        fillColor: const Color(0xFFF6F7F8),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDialogLabel('Password'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: passwordCtrl,
                      obscureText: true,
                      decoration: _dialogInputDecoration(
                        hintText: 'Enter your password',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isProcessing
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: isProcessing
                      ? null
                      : () async {
                          final password = passwordCtrl.text.trim();
                          if (password.isEmpty) {
                            Get.snackbar('Error', 'Please enter your password');
                            return;
                          }

                          setStateDialog(() => isProcessing = true);
                          try {
                            final response = await ApiClient()
                                .patch<Map<String, dynamic>>(
                                  ApiConstants.user.disable,
                                  data: {
                                    'email': email,
                                    'password': password,
                                  },
                                  fromJsonT: (json) =>
                                      (json as Map?)?.cast<String, dynamic>() ??
                                      <String, dynamic>{},
                                );

                            response.fold(
                              (fail) {
                                setStateDialog(() => isProcessing = false);
                                Get.snackbar(
                                  'Error',
                                  fail.message,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              },
                              (success) {
                                setStateDialog(() => isProcessing = false);
                                Navigator.of(dialogContext).pop();
                                Get.snackbar(
                                  'Success',
                                  success.message,
                                  backgroundColor: const Color(0xFF10B287),
                                  colorText: Colors.white,
                                );
                                Future.delayed(
                                  const Duration(milliseconds: 600),
                                  () {
                                    try {
                                      Get.find<AuthController>().logout();
                                    } catch (_) {}
                                  },
                                );
                              },
                            );
                          } catch (e) {
                            setStateDialog(() => isProcessing = false);
                            Get.snackbar(
                              'Error',
                              'Request failed: $e',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B7FD0),
                  ),
                  child: isProcessing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Deactivate Account',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDialogLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  InputDecoration _dialogInputDecoration({
    String? hintText,
    Color? fillColor,
  }) {
    return InputDecoration(
      hintText: hintText,
      filled: fillColor != null,
      fillColor: fillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: fillColor != null ? BorderSide.none : const BorderSide(),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: fillColor != null ? BorderSide.none : const BorderSide(),
      ),
    );
  }
}
