// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controller/manage_job_controller.dart';
// import '../widget/job_req_card_widget.dart';
// import 'job_details_screen.dart';

// class ManageJobPostScreen extends StatelessWidget {
//   final ManageJobPostController controller = Get.put(ManageJobPostController());

//   ManageJobPostScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               /// 🔹 Title Section (Inside Body)
//               Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () => Get.back(),
//                     child: const Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
//                     ),
//                   ),
//                   const Expanded(
//                     child: Center(
//                       child: Text(
//                         "Manage job post request",
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.w600,
//                           fontSize: 18,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 48), // keeps title perfectly centered
//                 ],
//               ),

//               const SizedBox(height: 10),

//               /// 🔹 Job Request List
//               Expanded(
//                 child: Obx(() {
//                   final jobs = controller.jobRequests.take(5).toList(); // max 5
//                   return ListView.builder(
//                     itemCount: jobs.length,
//                     itemBuilder: (context, index) {
//                       final job = jobs[index];
//                       return JobRequestCard(
//                         name: job["name"]!,
//                         position: job["position"]!,
//                         company: job["company"]!,
//                         jobTitle: job["jobTitle"]!,
//                         imageUrl: job["image"]!,
//                         onViewDetails: () {
//                           Get.to(
//                             () => JobDetailsPage(),
//                             transition: Transition.rightToLeft,
//                           );
//                         },
//                       );
//                     },
//                   );
//                 }),
//               ),

//               const SizedBox(height: 8),

//               /// 🔹 Pagination Section
//               Obx(
//                 () => Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.arrow_back_ios, size: 16),
//                       onPressed: controller.previousPage,
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Color(0xFF2B7FD0),
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 10,
//                         vertical: 6,
//                       ),
//                       child: Text(
//                         "${controller.currentPage.value}",
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 13,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 6),
//                     const Text(
//                       "of 3",
//                       style: TextStyle(color: Colors.black54, fontSize: 13),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.arrow_forward_ios, size: 16),
//                       onPressed: controller.nextPage,
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 10),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:karlfive/features/company/presentation/controller/company_account_controller.dart';
import 'package:karlfive/features/job_listing/presentation/screens/job_details_screen.dart';
import 'package:karlfive/features/recruiter_account/presentation/screens/job_update_screen.dart';
import 'package:karlfive/features/recruiter_account/presentation/screens/single_job_details_screen.dart';
import '../../../../core/common/widgets/app_scaffold.dart';
import '../../../../core/utils/debug_print.dart';
import '../../../recruiter_account/presentation/controller/recruiter_controller.dart';
import '../../../recruiter_account/presentation/screens/applicants_list_screen.dart';

class ManageJobPostScreen extends StatefulWidget {
  const ManageJobPostScreen({super.key});

  @override
  State<ManageJobPostScreen> createState() => _ManageJobPostScreenState();
}

