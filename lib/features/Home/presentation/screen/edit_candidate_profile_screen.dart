import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../core/common/widgets/app_scaffold.dart';
import '../controllers/edit_candidate_profile_controller.dart';
import '../widgets/edit_profile/edit_awards_form_section.dart';
import '../widgets/edit_profile/edit_education_form_section.dart';
import '../widgets/edit_profile/edit_experience_form_section.dart';
import '../widgets/edit_profile/searchable_dropdown.dart';

class EditCandidateProfileScreen extends StatelessWidget {
  const EditCandidateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject Controller
    final controller = Get.put(EditCandidateProfileController());
    final theme = Theme.of(context);

    return AppScaffold(
      removePadding: true,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             _buildSectionTitle('Profile Images'),
             const SizedBox(height: 16),
             _buildImagesSection(controller),
             
             const SizedBox(height: 54),
             _buildSectionTitle('Personal Information'),
             const SizedBox(height: 16),
             _buildPersonalInfoSection(controller),

             const SizedBox(height: 24),
             _buildSectionTitle('About Me'),
             const SizedBox(height: 16),
             _buildAboutMeSection(controller),

             const SizedBox(height: 24),
             _buildSectionTitle('Social Links'),
             const SizedBox(height: 16),
             _buildSocialLinksSection(controller),

             const SizedBox(height: 24),
             _buildSectionTitle('Skills & Expertise'),
             const SizedBox(height: 16),
             _buildSkillsSection(controller),

             const SizedBox(height: 24),
             _buildSectionTitle('Languages'),
             const SizedBox(height: 16),
             _buildLanguagesSection(controller),

             const SizedBox(height: 24),
             _buildSectionTitle('Certifications'),
             const SizedBox(height: 16),
             _buildCertificationsSection(controller),

             const SizedBox(height: 24),
             _buildSectionTitle('Experience'),
             const SizedBox(height: 16),
             Obx(() => ListView.separated(
               shrinkWrap: true,
               physics: const NeverScrollableScrollPhysics(),
               itemCount: controller.experienceList.length,
               separatorBuilder: (ctx, i) => const Divider(height: 32, thickness: 1),
               itemBuilder: (ctx, i) => EditExperienceFormSection(index: i),
             )),
             const SizedBox(height: 16),
             _buildAddButton('Add Experience', controller.addExperience),

             const SizedBox(height: 24),
             _buildSectionTitle('Education'),
             const SizedBox(height: 16),
             Obx(() => ListView.separated(
               shrinkWrap: true,
               physics: const NeverScrollableScrollPhysics(),
               itemCount: controller.educationList.length,
               separatorBuilder: (ctx, i) => const Divider(height: 32, thickness: 1),
               itemBuilder: (ctx, i) => EditEducationFormSection(index: i),
             )),
             const SizedBox(height: 16),
             _buildAddButton('Add Education', controller.addEducation),

             const SizedBox(height: 24),
             _buildSectionTitle('Awards & Honors'),
             const SizedBox(height: 16),
             Obx(() => ListView.separated(
               shrinkWrap: true,
               physics: const NeverScrollableScrollPhysics(),
               itemCount: controller.awardsList.length,
               separatorBuilder: (ctx, i) => const Divider(height: 32, thickness: 1),
               itemBuilder: (ctx, i) => EditAwardsFormSection(index: i),
             )),
             const SizedBox(height: 16),
             _buildAddButton('Add Award', controller.addAward),

             const SizedBox(height: 40),
             SizedBox(
               width: double.infinity,
               height: 50,
               child: Obx(() => ElevatedButton(
                 onPressed: controller.isUpdating.value 
                    ? null 
                    : controller.updateProfile,
                 style: ElevatedButton.styleFrom(
                   backgroundColor: theme.primaryColor,
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                 ),
                 child: controller.isUpdating.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Update Profile', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
               )),
             ),
             const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildImagesSection(EditCandidateProfileController controller) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // Banner Image
        GestureDetector(
          onTap: controller.pickBanner,
          child: Obx(() {
            ImageProvider? image;
            if (controller.bannerPath.value != null) {
              image = FileImage(File(controller.bannerPath.value!));
            } else if (controller.networkBannerUrl.value != null && controller.networkBannerUrl.value!.isNotEmpty) {
              image = NetworkImage(controller.networkBannerUrl.value!);
            }

            return Container(
              height: 150, // Adjusted height for banner
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
                image: image != null ? DecorationImage(image: image, fit: BoxFit.cover) : null,
              ),
              child: image == null
                  ? const Center(child: Icon(Icons.add_a_photo, color: Colors.grey, size: 40))
                  : Stack(
                      children: [
                        Positioned(
                          right: 12,
                          top: 12,
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.edit, size: 20, color: Colors.black54),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.delete, size: 20, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            );
          }),
        ),

        // Profile Image (Overlapping Banner)
        Positioned(
          bottom: -60, // Push it down to overlap
          child: GestureDetector(
            onTap: controller.pickPhoto,
            child: Obx(() {
              ImageProvider? image;
              if (controller.photoPath.value != null) {
                image = FileImage(File(controller.photoPath.value!));
              } else if (controller.networkPhotoUrl.value != null && controller.networkPhotoUrl.value!.isNotEmpty) {
                image = NetworkImage(controller.networkPhotoUrl.value!);
              }

              return Container(
                height: 160,
                width: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade400,
                  border: Border.all(color: Colors.white, width: 4),
                  image: image != null ? DecorationImage(image: image, fit: BoxFit.cover) : null,
                ),
                child: Stack(
                  children: [
                    if (image == null)
                       const Center(child: Icon(Icons.person, size: 80, color: Colors.white)),
                    
                    // Icons Top Right
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.edit, size: 16, color: Colors.black54),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.delete, size: 16, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),

                    // "Click to change" Overlay
                    // Positioned(
                    //   bottom: 20,
                    //   left: 0,
                    //   right: 0,
                    //   child: Container(
                    //      margin: const EdgeInsets.symmetric(horizontal: 24),
                    //      padding: const EdgeInsets.symmetric(vertical: 4),
                    //      decoration: BoxDecoration(
                    //        color: Colors.black.withOpacity(0.6),
                    //        borderRadius: BorderRadius.circular(4),
                    //      ),
                    //      child: const Text(
                    //        'Click to change',
                    //        textAlign: TextAlign.center,
                    //        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    //      ),
                    //   ),
                    // ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoSection(EditCandidateProfileController controller) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildTextField('First Name', controller.firstNameController)),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField('Last Name', controller.surnameController)),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField('Email', controller.emailController),
        const SizedBox(height: 16),
        Obx(() => SearchableDropdown(
          hint: 'Select Country',
          items: controller.countries.toList(),
          value: controller.selectedCountry.value,
          onChanged: controller.onCountryChanged,
        )),
        const SizedBox(height: 16),
        Obx(() => SearchableDropdown(
          hint: 'Select City',
          items: controller.cities.toList(),
          value: controller.selectedCity.value,
          onChanged: (val) => controller.selectedCity.value = val,
        )),
        const SizedBox(height: 16),
        Obx(() => CheckboxListTile(
          title: const Text('Immediately Available'),
          value: controller.immediatelyAvailable.value,
          onChanged: (val) => controller.immediatelyAvailable.value = val ?? false,
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        )),
      ],
    );
  }

  Widget _buildAboutMeSection(EditCandidateProfileController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('About Me', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        const SizedBox(height: 6),
        TextField(
          controller: TextEditingController(
            text: controller.aboutMeQuillController.document.toPlainText(),
          ),
          maxLines: 6,
          decoration: InputDecoration(
            hintText: 'Tell us about yourself...',
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.all(12),
          ),
          onChanged: (text) {
            // Update quill document
            controller.aboutMeQuillController.document = Document()..insert(0, text);
          },
        ),
      ],
    );
  }

  Widget _buildSocialLinksSection(EditCandidateProfileController controller) {
    return Column(
      children: [
        _buildSocialField('LinkedIn', FontAwesomeIcons.linkedin, controller.linkedinController),
        const SizedBox(height: 12),
        _buildSocialField('Twitter', FontAwesomeIcons.twitter, controller.twitterController),
        const SizedBox(height: 12),
        _buildSocialField('Facebook', FontAwesomeIcons.facebook, controller.facebookController),
        const SizedBox(height: 12),
        _buildSocialField('Instagram', FontAwesomeIcons.instagram, controller.instagramController),
        const SizedBox(height: 12),
        _buildSocialField('Upwork', FontAwesomeIcons.upwork, controller.upworkController),
      ],
    );
  }

  Widget _buildTagsSection(String hint, List<String> tags, Function(String) onAdd, Function(String) onRemove) {
    final textCtrl = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: textCtrl,
                decoration: InputDecoration(
                  hintText: hint,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                ),
                onSubmitted: (val) {
                  if(val.isNotEmpty) {
                    onAdd(val);
                    textCtrl.clear();
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {
                if(textCtrl.text.isNotEmpty) {
                  onAdd(textCtrl.text);
                  textCtrl.clear();
                }
              }, 
              icon: const Icon(Icons.add_circle, color: Colors.blue)
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags.map((tag) => Chip(
            label: Text(tag),
            onDeleted: () => onRemove(tag),
            backgroundColor: Colors.blue.shade50,
            deleteIconColor: Colors.red,
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildSkillsSection(EditCandidateProfileController controller) {
    return Obx(() => _buildApiTagsSection(
      hint: 'Select a skill',
      options: controller.availableSkills.toList(),
      tags: controller.skillsList.toList(),
      onSelectedAdd: (value) => controller.addSkill(value),
      onRemove: controller.removeSkill,
      emptyMessage: 'No skill options available from API',
    ));
  }
  
  Widget _buildLanguagesSection(EditCandidateProfileController controller) {
    return Obx(() => _buildApiTagsSection(
      hint: 'Select a language',
      options: controller.availableLanguages.toList(),
      tags: controller.languages.toList(),
      onSelectedAdd: (value) => controller.addLanguage(value),
      onRemove: controller.removeLanguage,
      emptyMessage: 'No language options available from API',
    ));
  }

  Widget _buildCertificationsSection(EditCandidateProfileController controller) {
    return Obx(() => _buildTagsSection('Add a certification', controller.certifications, controller.addCertification, controller.removeCertification));
  }

  Widget _buildApiTagsSection({
    required String hint,
    required List<String> options,
    required List<String> tags,
    required Function(String) onSelectedAdd,
    required Function(String) onRemove,
    required String emptyMessage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: SearchableDropdown(
                hint: hint,
                items: options,
                value: null,
                onChanged: (value) {
                  if (value != null && value.trim().isNotEmpty) {
                    onSelectedAdd(value.trim());
                  }
                },
              ),
            ),
          ],
        ),
        if (options.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              emptyMessage,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags
              .map(
                (tag) => Chip(
                  label: Text(tag),
                  onDeleted: () => onRemove(tag),
                  backgroundColor: Colors.blue.shade50,
                  deleteIconColor: Colors.red,
                ),
              )
              .toList(),
        ),
      ],
    );
  }


  Widget _buildTextField(String label, TextEditingController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: 'Enter $label',
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialField(String label, IconData icon, TextEditingController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 18),
            border: const OutlineInputBorder(),
            hintText: 'Enter $label URL',
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton(String label, VoidCallback onPressed) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.add),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.blue,
        side: const BorderSide(color: Colors.blue),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
