import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giveandtake/features/profile_dasboard/presentation/screens/edit_personal_information_screen.dart';
import '../controller/profile_controller.dart';
import 'package:giveandtake/core/network/api_client.dart';
import 'package:giveandtake/core/network/constants/api_constants.dart';
import 'package:giveandtake/features/auth/presentation/controller/auth_controller.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  // Create controller once when the widget instance is constructed.
  // This avoids calling Get.put inside build repeatedly.
  static final ProfileController _ctrl = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final ProfileController ctrl = _ctrl;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (ctrl.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (ctrl.error != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Error: ${ctrl.error}'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: ctrl.fetchUser,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final user = ctrl.user;
          if (user == null) {
            return const Center(child: Text('No user data'));
          }

          final nameParts = user.name.trim().split(' ');
          final lastName = nameParts.isNotEmpty ? nameParts.last : '';
          final firstName = nameParts.length > 1
              ? nameParts.sublist(0, nameParts.length - 1).join(' ')
              : user.name;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                /// Profile Image + Name + Email
                Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              user.avatarUrl != null &&
                                  user.avatarUrl!.isNotEmpty
                              ? NetworkImage(user.avatarUrl!) as ImageProvider
                              : const AssetImage('assets/images/profile.jpg'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF595959),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Divider(thickness: 1, color: Color(0xFFE0E0E0)),

                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {
                          Get.to(() => EditProfile());
                        },
                        icon: Image.asset(
                          "assets/icons/editprofile.png",
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                  ],
                ),

                /// Editable Fields (prefilled)
                _textField(label: 'First Name', hint: firstName),
                _textField(label: 'Surname', hint: lastName),
                _textField(label: 'Email Address', hint: user.email),
                _textField(label: 'Country', hint: user.address ?? ''),

                const SizedBox(height: 30),

                /// Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 32,
                        child: OutlinedButton(
                          onPressed: () {
                            _showDeactivateDialog(context, ctrl);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFD00003),
                            side: const BorderSide(
                              color: Colors.red,
                              width: 1.2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          child: const Text(
                            'Deactivate Account',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: SizedBox(
                        height: 32,
                        child: ElevatedButton(
                          onPressed: () {
                            _showDeleteDialog(context, ctrl);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD00003),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          child: const Text(
                            'Delete Account',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                /// Text
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 200,
                      margin: const EdgeInsets.only(top: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      alignment: Alignment.centerRight,
                      child: const Text(
                        "We’re sorry to see you leave! Your account and its data will be permanently deleted in the next 30 days. "
                        "Please consider deactivating your account first and then delete it after a break.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.red,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        }),
      ),
    );
  }

  Future<void> _showDeleteDialog(
    BuildContext context,
    ProfileController ctrl,
  ) async {
    final email = ctrl.user?.email ?? '';
    final TextEditingController passwordCtrl = TextEditingController();
    bool isProcessing = false;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Center(child: const Text('Confirm Account Deletion')),
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
                    Align(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Email',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: email,
                      enabled: false,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF6F7F8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Password',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: passwordCtrl,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isProcessing
                      ? null
                      : () => Navigator.of(context).pop(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: isProcessing
                      ? null
                      : () async {
                          final pwd = passwordCtrl.text.trim();
                          if (pwd.isEmpty) {
                            Get.snackbar('Error', 'Please enter your password');
                            return;
                          }
                          setStateDialog(() => isProcessing = true);
                          try {
                            final api = ApiClient();
                            final res = await api.patch<Map<String, dynamic>>(
                              ApiConstants.user.deactivate,
                              data: {'email': email, 'password': pwd},
                              fromJsonT: (json) => json == null
                                  ? {}
                                  : json as Map<String, dynamic>,
                            );
                            res.fold(
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
                                Navigator.of(context).pop();
                                Get.snackbar(
                                  'Success',
                                  success.message,
                                  backgroundColor: const Color(0xFF10B287),
                                  colorText: Colors.white,
                                );
                                // Sign out the user after account deletion
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
                              'Request failed: ${e.toString()}',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD00003),
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

  Future<void> _showDeactivateDialog(
    BuildContext context,
    ProfileController ctrl,
  ) async {
    final email = ctrl.user?.email ?? '';
    final TextEditingController passwordCtrl = TextEditingController();
    bool isProcessing = false;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Center(child: const Text('Confirm Deactivation')),
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
                    Align(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Email',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: email,
                      enabled: false,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF6F7F8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Password',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: passwordCtrl,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isProcessing
                      ? null
                      : () => Navigator.of(context).pop(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: isProcessing
                      ? null
                      : () async {
                          final pwd = passwordCtrl.text.trim();
                          if (pwd.isEmpty) {
                            Get.snackbar('Error', 'Please enter your password');
                            return;
                          }
                          setStateDialog(() => isProcessing = true);
                          try {
                            final api = ApiClient();
                            final res = await api.patch<Map<String, dynamic>>(
                              ApiConstants.user.disable,
                              data: {'email': email, 'password': pwd},
                              fromJsonT: (json) => json == null
                                  ? {}
                                  : json as Map<String, dynamic>,
                            );
                            res.fold(
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
                                Navigator.of(context).pop();
                                Get.snackbar(
                                  'Success',
                                  success.message,
                                  backgroundColor: const Color(0xFF10B287),
                                  colorText: Colors.white,
                                );
                                // Sign out the user after account deactivation
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
                              'Request failed: ${e.toString()}',
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

  Widget _textField({required String label, required String hint}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 53,
            child: TextFormField(
              enabled: false,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF595959),
                ),
                filled: true,
                fillColor: Colors.white,
                // background color
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8), // radius
                  borderSide: const BorderSide(
                    color: Color(0xFF595959),
                    width: 1,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color(0xFF1A3E74),
                    width: 1.5,
                  ), // focus color
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
