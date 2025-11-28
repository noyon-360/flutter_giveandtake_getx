import 'package:get/get.dart';

class BottomNavController extends GetxController {
  var currentIndex = 0.obs;

  BottomNavController() {
    // Explicitly set to 0 on creation
    currentIndex.value = 0;
    print('✅ BottomNavController initialized with index: ${currentIndex.value}');
  }

  void changeIndex(int index) {
    currentIndex.value = index;
    print('🔄 Nav index changed to: $index');
  }

  /// Reset to home screen (index 0)
  void resetToHome() {
    currentIndex.value = 0;
    print('🏠 Reset to Home screen (index 0)');
  }
}
