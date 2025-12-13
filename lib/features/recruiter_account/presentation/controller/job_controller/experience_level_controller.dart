import 'package:get/get.dart';

class ExperienceLevelController extends GetxController {
  final RxString selectedExperienceLevel = ''.obs;

  final Map<String, String> experienceLevelMap = {
    'Entry Level': 'Entry Level',
    'Mid Level': 'Mid Level',
    'Senior Level': 'Senior Level',
    'Executive': 'Executive',
  };

  List<String> get experienceLevels => experienceLevelMap.keys.toList();

  String getDisplayName(String backendValue) {
    // Trust the API — it sends display names directly
    return backendValue.isEmpty ? '' : backendValue;
  }

  String getBackendValue(String displayName) {
    return experienceLevelMap[displayName] ?? displayName;
  }

}
