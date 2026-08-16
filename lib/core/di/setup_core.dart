import 'package:get/get.dart';

import '../services/media_crop_service.dart';
import '../services/deep_link_service.dart';
import '../services/socket_service.dart';
import '../network/api_client.dart';
import '../network/services/auth_storage_service.dart';

void setupCore() {
  Get.put<ApiClient>(ApiClient(), permanent: true);
  Get.put<DeepLinkService>(DeepLinkService.instance, permanent: true);
  Get.put<AuthStorageService>(AuthStorageService(), permanent: true);
  Get.put<MediaCropService>(MediaCropService(), permanent: true);
  Get.put<SocketService>(SocketService(), permanent: true);
}
