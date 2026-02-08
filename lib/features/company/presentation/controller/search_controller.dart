// import 'package:get/get.dart';

// import '../../data/model/dummy_search_model.dart';

// class SearchCompanyController extends GetxController {
//   final searchText = ''.obs;

//   final users = <UserModel>[
//     UserModel(
//       name: "Rosalyn Conley",
//       country: "Bangladesh",
//       avatarUrl: "https://i.pravatar.cc/150?img=1",
//     ),
//     UserModel(
//       name: "Eshita Mondol",
//       country: "Albania",
//       avatarUrl: "https://i.pravatar.cc/150?img=2",
//     ),
//     // ... other users
//   ].obs;

//   void onSearchChanged(String value) {
//     searchText.value = value.trim(); // ← better to trim
//   }

//   List<UserModel> get filteredUsers {
//     final query = searchText.value.toLowerCase().trim();

//     if (query.isEmpty) {
//       return []; // don't show anything when empty
//     }

//     return users.where((u) {
//       return u.name.toLowerCase().contains(query) ||
//              u.country.toLowerCase().contains(query);
//     }).toList();
//   }

//   @override
//   void onClose() {
//     searchText.value = '';
//     super.onClose();
//   }
// }