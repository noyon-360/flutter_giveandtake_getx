import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

import '../../../../core/services/media_crop_service.dart';

class CompanyImageController extends GetxController {
  Rx<File?> selectedImage = Rx<File?>(null);
  RxString existingImageUrl = ''.obs;
  final MediaCropService _mediaCropService = Get.find<MediaCropService>();

  Future<void> pickImage(ImageSource source) async {
    final croppedFile = await _mediaCropService.pickAndCropImage(
      source: source,
      preset: MediaCropPreset.banner,
    );

    if (croppedFile != null) {
      selectedImage.value = croppedFile;
      existingImageUrl.value = '';
    }
  }

  void showPickerOptions() {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Get.back();
                pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Camera'),
              onTap: () {
                Get.back();
                pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }
}
