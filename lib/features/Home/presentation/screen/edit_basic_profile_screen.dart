import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giveandtake/features/Home/presentation/controllers/edit_basic_profile_controller.dart';

class EditBasicProfileScreen extends StatefulWidget {
  const EditBasicProfileScreen({super.key});

  @override
  State<EditBasicProfileScreen> createState() => _EditBasicProfileScreenState();
}

class _EditBasicProfileScreenState extends State<EditBasicProfileScreen> {
  late final EditBasicProfileController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(EditBasicProfileController());
    
    // Load countries first, then populate data
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Wait a bit for countries to load
      await Future.delayed(const Duration(milliseconds: 500));
      
      final resumeData = Get.arguments;
      if (resumeData != null) {
        print('📝 [EditBasicProfile] Populating data: $resumeData');
        controller.populateData(resumeData);
      }
    });
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
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(18),
            children: [
              // Profile Photo Section
              _buildProfilePhotoSection(),
              const SizedBox(height: 24),
              _buildTextField(
                label: 'First Name',
                controller: controller.firstNameController,
                hintText: 'Enter first name',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Last Name',
                controller: controller.lastNameController,
                hintText: 'Enter last name',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Email Address',
                controller: controller.emailController,
                hintText: 'Enter email',
                enabled: false,
              ),
              const SizedBox(height: 16),
              _buildCountryDropdown(),
              const SizedBox(height: 16),
              _buildCityDropdown(),
              const SizedBox(height: 32),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: controller.isUpdating.value
                      ? null
                      : () => controller.updateProfile(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B7FD0),
                    disabledBackgroundColor: Colors.grey[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: controller.isUpdating.value
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Save Changes',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E1E1E),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: enabled,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              fontSize: 14,
              color: Color(0xFF8A8A8A),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD0D0D0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD0D0D0)),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
            ),
            filled: !enabled,
            fillColor: !enabled ? const Color(0xFFF6F7F8) : Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildCountryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Country',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E1E1E),
          ),
        ),
        const SizedBox(height: 8),
        Obx(() {
          return DropdownButtonFormField<String>(
            isExpanded: true,
            value: controller.selectedCountry.value,
            hint: const Text('Select Country'),
            items: controller.countries.map((country) {
              return DropdownMenuItem(
                value: country,
                child: Text(country),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                controller.updateCitiesForCountry(value);
              }
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFD0D0D0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFD0D0D0)),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCityDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'City',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E1E1E),
          ),
        ),
        const SizedBox(height: 8),
        Obx(() {
          return DropdownButtonFormField<String>(
            isExpanded: true,
            value: controller.selectedCity.value,
            hint: const Text('Select City'),
            items: controller.cities.map((city) {
              return DropdownMenuItem(
                value: city,
                child: Text(city),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                controller.selectedCity.value = value;
              }
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFD0D0D0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFD0D0D0)),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildProfilePhotoSection() {
    return Center(
      child: Column(
        children: [
          Obx(() {
            String? displayImage;
            
            // Determine which image to show
            if (controller.photoPath.value != null) {
              displayImage = controller.photoPath.value;
            } else if (controller.networkPhotoUrl.value != null) {
              displayImage = controller.networkPhotoUrl.value;
            }

            return GestureDetector(
              onTap: () => controller.pickPhoto(),
              child: Stack(
                children: [
                  // Profile Photo
                  if (displayImage != null && controller.photoPath.value != null)
                    ClipOval(
                      child: Image.file(
                        File(displayImage),
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    )
                  else if (displayImage != null && controller.networkPhotoUrl.value != null)
                    ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: displayImage,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          width: 120,
                          height: 120,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFEDEDED),
                          ),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          width: 120,
                          height: 120,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFEDEDED),
                          ),
                          child: const Icon(Icons.person, size: 54),
                        ),
                      ),
                    )
                  else
                    Container(
                      width: 120,
                      height: 120,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFEDEDED),
                      ),
                      child: const Icon(Icons.person, size: 54, color: Color(0xFF8E8E8E)),
                    ),
                  // Edit Button
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF2B7FD0),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 12),
          const Text(
            'Tap to change profile photo',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF8A8A8A),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    Get.delete<EditBasicProfileController>();
    super.dispose();
  }
}
