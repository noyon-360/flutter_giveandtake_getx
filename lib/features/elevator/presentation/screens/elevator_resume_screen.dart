import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/elevator_resume_controller.dart';
import '../widgets/video_upload_section.dart';
import '../widgets/photo_bio_section.dart';
import '../widgets/experience_form_section.dart';
import '../widgets/education_form_section.dart';
import '../widgets/awards_form_section.dart';
import '../widgets/skills_section.dart';
import '../widgets/other_urls_section.dart';

class ElevatorResumeScreen extends StatelessWidget {
  const ElevatorResumeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ElevatorResumeController());

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
          child: Column(
            children: [
              const Text(
                'Create Your Elevator Pitch & Resume',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Video upload section
              const VideoUploadSection(),
              const SizedBox(height: 16),

              // Photo and bio section
              const PhotoBioSection(),
              const SizedBox(height: 16),

              // Personal information section
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Title*'),
                        Obx(() {
                          return DropdownButtonFormField<String>(
                            isExpanded: true,
                            initialValue: controller.selectedTitle.value,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            items: controller.titles
                                .map(
                                  (title) => DropdownMenuItem(
                                    value: title,
                                    child: Text(title),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                controller.selectedTitle.value = value;
                              }
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'First Name*',
                          hintText: 'Enter Your First Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Last Name*',
                        hintText: 'Enter Your Last Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Surname*',
                        hintText: 'Enter Your Surname',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Country*'),
                        Obx(() {
                          return DropdownButtonFormField<String>(
                            isExpanded: true,
                            initialValue: controller.selectedCountry.value,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
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
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('City*'),
                        Obx(() {
                          return DropdownButtonFormField<String>(
                            isExpanded: true,
                            initialValue: controller.selectedCity.value,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
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
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Postal Code*',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter Your Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Website URL*',
                  hintText: 'Enter Here',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'LinkedIn URL*',
                  hintText: 'Enter Here',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Twitter/X URL*',
                  hintText: 'Enter Here',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Upwork URL*',
                  hintText: 'Enter Here',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Other URLs section - dynamic
              const OtherUrlsSection(),

              const SizedBox(height: 16),

              // Skills section - dynamic with dialog
              const SkillsSection(),
              const SizedBox(height: 32),

              // Experience section with dynamic add more
              Obx(() {
                return Column(
                  children: [
                    ...List.generate(
                      controller.experienceList.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: ExperienceFormSection(index: index),
                      ),
                    ),
                    TextButton(
                      onPressed: controller.addExperience,
                      child: const Text('Add more +'),
                    ),
                  ],
                );
              }),

              const SizedBox(height: 32),

              // Education section with dynamic add more
              Obx(() {
                return Column(
                  children: [
                    ...List.generate(
                      controller.educationList.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: EducationFormSection(index: index),
                      ),
                    ),
                    TextButton(
                      onPressed: controller.addEducation,
                      child: const Text('Add more +'),
                    ),
                  ],
                );
              }),

              const SizedBox(height: 32),

              // Awards section with dynamic add more
              Obx(() {
                return Column(
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
                      child: const Text('Add more +'),
                    ),
                  ],
                );
              }),

              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: controller.saveResume,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Save'),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
