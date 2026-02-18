


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../controller/search_controller.dart';
// import '../widget/custom_search_company.dart';

// class SearchDropdown extends StatelessWidget {
//   final SearchCompanyController controller = Get.put(SearchCompanyController());

//   SearchDropdown({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         CustomSearchCompany(
//           hintText: "Search people, companies...",
//           controller: TextEditingController()
//             ..addListener(() {
//               controller.searchText.value =
//                   controller.searchText.value;
//             }),
//         ),

//         Obx(() {
//           if (controller.filteredUsers.isEmpty) {
//             return const SizedBox.shrink();
//           }

//           return Container(
//             margin: const EdgeInsets.only(top: 8),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   blurRadius: 12,
//                   color: Colors.black.withOpacity(0.08),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 ...controller.filteredUsers.map(
//                   (user) => ListTile(
//                     leading: CircleAvatar(
//                       backgroundImage: NetworkImage(user.avatarUrl),
//                     ),
//                     title: Text(
//                       user.name,
//                       style: const TextStyle(fontWeight: FontWeight.w600),
//                     ),
//                     subtitle: Text(user.country),
//                     trailing: Icon(
//                       Icons.person_outline,
//                       color:
//                           user.isCompany ? Colors.blue : Colors.green,
//                     ),
//                     onTap: () {
//                       // handle click
//                     },
//                   ),
//                 ),

//                 const Divider(height: 1),

//                 TextButton(
//                   onPressed: () {
//                     // Navigate to full search result page
//                   },
//                   child: const Text("Show All Results"),
//                 ),
//               ],
//             ),
//           );
//         }),
//       ],
//     );
//   }
// }
