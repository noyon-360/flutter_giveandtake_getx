// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
//
// class LocationTypeController extends GetxController {
//   final RxString selectedLocationType = ''.obs;
//   final List<String> locationType = [
//     'On-site',
//     'Remote',
//     'Hybrid',
//   ];
// }

import 'package:get/get.dart';

class LocationTypeController extends GetxController {
  final RxString selectedLocationType = ''.obs;

  final Map<String, String> locationTypeMap = {
    'On-site': 'onsite',
    'Remote': 'remote',
    'Hybrid': 'hybrid',
  };

  List<String> get locationTypes => locationTypeMap.keys.toList();

  String getBackendValue(String displayName) {
    return locationTypeMap[displayName] ?? '';
  }

  String getDisplayName(String backendValue) {
    return locationTypeMap.entries
        .firstWhere((e) => e.value == backendValue, orElse: () => const MapEntry('', ''))
        .key;
  }

}
