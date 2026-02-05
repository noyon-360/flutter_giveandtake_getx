import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/network/constants/api_constants.dart';
import '../controller/company_details_controller.dart';
import '../controller/public_view_controller.dart';
import '../widget/elevator-pitch_company_widget.dart';
import '../widget/search_job_card.dart';

class PublicViewSeachScreen extends StatelessWidget {
  PublicViewSeachScreen({super.key});

  final PublicViewController controller = Get.put(PublicViewController());
  final CompanyDetailsController Ccontroller = Get.find();
  final CompanyDetailsController Comcontroller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Cover Image
            Stack(
              clipBehavior: Clip.none, // 🔥 THIS FIXES IT
              alignment: Alignment.bottomLeft,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: Image.network(
                    'https://images.unsplash.com/photo-1509021436665-8f07dbf5bf1d',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade300,
                        alignment: Alignment.center,
                        child: const Icon(Icons.image_not_supported, size: 40),
                      );
                    },
                  ),
                ),

                Positioned(
                  bottom: -40,
                  left: 16,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white, // border background
                      borderRadius: BorderRadius.circular(
                        8,
                      ), // remove if you want sharp corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(3),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        'https://i.pravatar.cc/150?img=3',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade300,
                            alignment: Alignment.center,
                            child: const Icon(Icons.person, size: 32),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 50), // Space for profile overlap
            // Company Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tech System',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: const [
                      Icon(Icons.location_on, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        'Herat, Afghanistan',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: const [
                      Icon(Icons.business, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        'Social Enterprise',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Buttons Row
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Open LinkedIn
                        },
                        icon: const Icon(Icons.link),
                        label: const Text('LinkedIn'),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Obx(
                        () => GestureDetector(
                          onTap: controller.toggleFollow,
                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: controller.isFollowing.value
                                  ? Colors.transparent
                                  : const Color(0xFFE6F0FF), // light sky blue
                              border: Border.all(
                                color: Colors.blue.shade800,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(
                                8,
                              ), // square feel
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              controller.isFollowing.value
                                  ? 'Following'
                                  : 'Follow',
                              style: TextStyle(
                                color: Colors.blue.shade800,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  Divider(
                    color: Colors.grey.shade300,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                  ),
                  const Text(
                    'About',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'This company is for testing purposes',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),

                  sectionTitle("Elevator Pitch", canDelete: true),

                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xFF999999),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),

                    //fetch elevated pitch e
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: const Color(0xFF191919),
                      ),
                      height: 160,
                      width: double.infinity,
                      child: ElevatorPitchCompanySection(
                        videoUrl: '',
                        // "${ApiConstants.baseUrl}/elevator-pitch/stream/${company.elevatorPitch.id}",
                        // httpHeaders: {
                        //   "Custom-Header": "value",
                        //   if (_accessToken != null) ...{
                        //     "Authorization": "Bearer $_accessToken",
                        //   },
                        // },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  sectionTitle("Company Jobs"),

                  const SizedBox(height: 12),

                  CompanyJobCard(
                    jobTitle: "Enterprise Manager",
                    companyName: "Tech System",
                    location: "Ambriz, Angola",
                    jobType: "Onsite",
                    jobLevel: "Internship",
                    applicants: 0,
                    postedDate: "10 January 2026",
                  ),
                ],
              ),
            ),

             const SizedBox(height: 20),
                // Align(
                //   alignment: Alignment.centerRight,
                //   child: TextButton(onPressed: () {}, child: Text("See all")),
                // ),

                // -------------------- 🏅 Honors & Achievements --------------------
                Text(
                  "Awards and Honors",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),

                Comcontroller.userInfo.value?.honors != null &&
                        Comcontroller.userInfo.value!.honors.isNotEmpty
                    ? Column(
                        children: Comcontroller.userInfo.value!.honors.map((
                          honor,
                        ) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 3,
                                  spreadRadius: 1,
                                  color: Colors.black.withOpacity(.05),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 🏆 Honor Title
                                Row(
                                  children: [
                                    // Icon(
                                    //   Icons.workspace_premium,
                                    //   size: 20,
                                    //   color: Colors.amber,
                                    // ),
                                    // SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        honor.title,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 6),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        honor.programeName,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 6),

                                // 🔸 Issued By + Date
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_month_outlined,
                                      size: 14,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      _formatDate(honor.programeDate.toIso8601String()),
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 6),
                                SizedBox(width: 6),

                                // 📝 Description
                                Text(
                                  honor.description,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        child: Text(
                          "No honors awarded yet.",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),

                SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

Widget sectionTitle(String title, {bool canDelete = false}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
      if (canDelete) Icon(Icons.delete_outline, color: Colors.red),
    ],
  );
}
String _formatDate(String isoDateString) {
  try {
    // Example input: "2025-09-01T00:00:00.000Z"
    final DateTime date = DateTime.parse(isoDateString);
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  } catch (e) {
    return "Invalid Date";
  }
}
