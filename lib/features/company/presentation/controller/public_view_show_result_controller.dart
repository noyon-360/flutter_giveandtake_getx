import 'package:get/get.dart';

class FollowingController extends GetxController {
  var searchText = ''.obs;
  var isImmediate = false.obs;
  var selectedRole = 'All Roles'.obs;

  var users = <UserModel>[
    UserModel(
      name: "Tech System",
      location: "Afghanistan",
      imageUrl:
          "https://randomuser.me/api/portraits/men/32.jpg",
    ),
  ].obs;

  void toggleImmediate() {
    isImmediate.value = !isImmediate.value;
  }

  void updateSearch(String value) {
    searchText.value = value;
  }
}

class UserModel {
  final String name;
  final String location;
  final String imageUrl;

  UserModel({
    required this.name,
    required this.location,
    required this.imageUrl,
  });
}