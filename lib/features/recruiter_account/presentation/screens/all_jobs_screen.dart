import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:giveandtake/features/recruiter_account/presentation/screens/single_job_details_screen.dart';

import '../../../../core/common/widgets/app_scaffold.dart';
import '../../../company/presentation/screen/applicant_lists_screen.dart';
import '../../data/models/archieve_job_request_model.dart';
import '../../data/models/get_job_response_model.dart';
import '../controller/recruiter_controller.dart';
import 'applicants_list_screen.dart';
import 'job_preview_screen.dart';

class AllJobsScreen extends StatefulWidget {
  const AllJobsScreen({super.key});

  @override
  State<AllJobsScreen> createState() => _AllJobsScreenState();
}

class _AllJobsScreenState extends State<AllJobsScreen> {
  final RecruiterController recruiterController =
      Get.find<RecruiterController>();

  @override
  void initState() {
    super.initState();
    recruiterController.getJob();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      removePadding: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B7FD0),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        // leading: IconButton(
        //   icon: const Icon(
        //     Icons.arrow_back_ios_new,
        //     size: 20,
        //     color: Colors.white,
        //   ),
        //   onPressed: () => Get.back(),
        // ),
        title: const Text(
          "All Jobs List",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: Obx(() {
        if (recruiterController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final jobs = recruiterController.yourJobList;

        if (jobs.isEmpty) {
          return const Center(child: Text("No jobs posted yet."));
        }

        /// ✅ MOBILE CARD LIST
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: jobs.length,
          itemBuilder: (context, index) {
            final job = jobs[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 8,
                    spreadRadius: 6,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Job Title
                  Text(
                    job.title ?? "",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 6),

                  _infoRow("Status", job.status),
                  _infoRow("Ordered", formatDate(job.createdAt)),
                  _infoRow("Published", formatDate(job.publishDate)),
                  _infoRow("Expiry", formatDate(job.deadline)),

                  const SizedBox(height: 10),

                  /// Applicants
                  GestureDetector(
                    onTap: () => Get.to(
                      () => CompanyApplicantsListScreen(jobId: job.id),
                    ),
                    child: Text(
                      "View Applicants (${job.applicantCount})",
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const Divider(height: 24),

                  /// Actions
                  Row(
                    children: [
                      /// Preview
                      IconButton(
                        icon: const Icon(Icons.remove_red_eye_outlined),
                        onPressed: () =>
                            Get.to(() => JobDetailEditScreen(jobId: job.id)),
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: _approvalBadge(job),
                        ),
                      ),

                      const SizedBox(width: 8),

                      /// Archive / Unarchive
                      Obx(() {
                        final isLoading =
                            recruiterController.archiveLoadingMap[job.id] ??
                            false;
                        final isArchived = job.arcrivedJob ?? false;

                        return ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                                  recruiterController.archiveLoadingMap[job
                                          .id] =
                                      true;

                                  try {
                                    final request = ArchieveJobRequestModel(
                                      id: job.id,
                                      arcrivedJob: !isArchived,
                                    );

                                    await recruiterController.updateArchieveJob(
                                      request: request,
                                      jobId: job.id,
                                    );
                                  } catch (_) {
                                    Get.snackbar(
                                      "Failed",
                                      "Could not update archive status",
                                      backgroundColor: Colors.red.shade600,
                                      colorText: Colors.white,
                                    );
                                  } finally {
                                    recruiterController.archiveLoadingMap[job
                                            .id] =
                                        false;
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isArchived
                                ? Colors.red.shade100
                                : Colors.green.shade100,
                            foregroundColor: isArchived
                                ? Colors.red.shade800
                                : Colors.green.shade800,
                            minimumSize: const Size(110, 38),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  isArchived ? "Unarchive" : "Archive",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  /// Label + value row
  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              "$label:",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? "",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _approvalBadge(YourJobResponseModel job) {
    final bool isApproved = job.adminApprove;
    final status = job.jobApprove.trim().toLowerCase();
    final bool isDenied =
        !isApproved && (status == 'denied' || status == 'deny');

    final String label;
    final Color backgroundColor;
    final Color foregroundColor;

    if (isApproved) {
      label = 'Admin Approved';
      backgroundColor = const Color(0xFFDDF3E2);
      foregroundColor = const Color(0xFF1F8A46);
    } else if (isDenied) {
      label = 'Admin Denied';
      backgroundColor = const Color(0xFFFCE0E0);
      foregroundColor = const Color(0xFFC23A3A);
    } else {
      label = 'Admin Pending';
      backgroundColor = const Color(0xFFFFF1D6);
      foregroundColor = const Color(0xFFB7791F);
    }

    return Container(
      constraints: const BoxConstraints(minWidth: 110),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: foregroundColor,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  /// Safe date formatter
  String formatDate(dynamic date) {
    if (date == null) return '';
    try {
      final DateTime dt = date is DateTime
          ? date
          : DateTime.parse(date.toString());
      return DateFormat('dd MMM, yyyy').format(dt);
    } catch (_) {
      return date.toString();
    }
  }
}
