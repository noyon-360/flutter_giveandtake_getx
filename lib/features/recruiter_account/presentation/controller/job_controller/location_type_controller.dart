import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class LocationTypeController extends GetxController {
  final RxString selectedLocationType = ''.obs;
  final List<String> locationType = [
    'On-site',
    'Remote',
    'Hybrid',
  ];
}