import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_filex/open_filex.dart';

// Future<void> downloadAndOpenPdf(String url, String fileName) async {
//   try {
//     // Request permission (Android)
//     if (Platform.isAndroid) {
//       final status = await Permission.storage.request();
//       if (!status.isGranted) {
//         throw Exception("Storage permission denied");
//       }
//     }

//     final dir = await getApplicationDocumentsDirectory();
//     final filePath = "${dir.path}/$fileName";

//     final dio = Dio();
//     await dio.download(
//       url,
//       filePath,
//       options: Options(
//         responseType: ResponseType.bytes,
//         followRedirects: true,
//         receiveTimeout: const Duration(minutes: 2),
//       ),
//     );

//     // Open the downloaded PDF
//     await OpenFilex.open(filePath);
//   } catch (e) {
//     debugPrint("PDF Download Error: $e");
//     Get.snackbar(
//       "Error",
//       "Failed to download resume",
//       snackPosition: SnackPosition.BOTTOM,
//     );
//   }
// }
Future<void> downloadAndOpenPdf(String url, String fileName) async {
  try {
    final dir = await getApplicationDocumentsDirectory();
    final filePath = "${dir.path}/$fileName";

    final dio = Dio();
    await dio.download(
      url,
      filePath,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: true,
        receiveTimeout: const Duration(minutes: 2),
      ),
    );

    await OpenFilex.open(filePath);
  } catch (e) {
    debugPrint("PDF Download Error: $e");
    Get.snackbar(
      "Error",
      "Failed to download resume",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
