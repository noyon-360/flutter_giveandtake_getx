import 'package:get/get.dart';

class ExperienceLevelController extends GetxController {
  final RxString selectedExperienceLevel = ''.obs;

  final Map<String, String> experienceLevelMap = {
    'Entry Level': 'entry_level',
    'Mid Level': 'mid_level',
    'Senior Level': 'senior_level',
    'Executive': 'executive',
  };

  List<String> get experienceLevels => experienceLevelMap.keys.toList();

  String getBackendValue(String displayName) {
    return experienceLevelMap[displayName] ?? '';
  }

  String getDisplayName(String backendValue) {
    return experienceLevelMap.entries
        .firstWhere((e) => e.value == backendValue, orElse: () => const MapEntry('', ''))
        .key;
  }

}
