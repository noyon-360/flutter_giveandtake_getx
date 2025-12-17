import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:karlfive/core/network/constants/api_constants.dart';
import 'package:karlfive/core/network/services/auth_storage_service.dart';
import 'package:karlfive/features/elevator/presentation/screens/elevator_resume_screen.dart';
import 'package:karlfive/features/job_listing/presentation/screens/job_application_screen.dart';
import 'package:flutter/material.dart';

class JobDetailsController extends GetxController {
  final AuthStorageService _authStorageService = Get.find<AuthStorageService>();
  final isLoading = false.obs;

  Future<void> checkResumeAndApply(Map<String, dynamic> jobData) async {
    isLoading.value = true;
    try {
      final token = await _authStorageService.getAccessToken();
      if (token == null || token.isEmpty) {
        Get.snackbar('Error', 'You must be logged in to apply.');
        return;
      }

      final uri = Uri.parse(ApiConstants.resume.getResume);
      final response = await http.get(
        uri,
        headers: ApiConstants.authHeaders(token),
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        // Handle potential 'data' wrapper common in this project
        final data = body is Map && body.containsKey('data') ? body['data'] : body;
        final resume = data['resume'];

        if (resume != null) {
          // Resume exists, proceed to application
          Get.to(() => JobApplicationScreen(jobData: jobData));
        } else {
          // Resume is null, redirect to create resume
          Get.snackbar(
            'Resume Required',
            'You need to upload a resume first.',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
            mainButton: TextButton(
                onPressed: () {
                    Get.to(() => const ElevatorResumeScreen());
                }, 
                child: const Text("Create", style: TextStyle(color: Colors.white))
            )
          );
          // Small delay to let user see snackbar or just direct navigation? 
          // User request says: "show a scnackbar then need to upload resume first and then redirect"
          // I will redirect after a short delay or just redirect immediately with snackbar showing?
          // "redirect user to the ElevatorResumeScreen" - explicit action.
          
          // Let's go there immediately but keep snackbar visible? 
          // Or wait?
          // I'll navigate immediately so they can start.
          Get.to(() => const ElevatorResumeScreen());
        }
      } else {
        Get.snackbar('Error', 'Failed to check resume status: ${response.statusCode}');
      }
    } catch (e) {
      print("Error checking resume: $e");
      Get.snackbar('Error', 'An error occurred while checking resume.');
    } finally {
      isLoading.value = false;
    }
  }
}
