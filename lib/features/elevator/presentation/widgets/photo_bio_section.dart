import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/elevator_resume_controller.dart';

class PhotoBioSection extends StatelessWidget {
  const PhotoBioSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ElevatorResumeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              return GestureDetector(
                onTap: controller.pickPhoto,
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[300],
                  child: controller.photoPath.value != null
                      ? Image.file(
                          File(controller.photoPath.value!),
                          fit: BoxFit.cover,
                        )
                      : Icon(
                          Icons.add_a_photo,
                          size: 40,
                          color: Colors.grey[600],
                        ),
                ),
              );
            }),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Write Your Bio'),
                  SizedBox(height: 8),
                  TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Here',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Upload Your Photo'),
      ],
    );
  }
}
