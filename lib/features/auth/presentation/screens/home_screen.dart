// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:karlfive/core/common/widgets/app_scaffold.dart';
// import 'package:karlfive/core/theme/app_colors.dart';
// import 'package:karlfive/features/auth/presentation/controller/auth_controller.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return AppScaffold(body: Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//       Text('Eshita', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: AppColors.white),),
//           ElevatedButton(onPressed: (){
//             Get.find<AuthController>().logout();
//           }, child: Text('Log out'))
//         ],
//       ),
//     ));
//   }
// }
