// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:giveandtake/core/common/widgets/app_scaffold.dart';
// import '../controller/company_details_controller.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import '../widget/falcon_button_widget.dart';
// import 'manage_job_req_screen.dart';

// class CompanyDetailsRecViewPage extends StatelessWidget {
//  final CompanyDetailsController controller = Get.find();

//   CompanyDetailsRecViewPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return AppScaffold(
//       body: Obx(() {
//         final company = controller.company.value;

//         return SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 46),

//               /// --- Top Header
//               Container(
//                 color: Color(0xFF939393),
//                 padding: const EdgeInsets.all(16),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     /// Profile Picture
//                     CircleAvatar(
//                       radius: 28,
//                       backgroundImage: company.logoUrl.isNotEmpty
//                           ? NetworkImage(company.logoUrl)
//                           : null,
//                       child: company.logoUrl.isEmpty
//                           ? const Icon(Icons.person, size: 30)
//                           : null,
//                     ),

//                     const SizedBox(width: 12),

//                     /// Recruiter Info (Left Side)
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             company.recruiterName,
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Text(
//                             company.recruiterRole,
//                             style: const TextStyle(color: Color(0xFF111111)),
//                           ),
//                           Text(
//                             company.location,
//                             style: const TextStyle(color: Color(0xFF111111)),
//                           ),
//                         ],
//                       ),
//                     ),

//                     /// Right side: Social icons + Post a Job
//                     IntrinsicWidth(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           // Smaller container for social icons
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 2,
//                               vertical: 2,
//                             ), // smaller padding
//                             decoration: BoxDecoration(
//                               color: const Color(0xFF939393),
//                               borderRadius: BorderRadius.circular(6),
//                               border: Border.all(color: Colors.black),
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 FaIconButton(
//                                   icon: FontAwesomeIcons.linkedin,
//                                   color: const Color(0xFF0A66C2),
//                                   onPressed: () {},
//                                   size: 14,
//                                 ),
//                                 FaIconButton(
//                                   icon: FontAwesomeIcons.twitter,
//                                   color: const Color(0xFF0A66C2),
//                                   onPressed: () {},
//                                   size: 14,
//                                 ),
//                                 FaIconButton(
//                                   icon: FontAwesomeIcons.facebook,
//                                   color: const Color(0xFF1877F2),
//                                   onPressed: () {},
//                                   size: 14,
//                                 ),
//                                 FaIconButton(
//                                   icon: FontAwesomeIcons.tiktok,
//                                   color: Colors.black,
//                                   onPressed: () {},
//                                   size: 14,
//                                 ),
//                                 FaIconButton(
//                                   icon: FontAwesomeIcons.instagram,
//                                   color: Colors.black,
//                                   onPressed: () {},
//                                   isLast: true,
//                                   size: 14,
//                                 ),
//                               ],
//                             ),
//                           ),

//                           const SizedBox(
//                             height: 4,
//                           ), // smaller space between icons and button
//                           // Smaller Post A Job button
//                           SizedBox(
//                             width: 75,
//                             // height: 16,// adjust the width as needed
//                             child: ElevatedButton(
//                               onPressed: () {},
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: const Color(0xFF2B7FD0),
//                                 foregroundColor: Colors.white,
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 8,
//                                   vertical: 4,
//                                 ),
//                                 textStyle: const TextStyle(fontSize: 10),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                               ),
//                               child: const Text("Follow"),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.all(8),
//                       child: Column(
//                         crossAxisAlignment:
//                             CrossAxisAlignment.start, // left-align content
//                         children: [
//                           const Text(
//                             "Easily post your company’s job openings and reach the right talent fast. Get quality applications in no time.",
//                             style: TextStyle(
//                               color: Color(0xFF727272),
//                               fontSize: 12,
//                               fontWeight: FontWeight.w400,
//                             ),
//                             textAlign: TextAlign.start,
//                           ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 8),
//                     Container(
//                       alignment: Alignment
//                           .centerLeft, // container starts from the left
//                       child: Row(
//                         mainAxisSize:
//                             MainAxisSize.min, // shrink row to fit buttons
//                         children: [
//                           SizedBox(
//                             // height: 25, // button height
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 Get.to(
//                                   () => ManageJobPostScreen(),
//                                   transition: Transition.rightToLeft,
//                                 );
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: const Color(0xFF2B7FD0),
//                                 foregroundColor: Color(0xFFFFFFFF),
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 12,
//                                 ), // adjust width
//                                 textStyle: const TextStyle(fontSize: 12),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(
//                                     10,
//                                   ), // rounded corners
//                                 ),
//                               ),
//                               child: const Text("Manage Jobs"),
//                             ),
//                           ),
//                           const SizedBox(width: 10), // space between buttons
//                           SizedBox(
//                             // height: 27,
//                             child: ElevatedButton(
//                               onPressed: () {},
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: const Color(0xFF2B7FD0),
//                                 foregroundColor: Color(0xFFFFFFFF),
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 12,
//                                 ),
//                                 textStyle: const TextStyle(fontSize: 12),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                               ),
//                               child: const Text("Edit Profile"),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               /// --- Elevator Pitch
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Elevator Pitch",
//                       style: TextStyle(
//                         color: Color(0xFF000000),
//                         fontSize: 20,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     Icon(Icons.delete_outline, color: Colors.red),
//                   ],
//                 ),
//               ),
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 16),
//                 child: Row(
//                   children: [
//                     Text(
//                       "Upload a short video introducing your company",
//                       style: TextStyle(
//                         color: Color(0xFF727272),
//                         fontSize: 10,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 margin: const EdgeInsets.all(16),
//                 height: 200,
//                 color: Colors.black12,
//                 child: const Center(
//                   child: Icon(
//                     Icons.play_circle_fill,
//                     size: 60,
//                     color: Colors.black54,
//                   ),
//                 ),
//               ),

//               /// --- About Info
//               infoTile("About us", company.aboutUs),
//               infoTile("Website", company.website),
//               infoTile("Industry", company.industry),
//               infoTile("Company size", company.companySize),
//               infoTile("Specialties", company.specialties),
//               ListTile(
//                 title: const Text(
//                   "Locations",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//                 ),
//                 subtitle: Text(company.address),
//                 trailing: TextButton(
//                   onPressed: () {},
//                   child: const Text("Get Direction"),
//                 ),
//               ),

//               /// --- Employees
//               const Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: Text(
//                   "Employees",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ),

//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal, // allow horizontal scrolling
//                 child: DataTable(
//                   columnSpacing: 16,
//                   headingRowColor: MaterialStateProperty.all(Color(0xFFF8F8F8)),
//                   columns: const [
//                     DataColumn(label: Text("Recruiter name")),
//                     DataColumn(label: Text("Role")),
//                     DataColumn(label: Text("Phone Number")),
//                     DataColumn(label: Text("Action")),
//                   ],
//                   rows: company.employees.map((e) {
//                     return DataRow(
//                       cells: [
//                         DataCell(Text(e.name)),
//                         DataCell(Text(e.role)),
//                         DataCell(Text(e.phone)),
//                         const DataCell(
//                           Icon(
//                             Icons.delete_outline,
//                             color: Colors.red,
//                             size: 20,
//                           ),
//                         ),
//                       ],
//                     );
//                   }).toList(),
//                 ),
//               ),

//               Align(
//                 alignment: Alignment.centerRight,
//                 child: TextButton(
//                   onPressed: () {},
//                   child: const Text("See all"),
//                 ),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }

//   Widget infoTile(String title, String value) {
//     return ListTile(
//       title: Text(
//         title,
//         style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//       ),
//       subtitle: Text(value),
//     );
//   }
// }
