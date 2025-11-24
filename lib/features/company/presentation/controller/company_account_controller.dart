

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompanyAccountController extends GetxController {
  // Form Key
  final formKey = GlobalKey<FormState>();

  // Text Controllers (normal fields)
  final aboutUsController = TextEditingController();
  final companyNameController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final postalCodeController = TextEditingController();
  final emailController = TextEditingController();
  final contactNumberController = TextEditingController();
  final websiteController = TextEditingController();
  final linkedInController = TextEditingController();
  final twitterController = TextEditingController();
  final upworkController = TextEditingController();
  final otherWebsiteController = TextEditingController();
  final awardTitleController = TextEditingController();
  final issuerController = TextEditingController();
  final issueDateController = TextEditingController();
  final awardDescriptionController = TextEditingController();
  final addMoreLinksController = TextEditingController();
  final otherWebsiteController2 = TextEditingController();

  // Observables
  var elevatorVideoPath = RxnString();

  // 🔥 Dynamic services list (controllers for each field)
  var serviceControllers = <TextEditingController>[].obs;
  var employeeControllers = <TextEditingController>[].obs;
  var awardFields = <Map<String, TextEditingController>>[].obs;

  // Employees, Awards, Links
  var employees = <String>[].obs;
  var awards = <Map<String, String>>[].obs;
  var additionalLinks = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Start with one service field
    serviceControllers.add(TextEditingController());
    employeeControllers.add(TextEditingController());
  }

  // --- Service Management ---
  void addServiceField() {
    serviceControllers.add(TextEditingController());
  }

  void removeServiceField(int index) {
    if (serviceControllers.length > 1) {
      serviceControllers[index].dispose();
      serviceControllers.removeAt(index);
    }
  }

  List<String> getServices() {
    return serviceControllers
        .map((c) => c.text.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  // --- Awards ---
  // void addAward() {
  //   if (awardTitleController.text.isNotEmpty &&
  //       issuerController.text.isNotEmpty &&
  //       issueDateController.text.isNotEmpty &&
  //       awardDescriptionController.text.isNotEmpty) {
  //     awards.add({
  //       'title': awardTitleController.text,
  //       'issuer': issuerController.text,
  //       'date': issueDateController.text,
  //       'description': awardDescriptionController.text,
  //     });
  //     awardTitleController.clear();
  //     issuerController.clear();
  //     issueDateController.clear();
  //     awardDescriptionController.clear();
  //   }
  // }

  void addAwardField() {
  awardFields.add({
    'title': TextEditingController(),
    'issuer': TextEditingController(),
    'date': TextEditingController(),
    'description': TextEditingController(),
  });
}


  // Remove award fields
  void removeAwardField(int index) {
    final fields = awardFields[index];
    fields['title']?.dispose();
    fields['issuer']?.dispose();
    fields['date']?.dispose();
    fields['description']?.dispose();
    awardFields.removeAt(index);
  }

  List<Map<String, String>> getAwards() {
    return awardFields.map((fields) {
      return {
        'title': fields['title']?.text ?? "",
        'issuer': fields['issuer']?.text ?? "",
        'date': fields['date']?.text ?? "",
        'description': fields['description']?.text ?? "",
      };
    }).toList();
  }

  // --- Employees ---
  void addEmployee() {
    employeeControllers.add(TextEditingController());
  }

  // Remove employee field
  void removeEmployeeField(int index) {
    if (employeeControllers.length > 1) {
      employeeControllers[index].dispose();
      employeeControllers.removeAt(index);
    }
  }

  // Get employee values
  List<String> getEmployees() {
    return employeeControllers
        .map((c) => c.text.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  // --- Video Upload ---
  void uploadElevatorVideo() {
    elevatorVideoPath.value = "dummy_video_path.mp4";
  }

  // --- Links ---
  void addMoreLinks() {
    if (addMoreLinksController.text.isNotEmpty) {
      additionalLinks.add(addMoreLinksController.text.trim());
      addMoreLinksController.clear();
      Get.snackbar(
        'Success',
        'Link added successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'Error',
        'Please enter a valid link',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void removeLink(int index) {
    additionalLinks.removeAt(index);
  }

  // --- Save Form ---
  void saveForm() {
    if (formKey.currentState!.validate()) {
      Get.snackbar(
        'Success',
        'Company profile saved successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    // Dispose all text controllers
    aboutUsController.dispose();
    companyNameController.dispose();
    countryController.dispose();
    cityController.dispose();
    postalCodeController.dispose();
    emailController.dispose();
    contactNumberController.dispose();
    websiteController.dispose();
    linkedInController.dispose();
    twitterController.dispose();
    upworkController.dispose();
    otherWebsiteController.dispose();
    awardTitleController.dispose();
    issuerController.dispose();
    issueDateController.dispose();
    awardDescriptionController.dispose();
    addMoreLinksController.dispose();
    otherWebsiteController2.dispose();

    // Dispose service controllers
    for (var c in serviceControllers) {
      c.dispose();
    }

    for (var c in employeeControllers) {
      c.dispose();
    }
    

    super.onClose();
  }
}
