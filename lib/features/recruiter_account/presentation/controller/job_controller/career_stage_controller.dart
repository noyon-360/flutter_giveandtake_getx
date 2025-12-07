// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
//
// class CareerStageController extends GetxController {
//   final RxString selectedCareerStage = ''.obs;
//   final List<String> careerStage = [
//     'New Entry',
//     'Experienced Professional',
//     'Career Returner'
//   ];
// }

import 'package:get/get.dart';

class CareerStageController extends GetxController {
  final RxString selectedCareerStage = ''.obs;

  // Map display names to backend enum values
  final Map<String, String> careerStageMap = {
    'New Entry': 'new_entry',
    'Experienced Professional': 'experienced_professional',
    'Career Returner': 'career_returner',
  };

  // List for dropdown display
  List<String> get careerStages => careerStageMap.keys.toList();

  // Get backend value
  String getBackendValue(String displayName) {
    return careerStageMap[displayName] ?? '';
  }

  String getDisplayName(String backendValue) {
    return careerStageMap.entries
        .firstWhere((e) => e.value == backendValue, orElse: () => const MapEntry('', ''))
        .key;
  }

}
