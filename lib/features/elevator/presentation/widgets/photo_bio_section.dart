import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/elevator_resume_controller.dart';

class PhotoBioSection extends StatelessWidget {
  const PhotoBioSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<ElevatorResumeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---------------- PROFILE PHOTO ----------------
        Text(
          'Profile photo',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF2563EB),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),

        AspectRatio(
          aspectRatio: 1,
          child: Obx(
                () {
              final path = controller.photoPath.value;

              return InkWell(
                onTap: controller.pickPhoto,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: path == null
                      ? _PhotoPlaceholder(theme: theme)
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(path),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 16),

        // ---------------- ABOUT ME ----------------
        Text(
          'About Me',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF2563EB),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              controller: controller.aboutMeController,
              maxLines: 6,
              minLines: 4,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Write a short bio about yourself...',
              ),
            ),
          ),
        ),

        const SizedBox(height: 4),

        Obx(
              () => Text(
            'Word count: ${controller.aboutMeWordCount.value}/200',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
        ),
      ],
    );
  }
}

class _PhotoPlaceholder extends StatelessWidget {
  final ThemeData theme;

  const _PhotoPlaceholder({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade100,
            ),
            child: Icon(
              Icons.file_upload_outlined,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Click to add photo',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'JPG/PNG · up to 10MB · cropped to\n250×250',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
