import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ExperienceLevelController extends GetxController {
  final RxString selectedExperienceLevel = ''.obs;
  final List<String> experienceLevel = [
    'Entry Level',
    'Mid Level',
    'Senior Level',
    'Executive',
  ];
}