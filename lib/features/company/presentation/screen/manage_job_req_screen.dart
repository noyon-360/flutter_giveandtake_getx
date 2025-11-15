import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/manage_job_controller.dart';
import '../widget/job_req_card_widget.dart';
import 'job_details_screen.dart';

class ManageJobPostScreen extends StatelessWidget {
  final ManageJobPostController controller = Get.put(ManageJobPostController());

  ManageJobPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 Title Section (Inside Body)
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Manage job post request",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // keeps title perfectly centered
                ],
              ),

              const SizedBox(height: 10),

              /// 🔹 Job Request List
              Expanded(
                child: Obx(() {
                  final jobs = controller.jobRequests.take(5).toList(); // max 5
                  return ListView.builder(
                    itemCount: jobs.length,
                    itemBuilder: (context, index) {
                      final job = jobs[index];
                      return JobRequestCard(
                        name: job["name"]!,
                        position: job["position"]!,
                        company: job["company"]!,
                        jobTitle: job["jobTitle"]!,
                        imageUrl: job["image"]!,
                        onViewDetails: () {
                          Get.to(
                            () => JobDetailsPage(),
                            transition: Transition.rightToLeft,
                          );
                        },
                      );
                    },
                  );
                }),
              ),

              const SizedBox(height: 8),

              /// 🔹 Pagination Section
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 16),
                      onPressed: controller.previousPage,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF2B7FD0),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      child: Text(
                        "${controller.currentPage.value}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      "of 3",
                      style: TextStyle(color: Colors.black54, fontSize: 13),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, size: 16),
                      onPressed: controller.nextPage,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
