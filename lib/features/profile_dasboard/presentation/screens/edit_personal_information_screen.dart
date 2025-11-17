import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import '../controller/profile_controller.dart';
import '../../data/models/user_model.dart';
import 'package:karlfive/features/auth/domain/repo/auth_repo.dart';
import 'package:karlfive/features/auth/data/models/verify_security_answers_request_model.dart';
import 'package:karlfive/core/network/api_client.dart';
import 'package:karlfive/core/network/constants/api_constants.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? _image;
  late final ProfileController _ctrl;
  bool _isEmailEditable = false;
  final FocusNode _emailFocusNode = FocusNode();

  //Text Editing Controllers
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _surnameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _newEmailCtrl = TextEditingController();
  final TextEditingController _otpCtrl = TextEditingController();
  final TextEditingController _addressCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Initialize controller (reuse existing instance)
    _ctrl = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController());

    // Initial prefill
    _prefillFields();
  }

  void _prefillFields() {
    final user = _ctrl.user;
    if (user != null) {
      _updateTextFields(user);
    }
  }

  void _updateTextFields(UserModel user) {
    //Split full name into first name & surname automatically
    final nameParts = user.name.trim().split(' ');
    final lastName = nameParts.isNotEmpty ? nameParts.last : '';
    final firstName = nameParts.length > 1
        ? nameParts.sublist(0, nameParts.length - 1).join(' ')
        : user.name;

    _nameCtrl.text = firstName;
    _surnameCtrl.text = lastName;
    _emailCtrl.text = user.email;
    _addressCtrl.text = user.address ?? '';
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      try {
        // Open crop / resize UI so user can adjust the selected image
        final CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Resize / Crop',
              toolbarColor: Colors.black,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
            ),
            IOSUiSettings(
              title: 'Resize / Crop',
            ),
          ],
        );

        if (croppedFile != null) {
          setState(() {
            _image = File(croppedFile.path);
          });
          print('Cropped image path: ${croppedFile.path}');
        } else {
          // If user cancelled cropping, still use the originally selected image
          setState(() {
            _image = File(pickedFile.path);
          });
          print('No crop applied, using original image: ${pickedFile.path}');
        }
      } catch (e) {
        // Fallback to original image on any error and surface debug info
        setState(() {
          _image = File(pickedFile.path);
        });
        print('[ERROR] Image crop failed: $e');
      }
    } else {
      print('No image selected');
    }
  }

  Future<void> _showSecurityQuestionsDialog() async {
    // Fetch user data from /user/single endpoint to get security questions
    List<Map<String, dynamic>>? userSecurityQuestions;
    try {
      await _ctrl.fetchUser();
      userSecurityQuestions = _ctrl.user?.securityQuestions;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load security questions: $e');
      return;
    }

    // Extract question strings from the security questions array
    // Expecting format: [{ "question": "...", "answer": "..." }, ...]
    final List<String> dialogQuestions = userSecurityQuestions != null
        ? userSecurityQuestions
              .where((q) => q['question'] != null)
              .map((q) => q['question'].toString())
              .toList()
        : [
            'What is your favorite color?',
            'What was your first school\'s name?',
          ];

    // Display ALL questions (do not limit to 2) - backend requires all answers
    final displayQuestions = dialogQuestions;

    final answerControllers = List.generate(
      displayQuestions.length,
      (_) => TextEditingController(),
    );

    bool isVerifying = false;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            final answeredCount = answerControllers
                .where((c) => c.text.trim().isNotEmpty)
                .length;
            return AlertDialog(
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 24,
              ),
              title: Center(child: const Text('Verify Your Identity')),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Center(
                        child: const Text(
                          'Please answer your security questions to continue changing your email.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    for (var i = 0; i < displayQuestions.length; i++) ...[
                      Text(
                        displayQuestions[i],
                        style: const TextStyle(
                          color: Color(0xFF2B7FD0),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: answerControllers[i],
                        onChanged: (_) => setStateDialog(() {}),
                        decoration: InputDecoration(
                          hintText: 'Enter your answer',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF000000),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: isVerifying
                                ? null
                                : () {
                                    Navigator.of(context).pop();
                                  },
                            child: const Text(
                              'Back',
                              style: TextStyle(
                                color: Color.fromARGB(255, 8, 8, 8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isVerifying
                                ? null
                                : () async {
                                    // Verify answers
                                    final answers = answerControllers
                                        .map((c) => c.text.trim())
                                        .toList();

                                    // Require ALL answers to match the number of questions
                                    if (answers.length !=
                                            displayQuestions.length ||
                                        answers.any((a) => a.isEmpty)) {
                                      Get.snackbar(
                                        'Error',
                                        'Please answer all ${displayQuestions.length} security questions',
                                      );
                                      return;
                                    }

                                    setStateDialog(() {
                                      isVerifying = true;
                                    });

                                    try {
                                      // Call /verify-security-answers endpoint directly with email and answers
                                      final repo = Get.find<AuthRepository>();
                                      final request =
                                          VerifySecurityAnswersRequestModel(
                                            email: _emailCtrl.text.trim(),
                                            answers: answers,
                                          );
                                      final result = await repo
                                          .verifySecurityAnswers(request);
                                      result.fold(
                                        (fail) {
                                          setStateDialog(() {
                                            isVerifying = false;
                                          });
                                          Get.snackbar(
                                            'Error',
                                            fail.message,
                                            backgroundColor: Colors.red,
                                            colorText: Colors.white,
                                          );
                                        },
                                        (success) {
                                          setStateDialog(() {
                                            isVerifying = false;
                                          });
                                          // On success, proceed to change-email flow (enter new email + OTP)
                                          Navigator.of(context).pop();
                                          // Show dialog to enter new email and kick off OTP flow
                                          Future.delayed(
                                            const Duration(milliseconds: 200),
                                            () {
                                              _showChangeEmailDialog();
                                            },
                                          );
                                        },
                                      );
                                    } catch (e) {
                                      setStateDialog(() {
                                        isVerifying = false;
                                      });
                                      Get.snackbar(
                                        'Error',
                                        'Verification failed. Please try again.',
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2B7FD0),
                            ),
                            child: isVerifying
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Verify Answers',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progress',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF999999),
                          ),
                        ),
                        Text(
                          '$answeredCount/${dialogQuestions.length}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF999999),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: dialogQuestions.isEmpty
                          ? 0
                          : answeredCount / dialogQuestions.length,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              //Profile Section - Now Reactive
              Obx(() {
                final user = _ctrl.user;
                // Update text fields when user data changes reactively
                if (user != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _updateTextFields(user);
                  });
                }

                return Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: _image != null
                              ? FileImage(_image!) as ImageProvider
                              : (user != null &&
                                        user.avatarUrl != null &&
                                        user.avatarUrl!.isNotEmpty
                                    ? NetworkImage(user.avatarUrl!)
                                    : const AssetImage(
                                        "assets/images/profile.jpg",
                                      )),
                        ),
                        Positioned(
                          bottom: 7.33,
                          right: 7.33,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.black,
                              child: Image.asset(
                                "assets/images/camara.png",
                                width: 13,
                                height: 13,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user?.name ?? 'User',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF595959),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Divider(thickness: 1, color: Color(0xFFE0E0E0)),
                  ],
                );
              }),
              const SizedBox(height: 60),

              //Editable Fields
              _textField(controller: _nameCtrl, label: "First Name", hint: ""),
              _textField(controller: _surnameCtrl, label: "Surname", hint: ""),

              // Email field with Change button (styled like screenshot)
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Email Address",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFE0E0E0),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _emailCtrl,
                              focusNode: _emailFocusNode,
                              enabled: _isEmailEditable,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF595959),
                              ),
                              decoration: const InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                hintText: '',
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () {
                              // If currently not editable, require security verification first
                              if (!_isEmailEditable) {
                                _showSecurityQuestionsDialog();
                                return;
                              }

                              // If editable, toggle to finish editing
                              setState(() {
                                _isEmailEditable = false;
                                FocusScope.of(context).unfocus();
                              });
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              minimumSize: const Size(40, 36),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              backgroundColor: Colors.transparent,
                            ),
                            child: Text(
                              _isEmailEditable ? 'Done' : 'Change',
                              style: const TextStyle(
                                color: Color(0xFF2B7FD0),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              _textField(controller: _addressCtrl, label: "Country", hint: ""),

              const SizedBox(height: 30),

              //Update Button
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: Obx(() {
                        final isLoading = _ctrl.isLoading;
                        return ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                                  // Merge first name + surname before sending
                                  final payload = {
                                    'name':
                                        '${_nameCtrl.text.trim()} ${_surnameCtrl.text.trim()}'
                                            .trim(),
                                    'email': _emailCtrl.text.trim(),
                                    'address': _addressCtrl.text.trim(),
                                  };

                                  await _ctrl.updateUser(
                                    payload,
                                    imageFile: _image,
                                  );

                                  if (_ctrl.error == null) {
                                    // Clear the selected image after successful update
                                    setState(() {
                                      _image = null;
                                    });
                                    // Show success message
                                    Get.snackbar(
                                      'Success',
                                      'Profile updated successfully!',
                                      backgroundColor: const Color(0xFF10B287),
                                      colorText: Colors.white,
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                    Navigator.of(context).pop();
                                  } else {
                                    Get.snackbar('Error', _ctrl.error ?? '');
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2B7FD0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  "Update",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                        );
                      }),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _surnameCtrl.dispose();
    _emailCtrl.dispose();
    _newEmailCtrl.dispose();
    _otpCtrl.dispose();
    _addressCtrl.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  Future<void> _showChangeEmailDialog() async {
    _newEmailCtrl.text = '';
    bool isSending = false;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Center(child: const Text('Enter New Email')),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "We'll send a one-time passcode (OTP) to confirm your new email address.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Color(0xFF666666)),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Current Email',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: _emailCtrl.text.trim(),
                      enabled: false,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF6F7F8),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
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
                        'New Email',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _newEmailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Enter your new email',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onChanged: (_) => setStateDialog(() {}),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSending
                      ? null
                      : () {
                          Navigator.of(context).pop();
                        },
                  child: const Text(
                    'Back',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: isSending
                      ? null
                      : () async {
                          final newEmail = _newEmailCtrl.text.trim();
                          if (newEmail.isEmpty || !GetUtils.isEmail(newEmail)) {
                            Get.snackbar('Error', 'Please enter a valid email');
                            return;
                          }

                          setStateDialog(() {
                            isSending = true;
                          });

                          try {
                            final api = ApiClient();
                            final res = await api.post<Map<String, dynamic>>(
                              ApiConstants.auth.changeEmail,
                              data: {'email': newEmail},
                              fromJsonT: (json) => json == null
                                  ? {}
                                  : json as Map<String, dynamic>,
                            );

                            res.fold(
                              (fail) {
                                setStateDialog(() {
                                  isSending = false;
                                });
                                // Show detailed failure if available
                                Get.snackbar(
                                  'Error',
                                  fail.message,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              },
                              (success) {
                                setStateDialog(() {
                                  isSending = false;
                                });
                                // Show a confirmation so user sees the OTP was requested
                                Get.snackbar(
                                  'OTP Sent',
                                  'A one-time passcode was sent to $newEmail',
                                  backgroundColor: const Color(0xFF2B7FD0),
                                  colorText: Colors.white,
                                );
                                // Close current dialog then open OTP dialog after a short delay
                                Navigator.of(context).pop();
                                Future.delayed(
                                  const Duration(milliseconds: 300),
                                  () {
                                    _showOtpVerifyDialog(newEmail);
                                  },
                                );
                              },
                            );
                          } catch (e) {
                            setStateDialog(() {
                              isSending = false;
                            });
                            // Surface exception message for debugging
                            Get.snackbar(
                              'Error',
                              'Failed to send OTP: ${e.toString()}',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B7FD0),
                  ),
                  child: isSending
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Continue',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
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

  Future<void> _showOtpVerifyDialog(String newEmail) async {
    _otpCtrl.text = '';
    bool isVerifying = false;
    bool isResending = false;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Center(child: const Text('Verify Email')),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Enter the OTP sent to your new email to verify and complete the change.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Color(0xFF666666)),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _otpCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter OTP',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: (isVerifying || isResending)
                            ? null
                            : () async {
                                setStateDialog(() {
                                  isResending = true;
                                });
                                try {
                                  final api = ApiClient();
                                  // Log the resend attempt
                                  print(
                                    '[DEBUG] Resending OTP to $newEmail using endpoint: ${ApiConstants.auth.changeEmail}',
                                  );
                                  final res = await api
                                      .post<Map<String, dynamic>>(
                                        ApiConstants.auth.changeEmail,
                                        data: {'email': newEmail},
                                        fromJsonT: (json) => json == null
                                            ? {}
                                            : json as Map<String, dynamic>,
                                      );
                                  res.fold(
                                    (fail) {
                                      print(
                                        '[DEBUG] Resend failed: ${fail.message}',
                                      );
                                      setStateDialog(() {
                                        isResending = false;
                                      });
                                      Get.snackbar(
                                        'Error',
                                        'Failed to resend OTP: ${fail.message}',
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white,
                                      );
                                    },
                                    (success) {
                                      print('[DEBUG] Resend successful');
                                      setStateDialog(() {
                                        isResending = false;
                                      });
                                      Get.snackbar(
                                        'OTP Resent',
                                        'A new OTP was sent to $newEmail',
                                        backgroundColor: const Color(
                                          0xFF2B7FD0,
                                        ),
                                        colorText: Colors.white,
                                      );
                                    },
                                  );
                                } catch (e) {
                                  print('[DEBUG] Resend exception: $e');
                                  setStateDialog(() {
                                    isResending = false;
                                  });
                                  Get.snackbar(
                                    'Error',
                                    'Resend failed: ${e.toString()}',
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                }
                              },
                        child: isResending
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFF2B7FD0),
                                ),
                              )
                            : const Text(
                                'Resend OTP',
                                style: TextStyle(
                                  color: Color(0xFF2B7FD0),
                                  fontSize: 12,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: (isVerifying || isResending)
                      ? null
                      : () {
                          Navigator.of(context).pop();
                        },
                  child: const Text(
                    'Back',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: (isVerifying || isResending)
                      ? null
                      : () async {
                          final otp = _otpCtrl.text.trim();
                          if (otp.isEmpty) {
                            Get.snackbar('Error', 'Please enter the OTP');
                            return;
                          }
                          setStateDialog(() {
                            isVerifying = true;
                          });

                          try {
                            final api = ApiClient();
                            print(
                              '[DEBUG] Verifying OTP: $newEmail using endpoint: ${ApiConstants.auth.verify}',
                            );
                            final res = await api.post<Map<String, dynamic>>(
                              ApiConstants.auth.verify,
                              data: {'email': newEmail, 'otp': otp},
                              fromJsonT: (json) => json == null
                                  ? {}
                                  : json as Map<String, dynamic>,
                            );

                            res.fold(
                              (fail) {
                                print('[DEBUG] Verify failed: ${fail.message}');
                                setStateDialog(() {
                                  isVerifying = false;
                                });
                                Get.snackbar('Error', fail.message);
                              },
                              (success) {
                                print(
                                  '[DEBUG] Verify successful, updating email to: $newEmail',
                                );
                                setStateDialog(() {
                                  isVerifying = false;
                                });
                                // Update UI with new email instantly and persist
                                setState(() {
                                  _emailCtrl.text = newEmail;
                                  _isEmailEditable = false;
                                });
                                Navigator.of(context).pop();
                                Get.snackbar(
                                  'Success',
                                  'Email verified successfully',
                                  backgroundColor: const Color(0xFF10B287),
                                  colorText: Colors.white,
                                );
                              },
                            );
                          } catch (e) {
                            print('[DEBUG] Verify exception: $e');
                            setStateDialog(() {
                              isVerifying = false;
                            });
                            Get.snackbar(
                              'Error',
                              'Verification failed. Please try again.',
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B7FD0),
                  ),
                  child: isVerifying
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Verify',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
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

  //Common TextField Builder
  Widget _textField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 53,
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF595959),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFF595959),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color(0xFF1A3E74),
                    width: 1.5,
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
