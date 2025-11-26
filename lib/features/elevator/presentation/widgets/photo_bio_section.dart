import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------- TOOLBAR ----------
              SizedBox(
                height: 44,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const SizedBox(width: 8),

                      // Heading dropdown
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          switch (value) {
                            case 'Heading 1':
                              controller.aboutMeQuillController
                                  .formatSelection(quill.Attribute.h1);
                              break;
                            case 'Heading 2':
                              controller.aboutMeQuillController
                                  .formatSelection(quill.Attribute.h2);
                              break;
                            case 'Heading 3':
                              controller.aboutMeQuillController
                                  .formatSelection(quill.Attribute.h3);
                              break;
                            default:
                            // Current quill version-e header.unset nai, tai just normal header apply korchi
                              controller.aboutMeQuillController
                                  .formatSelection(quill.Attribute.header);

                          }
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(
                            value: 'Heading 1',
                            child: Text(
                              'Heading 1',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            value: 'Heading 2',
                            child: Text(
                              'Heading 2',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            value: 'Heading 3',
                            child: Text(
                              'Heading 3',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            value: 'Normal',
                            child: Text('Normal'),
                          ),
                        ],
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: const [
                              Text('Normal'),
                              SizedBox(width: 4),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),
                      SizedBox(
                        height: 24,
                        child: const VerticalDivider(width: 1),
                      ),
                      const SizedBox(width: 4),

                      _ToolbarIcon(
                        icon: Icons.format_align_left,
                        onTap: () => controller.aboutMeQuillController
                            .formatSelection(quill.Attribute.leftAlignment),
                      ),
                      _ToolbarIcon(
                        icon: Icons.format_align_center,
                        onTap: () => controller.aboutMeQuillController
                            .formatSelection(quill.Attribute.centerAlignment),
                      ),
                      _ToolbarIcon(
                        icon: Icons.format_align_right,
                        onTap: () => controller.aboutMeQuillController
                            .formatSelection(quill.Attribute.rightAlignment),
                      ),

                      SizedBox(
                        height: 24,
                        child: const VerticalDivider(width: 1),
                      ),

                      _ToolbarIcon(
                        icon: Icons.format_bold,
                        onTap: () => controller.aboutMeQuillController
                            .formatSelection(quill.Attribute.bold),
                      ),
                      _ToolbarIcon(
                        icon: Icons.format_italic,
                        onTap: () => controller.aboutMeQuillController
                            .formatSelection(quill.Attribute.italic),
                      ),
                      _ToolbarIcon(
                        icon: Icons.format_underlined,
                        onTap: () => controller.aboutMeQuillController
                            .formatSelection(quill.Attribute.underline),
                      ),

                      _ToolbarIcon(
                        icon: Icons.format_list_bulleted,
                        onTap: () => controller.aboutMeQuillController
                            .formatSelection(quill.Attribute.ul),
                      ),
                      _ToolbarIcon(
                        icon: Icons.format_list_numbered,
                        onTap: () => controller.aboutMeQuillController
                            .formatSelection(quill.Attribute.ol),
                      ),

                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
              const Divider(height: 1),

              // ---------- QUILL EDITOR ----------
              SizedBox(
                height: 140,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: quill.QuillEditor.basic(
                    controller: controller.aboutMeQuillController,
                    focusNode: FocusNode(),
                  ),
                ),
              ),

            ],
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

class _ToolbarIcon extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback? onTap;

  const _ToolbarIcon({
    required this.icon,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color =
    isActive ? const Color(0xFF2563EB) : Colors.grey.shade700;

    return IconButton(
      onPressed: onTap,
      splashRadius: 18,
      iconSize: 18,
      padding: const EdgeInsets.symmetric(horizontal: 2),
      icon: Icon(icon, color: color),
    );
  }
}
