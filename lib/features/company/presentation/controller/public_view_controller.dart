import 'package:get/get.dart';

class PublicViewController extends GetxController {
  // Reactive variables
  var isFollowing = false.obs;

  void toggleFollow() {
    isFollowing.value = !isFollowing.value;
  }
}


