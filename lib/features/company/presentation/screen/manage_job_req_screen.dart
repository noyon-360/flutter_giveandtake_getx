import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:karlfive/features/company/presentation/controller/company_account_controller.dart';
import 'package:karlfive/features/company/presentation/controller/company_details_controller.dart';
import 'package:karlfive/features/job_listing/presentation/screens/job_details_screen.dart';
import 'package:karlfive/features/recruiter_account/presentation/screens/job_update_screen.dart';
import 'package:karlfive/features/recruiter_account/presentation/screens/single_job_details_screen.dart';
import '../../../../core/common/widgets/app_scaffold.dart';
import '../../../../core/utils/debug_print.dart';
import '../../../recruiter_account/presentation/controller/recruiter_controller.dart';
import '../../../recruiter_account/presentation/screens/applicants_list_screen.dart';
import 'applicant_lists_screen.dart';

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
  final CompanyDetailsController companyDetailsController =
      Get.find<CompanyDetailsController>();

  @override
  void initState() {
    super.initState();
    companyAccountController.manageJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
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
          child: SingleChildScrollView(
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
                    // Create a reactive boolean for THIS specific job
                    final RxBool isArchived = job.arcrivedJob.obs;

                    return Container(
                      key: ValueKey(
                        job.id,
                      ), // Important: Helps Flutter identify each row
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
                          // SizedBox(
                          //   width: 140,
                          //   child: Text("${job.applicantCount}"),
                          // ),
                          SizedBox(
                            width: 140,
                            child: GestureDetector(
                              onTap: () {
                                final controller =
                                    Get.find<CompanyDetailsController>();
                                controller.jobId.value =
                                    job.id; // <-- Set the job ID
                                controller
                                    .fetchApplicantList(); // <-- Fetch applicants
                                // Optionally navigate to a new screen to show applicants
                                Get.to(
                                  () => CompanyApplicantsListScreen(jobId: job.id),
                                );
                              },
                              child: Text(
                                "View (${job.applicantCount})",
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                  // decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 140, child: Text("${job.vacancy}")),

                          // Actions Column
                          SizedBox(
                            width: 140,
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove_red_eye_outlined,
                                  ),
                                  onPressed: () => Get.to(
                                    () => JobDetailEditScreen(jobId: job.id),
                                  ),
                                ),

                                // TOGGLE BUTTON: Archive / Unarchive
                                Obx(
                                  () => ElevatedButton(
                                    onPressed:
                                        companyDetailsController.isLoading.value
                                        ? null // Disable while loading
                                        : () async {
                                            await companyDetailsController
                                                .archiveJobs(job.id);

                                            // Update the local reactive state from API response
                                            if (companyDetailsController
                                                    .jobData
                                                    .value !=
                                                null) {
                                              isArchived.value =
                                                  companyDetailsController
                                                      .jobData
                                                      .value!
                                                      .arcrivedJob;
                                            }
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isArchived.value
                                          ? Colors.red.shade100
                                          : Colors.green.shade100,
                                      foregroundColor: isArchived.value
                                          ? Colors.red.shade800
                                          : Colors.green.shade800,
                                      minimumSize: const Size(80, 36),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                    ),
                                    child: Text(
                                      isArchived.value
                                          ? "Unarchive"
                                          : "Archive",
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
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
                // Column(
                //   children: jobs.map((job) {
                //     return Container(
                //       margin: const EdgeInsets.symmetric(vertical: 6),
                //       padding: const EdgeInsets.all(12),
                //       decoration: BoxDecoration(
                //         color: Colors.white,
                //         borderRadius: BorderRadius.circular(8),
                //         boxShadow: [
                //           BoxShadow(
                //             color: Colors.black.withOpacity(0.2),
                //             blurRadius: 6,
                //             offset: const Offset(0, 3),
                //           ),
                //         ],
                //       ),
                //       child: Row(
                //         children: [
                //           SizedBox(
                //             width: 200,
                //             child: Text(
                //               job.title ?? "",
                //               overflow: TextOverflow.ellipsis,
                //             ),
                //           ),
                //           SizedBox(
                //             width: 200,
                //             child: Text(
                //               job.name ?? "",
                //               overflow: TextOverflow.ellipsis,
                //             ),
                //           ),
                //           SizedBox(
                //             width: 200,
                //             child: Text(
                //               job.location,
                //               overflow: TextOverflow.ellipsis,
                //             ),
                //           ),
                //           SizedBox(
                //             width: 100,
                //             child: Text(
                //               job.experience,
                //               overflow: TextOverflow.ellipsis,
                //             ),
                //           ),
                //           SizedBox(
                //             width: 100,
                //             child: Text(formatDate(job.deadline)),
                //           ),
                //           SizedBox(
                //             width: 140,
                //             child: Text(
                //               job.derivedStatus,
                //               overflow: TextOverflow.ellipsis,
                //             ),
                //           ),
                //           SizedBox(
                //             width: 140,
                //             child: Text("${job.applicantCount}"),
                //           ),
                //           SizedBox(width: 140, child: Text("${job.vacancy}")),
                //           SizedBox(
                //             width: 140,
                //             child: Row(
                //               children: [
                //                 IconButton(
                //                   icon: Icon(Icons.remove_red_eye_outlined),
                //                   onPressed: () => Get.to(
                //                     () => JobDetailEditScreen(jobId: job.id),
                //                   ),
                //                 ),
                //                 ElevatedButton(
                //                   onPressed: () async {
                //                     await companyDetailsController.archiveJobs(
                //                       job.id,
                //                     );
                //                   },
                //                   style: ElevatedButton.styleFrom(
                //                     backgroundColor: Colors.green.shade100,
                //                     foregroundColor: Colors.green.shade800,
                //                     minimumSize: Size(60, 32),
                //                     padding: EdgeInsets.symmetric(
                //                       horizontal: 8,
                //                     ),
                //                   ),
                //                   child: Text(
                //                     "Archive",
                //                     style: TextStyle(fontSize: 12),
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ],
                //       ),
                //     );
                //   }).toList(),
                // ),
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
