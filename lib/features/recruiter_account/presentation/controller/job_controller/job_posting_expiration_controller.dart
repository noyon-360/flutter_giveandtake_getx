import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class JobPostingExpirationController extends GetxController {
  final RxString selectedJobPostingExpiration = ''.obs;
  final List<String> jobPostingExpiration = [
    '7 days',
    '14 days',
    '30 days',
    '60 days',
    '90 days'
  ];
}