class _ManageJobPostScreenState extends State<ManageJobPostScreen> {
  final RecruiterController recruiterController =
      Get.find<RecruiterController>();
  final CompanyAccountController companyAccountController =
      Get.find<CompanyAccountController>();
  final ScrollController horizontalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    companyAccountController.manageJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All Jobs List",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: Obx(() {
        if (recruiterController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final jobs = companyAccountController.manageJobList;
        if (jobs.isEmpty) {
          return const Center(child: Text("No jobs posted yet."));
        }

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: 
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER ROW
                Row(
                  children: const [
                    SizedBox(
                      width: 200,
                      child: Text(
                        "Title",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: Text(
                        "Category",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: Text(
                        "Location",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: Text(
                        "Experience",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: Text(
                        "Deadline",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: 140,
                      child: Text(
                        "Status",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: 140,
                      child: Text(
                        "Applicants",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: 140,
                      child: Text(
                        "Vacancy",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: 140,
                      child: Text(
                        "Actions",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // JOB ROWS
                Column(
                  children: jobs.map((job) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 200,
                            child: Text(
                              job.title ?? "",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            child: Text(
                              job.name ?? "",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            child: Text(
                              job.location,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: Text(
                              job.experience,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: Text(formatDate(job.deadline)),
                          ),
                          SizedBox(
                            width: 140,
                            child: Text(
                              job.derivedStatus,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            width: 140,
                            child: Text("${job.applicantCount}"),
                          ),
                          SizedBox(width: 140, child: Text("${job.vacancy}")),
                          SizedBox(
                            width: 140,
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove_red_eye_outlined),
                                  onPressed: () => Get.to(
                                    () => JobDetailEditScreen(jobId: job.id),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green.shade100,
                                    foregroundColor: Colors.green.shade800,
                                    minimumSize: Size(60, 32),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                  ),
                                  child: Text(
                                    "Archive",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   child: ConstrainedBox(
          //     constraints: BoxConstraints(minWidth: 1000),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         // Text('Job List', ),
          //         // SizedBox(height: 20,),
          //         // SizedBox(height: 20,),
          //         // HEADER ROW
          //         Row(
          //           children: const [
          //             SizedBox(
          //               width: 140,
          //               child: Text(
          //                 "Title",
          //                 style: TextStyle(fontWeight: FontWeight.bold),
          //               ),
          //             ),
          //             SizedBox(
          //               width: 140,
          //               child: Text(
          //                 "Category",
          //                 style: TextStyle(fontWeight: FontWeight.bold),
          //               ),
          //             ),
          //             SizedBox(
          //               width: 140,
          //               child: Text(
          //                 "Location",
          //                 style: TextStyle(fontWeight: FontWeight.bold),
          //               ),
          //             ),
          //             SizedBox(
          //               width: 140,
          //               child: Text(
          //                 "Experience",
          //                 style: TextStyle(fontWeight: FontWeight.bold),
          //               ),
          //             ),
          //             SizedBox(
          //               width: 140,
          //               child: Text(
          //                 "Deadline",
          //                 style: TextStyle(fontWeight: FontWeight.bold),
          //               ),
          //             ),
          //             SizedBox(
          //               width: 140,
          //               child: Text(
          //                 "Status",
          //                 style: TextStyle(fontWeight: FontWeight.bold),
          //               ),
          //             ),
          //             SizedBox(
          //               width: 140,
          //               child: Text(
          //                 "Applicants List",
          //                 style: TextStyle(fontWeight: FontWeight.bold),
          //               ),
          //             ),
          //             SizedBox(
          //               width: 140,
          //               child: Text(
          //                 "Vacancy",
          //                 style: TextStyle(fontWeight: FontWeight.bold),
          //               ),
          //             ),

          //             SizedBox(
          //               width: 140,
          //               child: Text(
          //                 "Actions",
          //                 style: TextStyle(fontWeight: FontWeight.bold),
          //               ),
          //             ),
          //           ],
          //         ),

          //         const SizedBox(height: 10),
          //         const Divider(color: Colors.grey),

          //         const SizedBox(height: 10),

          //         // ----- JOB ROWS -----
          //         // ----- JOB ROWS AS CARDS -----
          //         Column(
          //           children: List.generate(jobs.length, (index) {
          //             final job = jobs[index];

          //             return Container(
          //               margin: const EdgeInsets.only(bottom: 12),
          //               padding: const EdgeInsets.all(16),
          //               decoration: BoxDecoration(
          //                 color: Colors.white,
          //                 borderRadius: BorderRadius.circular(12),
          //                 border: Border.all(color: Colors.grey.shade300),
          //                 boxShadow: [
          //                   BoxShadow(
          //                     color: Colors.grey.shade200,
          //                     blurRadius: 4,
          //                     offset: const Offset(0, 2),
          //                   ),
          //                 ],
          //               ),

          //               child: Row(
          //                 children: [
          //                   SizedBox(
          //                     width: 140,
          //                     child: Text(
          //                       job.title ?? "",
          //                       style: TextStyle(
          //                         fontWeight: FontWeight.w600,
          //                       ),
          //                     ),
          //                   ),
          //                   SizedBox(
          //                     width: 100,
          //                     child: Text(job.jobCategoryId ?? ""),
          //                   ),
          //                   SizedBox(
          //                     width: 140,
          //                     child: Text(formatDate(job.location)),
          //                   ),
          //                   SizedBox(
          //                     width: 140,
          //                     child: Text(formatDate(job.experience)),
          //                   ),
          //                   SizedBox(
          //                     width: 140,
          //                     child: Text(formatDate(job.deadline)),
          //                   ),
          //                   SizedBox(
          //                     width: 140,
          //                     child: Text(formatDate(job.status)),
          //                   ),
          //                   SizedBox(
          //                     width: 140,
          //                     child: Text(
          //                       formatDate(job.applicationRequirement),
          //                     ),
          //                   ),
          //                   SizedBox(
          //                     width: 140,
          //                     child: Text(formatDate(job.vacancy)),
          //                   ),

          //                   SizedBox(
          //                     width: 140,
          //                     child: GestureDetector(
          //                       onTap: () => Get.to(
          //                         () => ApplicantsListScreen(jobId: job.id),
          //                       ),
          //                       child: Text(
          //                         "View (${job.applicantCount})",
          //                         style: TextStyle(color: Colors.blue),
          //                       ),
          //                     ),
          //                   ),

          //                   SizedBox(
          //                     width: 140,
          //                     child: Row(
          //                       children: [
          //                         IconButton(
          //                           icon: Icon(
          //                             Icons.remove_red_eye_outlined,
          //                             color: Colors.grey.shade600,
          //                           ),
          //                           onPressed: () => Get.to(
          //                             () => JobDetailEditScreen(
          //                               jobId: job.id,
          //                             ),
          //                           ),
          //                         ),
          //                         ElevatedButton(
          //                           onPressed: () {
          //                             DPrint();
          //                           },
          //                           style: ElevatedButton.styleFrom(
          //                             backgroundColor:
          //                                 Colors.green.shade100,
          //                             foregroundColor:
          //                                 Colors.green.shade800,
          //                             minimumSize: Size(60, 32),
          //                             padding: EdgeInsets.symmetric(
          //                               horizontal: 8,
          //                             ),
          //                           ),
          //                           child: Text(
          //                             "Archive",
          //                             style: TextStyle(fontSize: 12),
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             );
          //           }),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        );
      }),
    );
  }

  /// Safe date formatter — accepts String or DateTime (or null)
  String formatDate(dynamic date) {
    if (date == null) return '';
    try {
      DateTime dt;
      if (date is DateTime) {
        dt = date;
      } else {
        // try parse string (handles ISO strings from backend)
        dt = DateTime.parse(date.toString());
      }
      // Example output: 12 Nov, 2025
      return DateFormat('dd MMM, yyyy').format(dt);
    } catch (e) {
      // fallback: just return the original value as string
      return date.toString();
    }
  }
}
