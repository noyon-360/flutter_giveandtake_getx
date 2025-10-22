import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controller/profile_controller.dart';
import '../../data/models/user_model.dart';
import 'package:image_cropper/image_cropper.dart';


class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? _image;
  late final ProfileController _ctrl;

  //Text Editing Controllers
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _surnameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
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
    _phoneCtrl.text = user.phoneNum ?? '';
    _addressCtrl.text = user.address ?? '';
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      print('No image selected');
      return;
    }

    // Step 1: Crop the image using the new API (v11+)
    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 90,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Profile Photo',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          hideBottomControls: true,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Crop Profile Photo',
          aspectRatioLockEnabled: true,
        ),
      ],
    );

    // Step 2: Update _image only if cropping is done
    if (croppedFile != null) {
      setState(() {
        _image = File(croppedFile.path);
      });
      print('Cropped image path: ${croppedFile.path}');
    } else {
      print('Cropping canceled');
    }
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
              // New field
              _textField(controller: _phoneCtrl, label: "Phone", hint: ""),
              _textField(
                controller: _emailCtrl,
                label: "Email Address",
                hint: "",
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
                                    'phoneNum': _phoneCtrl.text.trim(),
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
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
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
