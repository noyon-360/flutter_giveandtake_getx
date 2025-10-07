import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/experience_controller.dart';


class ExperienceDropdown extends StatelessWidget {
  ExperienceDropdown({super.key});
  final ExperienceController controller = Get.put(ExperienceController());

  final List<String> experiences = [
    "0-1 years",
    "2-5 years",
    "6-10 years",
    "10+ years",
  ];


  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DropdownButtonFormField<String>(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFF999999)
            ),
            borderRadius: BorderRadius.circular(8),
          ),

          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Color(0xFF999999)
            ),
            borderRadius: BorderRadius.circular(8),
          ),

          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.black
            ),
            borderRadius: BorderRadius.circular(8),
          )
        ),
        hint: Text("Select Experience"),
        value: controller.selectedExperience.value.isEmpty
            ? null
            : controller.selectedExperience.value,
        onChanged: (newValue) {
          controller.selectedExperience.value = newValue ?? '';
        },
        items: experiences.map((experience) {
          return DropdownMenuItem(
            value: experience,
            child: Text(experience),
          );
        }).toList(),
      );
    });
  }
}
