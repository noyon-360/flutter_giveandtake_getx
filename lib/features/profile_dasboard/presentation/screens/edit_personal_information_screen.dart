import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controller/profile_controller.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? _image;
  late final ProfileController _ctrl;
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _addressCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // ✅ Initialize controller once
    // Try to find existing controller; if not found, put a new one.
    _ctrl = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController());

    // ✅ Pre-fill fields if user data already available
    final user = _ctrl.user;
    if (user != null) {
      _nameCtrl.text = user.name;
      _emailCtrl.text = user.email;
      _phoneCtrl.text = user.phoneNum ?? '';
      _addressCtrl.text = user.address ?? '';
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _ctrl.user;
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
              // Profile Section
              Column(
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
              ),
              const SizedBox(height: 60),

              // Editable fields
              _textField(controller: _nameCtrl, label: "First Name", hint: ""),
              _textField(controller: _phoneCtrl, label: "Phone", hint: ""),
              _textField(
                controller: _emailCtrl,
                label: "Email Address",
                hint: "",
              ),
              _textField(controller: _addressCtrl, label: "Country", hint: ""),

              const SizedBox(height: 30),

              // Update button
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
                                  final payload = {
                                    'name': _nameCtrl.text.trim(),
                                    'email': _emailCtrl.text.trim(),
                                    'phoneNum': _phoneCtrl.text.trim(),
                                    'address': _addressCtrl.text.trim(),
                                  };
                                  await _ctrl.updateUser(payload);
                                  if (_ctrl.error == null) {
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
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

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
