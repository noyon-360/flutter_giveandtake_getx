import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/widgets/app_scaffold.dart';
import '../controller/elevator_resume_controller.dart';
import '../widgets/video_upload_section.dart';
import '../widgets/photo_bio_section.dart';
import '../widgets/experience_form_section.dart';
import '../widgets/education_form_section.dart';
import '../widgets/awards_form_section.dart';
import '../widgets/skills_section.dart';


class ElevatorResumeScreen extends StatelessWidget {
  const ElevatorResumeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ElevatorResumeController());
    final theme = Theme.of(context);

    return AppScaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: const Text('Create Your Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
          const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Big title + subtitle
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Create Your Profile',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  'Fill in your details to create a professional resume',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[900],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ===================== VIDEO + BANNER =====================


                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ---------- Upload Video Pitch (dark card) ----------
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0E1726),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DottedBorder(
                        color: const Color(0xFF2C3A4F),
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(8),
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
                                // blue circular icon
                                Container(
                                  width: 55,
                                  height: 55,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF223663),
                                  ),
                                  child: const Icon(
                                    size: 40,
                                    Icons.file_upload_outlined,
                                    color: Colors.blueAccent,
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
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text('Choose Video File',style: TextStyle(
                                    color: Colors.white
                                  ),),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ---------- Banner upload (light dashed card) ----------
                    DottedBorder(
                      color: Colors.grey.shade400,
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(8),
                      dashPattern: const [6, 4],
                      strokeWidth: 1,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.file_upload_outlined,
                              size: 50,
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
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('Choose Image',style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800
                              ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Supports JPG, PNG · Max 10MB · Cropped to 1584×396 px',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Color(0xFF7a808c),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 16),

              // ===================== PROFILE PHOTO + ABOUT ME =====================

              _SectionCard(
                title: 'Profile photo',
                child: const PhotoBioSection(),
              ),

              const SizedBox(height: 24),


              // ===================== PERSONAL INFO =====================

              Text(
                'Personal Information',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),


                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // First & Surname (top of the section)
                    _LabeledTextField(
                      label: 'First Name*',
                      hint: 'Enter your first name',
                    ),
                    SizedBox(height: 12),
                    _LabeledTextField(
                      label: 'Surname*',
                      hint: 'Enter your surname',
                    ),
                    const SizedBox(height: 16),


                    // Country
                    const Text('Country*'),
                    const SizedBox(height: 6),
                    Obx(
                          () => DropdownButtonFormField<String>(
                        isExpanded: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        value: controller.selectedCountry.value,
                        hint: const Text('Select Country'),
                        items: controller.countries
                            .map(
                              (country) => DropdownMenuItem(
                            value: country,
                            child: Text(country),
                          ),
                        )
                            .toList(),
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
                          () => DropdownButtonFormField<String>(
                        isExpanded: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        value: controller.selectedCity.value,
                        hint: const Text('Select City'),
                        items: controller.cities
                            .map(
                              (city) => DropdownMenuItem(
                            value: city,
                            child: Text(city),
                          ),
                        )
                            .toList(),
                        onChanged: (value) {
                          controller.selectedCity.value = value;
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    const _LabeledTextField(
                      label: 'Email Address*',
                      hint: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),

                    // Immediately Available checkbox
                    Row(
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
                  children: const [
                    _LabeledTextField(
                      label: 'LinkedIn URL',
                      hint: 'https://www.linkedin.com/your-profile',
                    ),
                    SizedBox(height: 12),
                    _LabeledTextField(
                      label: 'Twitter URL',
                      hint: 'https://www.twitter.com/your-profile',
                    ),
                    SizedBox(height: 12),
                    _LabeledTextField(
                      label: 'Facebook URL',
                      hint: 'https://facebook.com/your-profile',
                    ),
                    SizedBox(height: 12),
                    _LabeledTextField(
                      label: 'TikTok URL',
                      hint: 'https://www.tiktok.com/@your-handle',
                    ),
                    SizedBox(height: 12),
                    _LabeledTextField(
                      label: 'Instagram URL',
                      hint: 'https://www.instagram.com/your-profile',
                    ),
                    SizedBox(height: 12),
                    _LabeledTextField(
                      label: 'Upwork URL',
                      hint: 'https://www.upwork.com/your-profile',
                    ),
                    SizedBox(height: 12),
                    _LabeledTextField(
                      label: 'Fiverr URL',
                      hint: 'https://www.fiverr.com/your-username',
                    ),
                    SizedBox(height: 12),
                    _LabeledTextField(
                      label: 'Portfolio Website URL',
                      hint: 'https://your-website.com',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ===================== SKILLS =====================

              _SectionCard(child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              const SizedBox(height: 12),
              Text(
                'Skills',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                'Showcase your strengths and what sets you apart.',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: Colors.grey[700]),
              ),
              const SizedBox(height: 12),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SkillsSection(),
                  ],
                ),
                ]
              )
              ),

              const SizedBox(height: 24),

              // ===================== WORK EXPERIENCE =====================

              Text(
                'Work Experience',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              _SectionCard(
                child: Obx(
                      () => Column(
                    children: [
                      if (controller.experienceList.isEmpty)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Add your work experience details.',
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ),
                      ...List.generate(
                        controller.experienceList.length,
                            (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: ExperienceFormSection(index: index),
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
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ===================== EDUCATION =====================

              Text(
                'Education*',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
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
                      Row(
                        children: [
                          const Expanded(
                            child: _LabeledTextField(
                              label: 'Add Certification',
                              hint: 'e.g. AWS Certified Solutions Architect',
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: controller.addCertification,
                            child: const Text('Add'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (controller.certifications.isEmpty)
                        Text(
                          'No certifications added yet. Add your professional certifications above.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        )
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: controller.certifications
                              .map(
                                (cert) => Padding(
                              padding:
                              const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text('• $cert'),
                            ),
                          )
                              .toList(),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _LabeledTextField(
                      label: 'Add Language',
                      hint: 'Search and add languages (e.g., English)',
                    ),
                    const SizedBox(height: 8),
                    Obx(
                          () => controller.languages.isEmpty
                          ? Text(
                        'No languages selected. Start typing to search and add languages.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
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
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ===================== AWARDS & HONORS =====================

              _SectionCard(
                title: 'Awards & Honors',
                subtitle:
                'Highlight your achievements and recognitions.',
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

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.onUploadElevatorPitchFirst,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                  ),
                  child: const Text('Upload Elevator Pitch First'),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please upload your Elevator Video Pitch© video before submitting the form.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

/// Generic white rounded card used for each section
class _SectionCard extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget child;

  const _SectionCard({
    this.title,
    this.subtitle,
    required this.child,
  });

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
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: Colors.grey[600]),
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

/// Simple labeled TextField
class _LabeledTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextInputType? keyboardType;
  final bool enabled;
  final String? initialValue;

  const _LabeledTextField({
    required this.label,
    this.hint,
    this.keyboardType,
    this.enabled = true,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      enabled: enabled,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        filled: !enabled,
        fillColor: !enabled ? Colors.grey.shade100 : null,
      ),
    );
  }
}
