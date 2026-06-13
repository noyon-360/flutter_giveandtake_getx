import 'dart:io';

import 'package:flutter/material.dart';

class CroppedImagePickerCard extends StatelessWidget {
  const CroppedImagePickerCard({
    super.key,
    required this.onTap,
    required this.placeholderTitle,
    required this.editLabel,
    this.file,
    this.imageUrl,
    this.width = double.infinity,
    this.height = 150,
    this.borderRadius = 12,
    this.placeholderSubtitle,
    this.backgroundColor = const Color(0xFFD9D9D9),
    this.placeholderForegroundColor = const Color(0xFF344054),
  });

  final VoidCallback onTap;
  final File? file;
  final String? imageUrl;
  final double width;
  final double height;
  final double borderRadius;
  final String placeholderTitle;
  final String editLabel;
  final String? placeholderSubtitle;
  final Color backgroundColor;
  final Color placeholderForegroundColor;

  bool get _hasImage =>
      file != null || ((imageUrl ?? '').trim().isNotEmpty);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: backgroundColor,
          border: Border.all(color: const Color(0xFFD0D5DD)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: _hasImage ? _buildImageCard() : _buildPlaceholder(),
        ),
      ),
    );
  }

  Widget _buildImageCard() {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (file != null)
          Image.file(
            file!,
            fit: BoxFit.cover,
          )
        else
          Image.network(
            imageUrl!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildPlaceholder(),
          ),
        Positioned(
          top: 10,
          right: 10,
          child: _ActionChip(
            icon: Icons.edit,
            label: editLabel,
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_a_photo_outlined, color: placeholderForegroundColor),
          const SizedBox(height: 8),
          Text(
            placeholderTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: placeholderForegroundColor,
            ),
          ),
          if ((placeholderSubtitle ?? '').isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              placeholderSubtitle!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: placeholderForegroundColor.withOpacity(0.82),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
