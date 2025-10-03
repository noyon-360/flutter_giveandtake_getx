import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:karlfive/features/profile_dasboard/presentation/screens/personal_iformation_screen.dart';
import '../../../../core/bottomNavbar/widgets/custom_bottom_navbar.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? _image;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
    await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
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
          onPressed: () {
            Get.to(() => const PersonalInfoScreen());
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                        backgroundImage: _image != null
                            ? FileImage(_image!)
                            : const AssetImage("assets/images/profile.jpg")
                        as ImageProvider,
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
                              "assets/icons/camera.png",
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
                  const Text(
                    "Brooklyn Simmons",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "brooklynsimmons@gmail.com",
                    style: TextStyle(fontSize: 14, color: Color(0xFF595959)),
                  ),
                  const SizedBox(height: 24),
                  const Divider(
                    thickness: 1,
                    color: Color(0xFFE0E0E0),
                  ),
                ],
              ),
              const SizedBox(height: 60),

              /// Editable Fields
              _textField(label: "First Name", hint: "Brooklyn"),
              _textField(label: "Last Name", hint: "Simmons"),
              _textField(
                  label: "Email Address", hint: "brooklynsimmons@gmail.com"),
              _textField(label: "Phone", hint: "(58) 474748574"),
              _textField(label: "Country", hint: "USA"),
              _textField(label: "City/State", hint: "Alabama"),
              _textField(label: "Town", hint: "Berlin"),
              _textField(label: "Zip/Postal Code (Optional)", hint: "1212"),

              const SizedBox(height: 30),

              /// Action Buttons
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2B7FD0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text(
                          "Update",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget _textField({
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
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF595959),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                  const BorderSide(color: Color(0xFF595959), width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                      color: Color(0xFF1A3E74), width: 1.5), // focus color
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
