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
      
      print('========== CHECKING RESUME ==========');
      print('Endpoint: ${ApiConstants.resume.getResume}');
      print('=====================================');
      
      final response = await http.get(
        uri,
        headers: ApiConstants.authHeaders(token),
      );

      print('========== RESUME API RESPONSE ==========');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      print('=========================================');

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        // Handle potential 'data' wrapper common in this project
        final data = body is Map && body.containsKey('data') ? body['data'] : body;
        final resume = data['resume'];

        if (resume != null) {
          // Extract resumeId from the resume object
          String? resumeId;
          
          if (resume is Map<String, dynamic>) {
            resumeId = resume['_id'] ?? resume['id'];
          } else if (resume is String) {
            resumeId = resume;
          }
          
          print('========== RESUME ID EXTRACTED ==========');
          print('Resume ID: $resumeId');
          print('Resume Data: $resume');
          print('=========================================');
          
          // Add resumeId to jobData before passing to JobApplicationScreen
          final updatedJobData = {
            ...jobData,
            'resumeId': resumeId,
          };
          
          // Resume exists, proceed to application
          Get.to(() => JobApplicationScreen(jobData: updatedJobData));
        } else {
          // Resume is null, redirect to create resume
          print('========== NO RESUME FOUND ==========');
          print('User needs to create a resume first');
          print('=====================================');
          
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
          
          // Navigate to create resume screen
          Get.to(() => const ElevatorResumeScreen());
        }
      } else {
        Get.snackbar('Error', 'Failed to check resume status: ${response.statusCode}');
      }
    } catch (e) {
      print("========== RESUME CHECK ERROR ==========");
      print("Error: $e");
      print("========================================");
      Get.snackbar('Error', 'An error occurred while checking resume.');
    } finally {
      isLoading.value = false;
    }
  }
}
