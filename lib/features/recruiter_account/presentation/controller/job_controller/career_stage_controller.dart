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

  final Map<String, String> careerStageMap = {
    'New Entry': 'New Entry',
    'Experienced Professional': 'Experienced Professional',
    'Career Returner': 'Career Returner',
  };

  List<String> get careerStages => careerStageMap.keys.toList();

  // Convert backend → display name
  String getDisplayName(String backendValue) {
    if (backendValue.isEmpty) return '';
    return careerStageMap.entries
        .firstWhere(
          (e) => e.value == backendValue,
      orElse: () => const MapEntry('', ''),
    )
        .key;
  }

  // Convert display → backend value (for saving)
  String getBackendValue(String displayName) {
    return careerStageMap[displayName] ?? '';
  }
}