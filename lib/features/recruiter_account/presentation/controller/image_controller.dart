import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class ImageController extends GetxController {
  Rx<File?> selectedImage = Rx<File?>(null);
  RxString existingImageUrl = ''.obs;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source, imageQuality: 80);

    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
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
