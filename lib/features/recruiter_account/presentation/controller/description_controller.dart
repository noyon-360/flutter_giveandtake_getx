import 'package:get/get.dart';

class DescriptionController extends GetxController {
  var wordCount = 0.obs;
  final int maxWords = 400;

  int countWords(String text) {
    if (text.trim().isEmpty) return 0;
    return text.trim().split(RegExp(r'\s+')).length;
  }
}
