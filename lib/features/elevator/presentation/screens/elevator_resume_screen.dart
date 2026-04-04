import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/common/widgets/app_scaffold.dart';
import '../../../Home/presentation/screen/home_screen.dart';
import '../controller/elevator_resume_controller.dart';
import '../widgets/awards_form_section.dart';
import '../widgets/education_form_section.dart';
import '../widgets/experience_form_section.dart';
import '../widgets/photo_bio_section.dart';
import '../widgets/skills_section.dart';

class ElevatorResumeScreen extends StatelessWidget {
  const ElevatorResumeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Delete previous instance and create fresh controller each time
    Get.delete<ElevatorResumeController>(force: true);
    final controller = Get.put(ElevatorResumeController());
    final theme = Theme.of(context);

    return AppScaffold(
      removePadding: true,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
         
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Get.to(()=>const HomeScreen()); // since you're using GetX
          },
        ),
         backgroundColor: Color(0xFF2B7FD0),
        title: const Text(
          'Create Your Profile',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===================== TITLE + SUBTITLE =====================
              Center(
                child: Text(
                  'Fill in your details to create a professional resume',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ===================== VIDEO + BANNER =====================
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ---------- Upload Video Pitch ----------
                  Obx(() {
                    final hasVideo =
                        controller.elevatorVideoPath.value.isNotEmpty;
                    final isUploaded = controller.isVideoUploaded.value;

                    if (!hasVideo) {
                      // Show upload area when no video selected
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0E1726),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: DottedBorder(
                          color: const Color(0xFF2C3A4F),
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(12),
                          dashPattern: const [6, 4],
                          strokeWidth: 1.2,
                          child: InkWell(
                            onTap: controller.pickElevatorVideo,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF2563EB),
                                    ),
                                    child: const Icon(
                                      Icons.file_upload_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Upload Your Video Pitch',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Drop your video here or click to browse',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: controller.pickElevatorVideo,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF2563EB),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                      ),
                                    ),
                                    child: const Text(
                                      'Choose Video File',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    // Show video preview with controls when video is selected
                    return Column(
                      children: [
                        // Video player widget
                        GestureDetector(
                          onTap: controller.pickElevatorVideo,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: const Color(0xFF191919),
                            ),
                            height: 250,
                            width: double.infinity,
                            child: controller.isVideoInitialized.value
                                ? Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: AspectRatio(
                                          aspectRatio: controller
                                              .videoPlayerController!
                                              .value
                                              .aspectRatio,
                                          child: VideoPlayer(
                                            controller.videoPlayerController!,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: controller.togglePlayPause,
                                        child: AnimatedOpacity(
                                          opacity: controller.isPlaying.value
                                              ? 0.0
                                              : 1.0,
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          child: Icon(
                                            controller.isPlaying.value
                                                ? Icons.pause_circle_filled
                                                : Icons.play_circle_fill,
                                            color: Colors.white,
                                            size: 70,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 0,
                                            vertical: 0,
                                          ),
                                          decoration: const BoxDecoration(
                                            color: Colors.black26,
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(6),
                                              bottomRight: Radius.circular(6),
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Obx(() {
                                                final progress =
                                                    controller
                                                            .totalDuration
                                                            .value
                                                            .inMilliseconds ==
                                                        0
                                                    ? 0.0
                                                    : controller
                                                              .currentPosition
                                                              .value
                                                              .inMilliseconds /
                                                          controller
                                                              .totalDuration
                                                              .value
                                                              .inMilliseconds;
                                                return Slider(
                                                  value: progress.clamp(
                                                    0.0,
                                                    1.0,
                                                  ),
                                                  onChanged: (value) {
                                                    final newPosition = Duration(
                                                      milliseconds:
                                                          (controller
                                                                      .totalDuration
                                                                      .value
                                                                      .inMilliseconds *
                                                                  value)
                                                              .toInt(),
                                                    );
                                                    controller.seekTo(
                                                      newPosition,
                                                    );
                                                  },
                                                  activeColor: Colors.white,
                                                  inactiveColor: Colors.grey,
                                                );
                                              }),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 8,
                                                    ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      controller.formatDuration(
                                                        controller
                                                            .currentPosition
                                                            .value,
                                                      ),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    Text(
                                                      controller.formatDuration(
                                                        controller
                                                            .totalDuration
                                                            .value,
                                                      ),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Upload button (show only if not uploaded)
                        if (!isUploaded)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: controller.uploadElevatorVideo,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Upload Elevator Pitch',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        // Success message and delete button (show only if uploaded)
                        if (isUploaded) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green.shade700,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Elevator pitch uploaded successfully. We\'re processing your video. Feel free to submit your resume while it finalizes.',
                                    style: TextStyle(
                                      color: Colors.green.shade900,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          OutlinedButton.icon(
                            onPressed: controller.deleteElevatorVideo,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            icon: const Icon(Icons.delete_outline, size: 18),
                            label: const Text('Delete Video'),
                          ),
                        ],
                      ],
                    );
                  }),

                  const SizedBox(height: 16),

                  // ---------- Banner upload (light dashed card) ----------
                  Obx(() {
                    final hasBanner = controller.bannerImagePath.value != null;

                    if (!hasBanner) {
                      // Show upload area when no banner selected
                      return DottedBorder(
                        color: Colors.grey.shade400,
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(12),
                        dashPattern: const [6, 4],
                        strokeWidth: 1,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 24,
                            horizontal: 12,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.cloud_upload_outlined,
                                size: 32,
                                color: Colors.grey.shade500,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Drop your banner image here',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey.shade800,
                                ),
                              ),
                              const SizedBox(height: 12),
                              OutlinedButton(
                                onPressed: controller.pickBannerImage,
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Choose Image',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Supports JPG, PNG · Max 10MB · Cropped to 1584×396 px',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // Show banner preview when selected
                    return Column(
                      children: [
                        // Banner Image Preview
                        Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(controller.bannerImagePath.value!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Change Banner Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: controller.pickBannerImage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade200,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            icon: const Icon(Icons.edit_outlined),
                            label: const Text('Change Banner Image'),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),

              const SizedBox(height: 16),

              // ===================== PROFILE PHOTO + ABOUT ME =====================
              _SectionCard(child: const PhotoBioSection()),

              const SizedBox(height: 24),

              // ===================== PERSONAL INFO =====================
              Text(
                'Personal Information',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // First Name
                  Text('First Name*'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: controller.firstNameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your first name',
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Surname
                  Text('Surname*'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: controller.surnameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your surname',
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Country
                  const Text('Country*'),
                  const SizedBox(height: 6),
                  Obx(
                    () => SearchableDropdown(
                      hint: 'Select Country',
                      items: controller.countries.toList(),
                      value: controller.selectedCountry.value,
                      onChanged: (value) {
                        controller.selectedCountry.value = value;
                        controller.onCountryChanged(value);
                      },
                    ),
                  ),
                  const SizedBox(height: 12),

                  // City
                  const Text('City*'),
                  const SizedBox(height: 6),
                  Obx(
                    () => SearchableDropdown(
                      hint: 'Select City',
                      items: controller.cities.toList(),
                      value: controller.selectedCity.value,
                      onChanged: (value) {
                        controller.selectedCity.value = value;
                      },
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Email (disabled style like screenshot)
                  Text('Email Address*'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: controller.emailController,
                    enabled: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Enter your email',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Immediately Available checkbox
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => Checkbox(
                          value: controller.immediatelyAvailable.value,
                          onChanged: (value) {
                            controller.immediatelyAvailable.value =
                                value ?? false;
                          },
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Immediately Available'),
                            const SizedBox(height: 2),
                            Text(
                              'Check if you are available to start immediately',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ===================== PROFESSIONAL LINKS =====================
              _SectionCard(
                title: 'Professional Social Media and Website Links',
                child: Column(
                  children: [
                    TextFormField(
                      controller: controller.linkedinController,
                      keyboardType: TextInputType.url,
                      decoration: const InputDecoration(
                        labelText: 'LinkedIn URL',
                        hintText: 'https://www.linkedin.com/your-profile',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: controller.twitterController,
                      keyboardType: TextInputType.url,
                      decoration: const InputDecoration(
                        labelText: 'Twitter URL',
                        hintText: 'https://www.twitter.com/your-profile',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: controller.facebookController,
                      keyboardType: TextInputType.url,
                      decoration: const InputDecoration(
                        labelText: 'Facebook URL',
                        hintText: 'https://facebook.com/your-profile',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: controller.tiktokController,
                      keyboardType: TextInputType.url,
                      decoration: const InputDecoration(
                        labelText: 'TikTok URL',
                        hintText: 'https://www.tiktok.com/@your-handle',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: controller.instagramController,
                      keyboardType: TextInputType.url,
                      decoration: const InputDecoration(
                        labelText: 'Instagram URL',
                        hintText: 'https://www.instagram.com/your-profile',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: controller.upworkController,
                      keyboardType: TextInputType.url,
                      decoration: const InputDecoration(
                        labelText: 'Upwork URL',
                        hintText: 'https://www.upwork.com/your-profile',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: controller.fiverrController,
                      keyboardType: TextInputType.url,
                      decoration: const InputDecoration(
                        labelText: 'Fiverr URL',
                        hintText: 'https://www.fiverr.com/your-username',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: controller.portfolioController,
                      keyboardType: TextInputType.url,
                      decoration: const InputDecoration(
                        labelText: 'Portfolio Website URL',
                        hintText: 'https://your-website.com',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ===================== SKILLS =====================
              Text(
                'Skills',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Showcase your strengths and what sets you apart.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 12),
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [SkillsSection()],
                ),
              ),

              const SizedBox(height: 24),

              // ===================== WORK EXPERIENCE =====================
              Text(
                'Work Experience',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),

              Obx(() {
                if (controller.experienceList.isEmpty) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: controller.addExperience,
                      child: const Text('Add'),
                    ),
                  );
                }

                return Column(
                  children: [
                    ...List.generate(
                      controller.experienceList.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: _SectionCard(
                          child: ExperienceFormSection(index: index),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: controller.addExperience,
                        child: const Text('Add'),
                      ),
                    ),
                  ],
                );
              }),

              const SizedBox(height: 24),

              // ===================== EDUCATION =====================
              Text(
                'Education*',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              _SectionCard(
                child: Obx(
                  () => Column(
                    children: [
                      ...List.generate(
                        controller.educationList.length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: EducationFormSection(index: index),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: controller.addEducation,
                          child: const Text('Add'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ===================== CERTIFICATIONS =====================
              _SectionCard(
                title: 'Certifications',
                subtitle:
                    'List your professional certifications and credentials.',
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add Certification',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: TextField(
                                controller: controller
                                    .certificationController, // Assuming controller has this or similar
                                decoration: InputDecoration(
                                  hintText:
                                      'e.g. AWS Certified Solutions Architect',
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 14,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            height: 48,
                            child: OutlinedButton(
                              onPressed: () {
                                if (controller
                                    .certificationController
                                    .text
                                    .isNotEmpty) {
                                  controller.addCertification();
                                  // ensure controller clears text or handled inside
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.grey.shade300),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                foregroundColor: Colors.black,
                              ),
                              child: const Text('Add'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (controller.certifications.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'No certifications added yet. Add your professional certifications above.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: controller.certifications
                                .map(
                                  (cert) => Chip(
                                    label: Text(cert),
                                    onDeleted: () =>
                                        controller.removeCertification(cert),
                                    backgroundColor: Colors.grey[100],
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ===================== LANGUAGES =====================
              _SectionCard(
                title: 'Languages',
                subtitle: 'List the languages you speak.',
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add Language',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: SearchableDropdown(
                              hint: 'Select a language',
                              items: controller.availableLanguages.toList(),
                              value: null,
                              onChanged: (value) {
                                if (value != null &&
                                    !controller.languages.contains(value)) {
                                  controller.addLanguage(value);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      controller.languages.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'No languages selected. Select from the dropdown above.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            )
                          : Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: controller.languages
                                  .map(
                                    (lang) => Chip(
                                      label: Text(lang),
                                      onDeleted: () =>
                                          controller.removeLanguage(lang),
                                    ),
                                  )
                                  .toList(),
                            ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ===================== AWARDS & HONORS =====================
              _SectionCard(
                title: 'Awards & Honors',
                subtitle: 'Highlight your achievements and recognitions.',
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...List.generate(
                        controller.awardsList.length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: AwardsFormSection(index: index),
                        ),
                      ),
                      TextButton(
                        onPressed: controller.addAward,
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ===================== SUBMIT BUTTON =====================
              Obx(() {
                final isUploading = controller.isUploadingResume.value;

                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isUploading
                        ? null
                        : controller.onUploadElevatorPitchFirst,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 52),
                      backgroundColor: isUploading ? Colors.grey : null,
                    ),
                    child: isUploading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.grey,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Text('Uploading resume...'),
                            ],
                          )
                        : const Text('Upload Resume'),
                  ),
                );
              }),
              const SizedBox(height: 8),
              // Obx(() {
              //   final hasVideo = controller.elevatorVideoPath.value.isNotEmpty;
              //   return Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Row(
              //         children: [
              //           Icon(
              //             hasVideo ? Icons.check_circle : Icons.info,
              //             color: hasVideo ? Colors.green : Colors.orange,
              //             size: 16,
              //           ),
              //           const SizedBox(width: 8),
              //           Expanded(
              //             child: Text(
              //               hasVideo
              //                   ? 'Elevator pitch video uploaded. You can now submit your resume.'
              //                   : 'Elevator pitch video upload is optional but recommended.',
              //               style: theme.textTheme.bodySmall?.copyWith(
              //                 color: hasVideo ? Colors.green : Colors.orange,
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ],
              //   );
              // }),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

/// Generic white rounded card
class _SectionCard extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget child;

  const _SectionCard({this.title, this.subtitle, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
            const SizedBox(height: 12),
          ],
          child,
        ],
      ),
    );
  }
}

/// Custom searchable dropdown with filter
class SearchableDropdown extends StatefulWidget {
  final String hint;
  final List<String> items;
  final String? value;
  final Function(String?) onChanged;
  final double maxHeight;

  const SearchableDropdown({
    required this.hint,
    required this.items,
    required this.value,
    required this.onChanged,
    this.maxHeight = 200,
  });

  @override
  State<SearchableDropdown> createState() => _SearchableDropdownState();
}

class _SearchableDropdownState extends State<SearchableDropdown> {
  late TextEditingController _searchController;
  late List<String> _filteredItems;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredItems = widget.items;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showSearchDialog();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.value ?? widget.hint,
                style: TextStyle(
                  color: widget.value == null ? Colors.grey : Colors.black,
                ),
              ),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog() {
    _searchController.clear();
    _filteredItems = widget.items;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Search'),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Search TextField
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search ${widget.hint.toLowerCase()}...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (query) {
                      setState(() {
                        if (query.isEmpty) {
                          _filteredItems = widget.items;
                        } else {
                          _filteredItems = widget.items
                              .where(
                                (item) => item.toLowerCase().contains(
                                  query.toLowerCase(),
                                ),
                              )
                              .toList();
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  // Filtered List
                  Expanded(
                    child: _filteredItems.isEmpty
                        ? Center(
                            child: Text(
                              'No results found',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = _filteredItems[index];
                              return ListTile(
                                title: Text(item),
                                onTap: () {
                                  widget.onChanged(item);
                                  Navigator.pop(context);
                                },
                                selected: widget.value == item,
                                selectedTileColor: Colors.blue.shade100,
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          );
        },
      ),
    );
  }
}
