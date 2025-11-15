import 'package:get/get.dart';

import '../network/api_client.dart';
import '../network/services/auth_storage_service.dart';

void setupCore() {
  Get.put<ApiClient>(ApiClient(), permanent: true);
  Get.put<AuthStorageService>(AuthStorageService(), permanent: true);
}
