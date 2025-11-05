import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class CareerStageController extends GetxController {
  final RxString selectedCareerStage = ''.obs;
  final List<String> careerStage = [
    'New Entry',
    'Experienced Professional',
    'Career Returner'
  ];
}