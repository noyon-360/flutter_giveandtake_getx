// import 'package:flutter/material.dart';
// import '../screens/profile_dashboard_screen.dart';
// import '../screens/personal_iformation_screen.dart';
// import '../screens/edit_personal_information_screen.dart';
//
// class ProfileTabNavigator extends StatelessWidget {
//   const ProfileTabNavigator({super.key});
//
//   static const String routeHome = 'profile/home';
//   static const String routePersonal = 'profile/personal';
//   static const String routeEdit = 'profile/edit';
//
//   @override
//   Widget build(BuildContext context) {
//     return Navigator(
//       initialRoute: routeHome,
//       onGenerateRoute: (RouteSettings settings) {
//         Widget page;
//         switch (settings.name) {
//           case routePersonal:
//             page = const PersonalInfoScreen();
//             break;
//           case routeEdit:
//             page = const EditProfile();
//             break;
//           case routeHome:
//           default:
//             page = const ProfileDashboardScreen();
//         }
//         return MaterialPageRoute(builder: (_) => page, settings: settings);
//       },
//     );
//   }
// }
