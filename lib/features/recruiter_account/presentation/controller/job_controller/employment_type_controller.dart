// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
//
// class EmploymentTypeController extends GetxController {
//   final RxString selectedEmploymentType = ''.obs;
//   final List<String> employmentTypes = [
//     'Full-time',
//     'Part-time',
//     'Internship',
//     'Contract',
//     'Temporary',
//     'Freelance',
//     'Volunteer',
//   ];
// }

import 'package:get/get.dart';

class EmploymentTypeController extends GetxController {
  final RxString selectedEmploymentType = ''.obs;

  // Display name → Backend value mapping
  final Map<String, String> employmentTypeMap = {
    'Full-time': 'full-time',
    'Part-time': 'part-time',
    'Internship': 'internship',
    'Contract': 'contract',
    'Temporary': 'temporary',
    'Freelance': 'freelance',
    'Volunteer': 'volunteer',
  };

  List<String> get employmentTypes => employmentTypeMap.keys.toList();

  String getBackendValue(String displayName) {
    return employmentTypeMap[displayName] ?? '';
  }
}
