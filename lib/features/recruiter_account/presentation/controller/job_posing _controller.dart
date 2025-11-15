import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JobPostingController extends GetxController {
  // Track the current step (1–5)
  var currentStep = 1.obs;

  // Navigate steps
  void nextStep() {
    if (currentStep.value < 5) currentStep.value++;
  }

  void previousStep() {
    if (currentStep.value > 1) currentStep.value--;
  }

  // Example form data
  final jobTitleController = TextEditingController();
  final jobDescriptionController = TextEditingController();
}
