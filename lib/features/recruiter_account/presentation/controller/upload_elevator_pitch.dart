import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class ElevatorPitchController extends GetxController {
  final picker = ImagePicker();

  var isUploading = false.obs;

  /// Pick from gallery or record a new video
  Future<void> pickAndUploadVideo() async {
    try {
      // Ask user: Pick existing or Record new
      final source = await Get.bottomSheet<ImageSource>(
        Container(
          color: Colors.white,
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.video_library),
                title: const Text('Pick from Gallery'),
                onTap: () => Get.back(result: ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.videocam),
                title: const Text('Record New Video'),
                onTap: () => Get.back(result: ImageSource.camera),
              ),
            ],
          ),
        ),
      );

      if (source == null) return; // User canceled

      final XFile? video = await picker.pickVideo(
        source: source,
        maxDuration: const Duration(seconds: 60),
      );

      if (video == null) {
        //Get.snackbar('Cancelled', 'No video selected');
        return;
      }

      //await uploadVideo(File(video.path));
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }

  // /// Upload video
  // Future<void> uploadVideo(File file) async {
  //   try {
  //     isUploading.value = true;
  //     Get.snackbar('Uploading', 'Your elevator pitch is being uploaded...');
  //
  //     // Example upload with Dio
  //     final dio = Dio();
  //     final formData = FormData.fromMap({
  //       'file': await MultipartFile.fromFile(file.path, filename: 'pitch.mp4'),
  //     });
  //
  //     final response = await dio.post(
  //       'https://your-api.com/upload', // <-- replace with your API endpoint
  //       data: formData,
  //     );
  //
  //     isUploading.value = false;
  //
  //     if (response.statusCode == 200) {
  //       Get.snackbar('Success', 'Video uploaded successfully!');
  //     } else {
  //       Get.snackbar('Upload Failed', 'Server error: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     isUploading.value = false;
  //     Get.snackbar('Upload Error', e.toString());
  //   }
  // }
}
