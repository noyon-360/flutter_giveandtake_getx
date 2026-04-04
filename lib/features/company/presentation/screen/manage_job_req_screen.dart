import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:giveandtake/features/company/presentation/controller/company_account_controller.dart';
import 'package:giveandtake/features/company/presentation/controller/company_details_controller.dart';
import 'package:giveandtake/features/job_listing/presentation/screens/job_details_screen.dart';
import 'package:giveandtake/features/recruiter_account/presentation/controller/recruiter_controller.dart';

import '../../../../core/common/widgets/app_scaffold.dart';
import '../../../recruiter_account/presentation/screens/single_job_details_screen.dart';
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

  final CompanyDetailsController companyDetailsController =
      Get.find<CompanyDetailsController>();

  @override
  void initState() {
    super.initState();
    companyAccountController.manageJobs();
    companyDetailsController.fetchJobUsage();
  }

  Future<void> _onRefresh() async {
    await companyAccountController.manageJobs();
    await companyDetailsController.fetchJobUsage();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      removePadding: true,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        backgroundColor: const Color(0xFF2B7FD0),
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

        final jobs = companyAccountController.manageJobList;

        if (jobs.isEmpty) {
          return const Center(child: Text("No jobs posted yet."));
        }

        /// ✅ MOBILE CARD LIST
        return RefreshIndicator(
          onRefresh: _onRefresh,
          color: Colors.blue,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _jobSummarySection(
                  companyDetailsController,
                  totalJobs: jobs.length,
                ),

                const SizedBox(height: 22),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    final job = jobs[index];
                    final RxBool isArchived = job.arcrivedJob.obs;

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
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.title ?? "",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 6),
                          _infoRow("Category", job.name),
                          _infoRow("Location", job.location),
                          _infoRow(
                            "Experience",
                            capitalizeFirst(job.experience),
                          ),

                          _infoRow("Deadline", formatDate(job.deadline)),
                          _infoRow("Status", job.derivedStatus),
                          _infoRow("Vacancy", "${job.vacancy}"),

                          const SizedBox(height: 10),

                          GestureDetector(
                            onTap: () {
                              final controller =
                                  Get.find<CompanyDetailsController>();
                              controller.jobId.value = job.id;
                              controller.fetchApplicantList();

                              Get.to(
                                () =>
                                    CompanyApplicantsListScreen(jobId: job.id),
                              );
                            },
                            child: Text(
                              "View Applicants (${job.applicantCount})",
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          const Divider(height: 24),

                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_red_eye_outlined),
                                onPressed: () => Get.to(
                                  () => JobDetailEditScreen(jobId: job.id),
                                ),
                              ),
                              const Spacer(),
                              Obx(() {
                                return ElevatedButton(
                                  onPressed: () async {
                                    await companyDetailsController.archiveJobs(
                                      job.id,
                                    );

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
                                    minimumSize: const Size(100, 38),
                                  ),
                                  child: Text(
                                    isArchived.value ? "Unarchive" : "Archive",
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
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  /// Helper row for label + value
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

Widget _jobSummarySection(
  CompanyDetailsController controller, {
  required int totalJobs,
}) {
  return Obx(() {
    final usage = controller.usage.value;

    if (usage == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        /// Row 1 — Plan & Total Jobs
        Row(
          children: [
            Expanded(
              child: _summaryTile(
                title: "Plan",
                value: "Current Plan", // ✅ dynamic
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _summaryTile(title: "Total Jobs", value: "$totalJobs"),
            ),
          ],
        ),

        const SizedBox(height: 12),

        /// Row 2 — Monthly & Yearly usage
        Row(
          children: [
            Expanded(
              child: _summaryTile(
                title: "Posted (month)",
                value: "${usage.usage.monthlyUsed}/auto",
                subValue: "Remaining: auto",
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _summaryTile(
                title: "Posted (year)",
                value: "${usage.usage.annualUsed}/auto",
                subValue: "Remaining: auto",
              ),
            ),
          ],
        ),
      ],
    );
  });
}

Widget _summaryTile({
  required String title,
  required String value,
  String? subValue,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.12),
          blurRadius: 8,
          spreadRadius: 2,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        if (subValue != null) ...[
          const SizedBox(height: 4),
          Text(
            subValue,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ],
    ),
  );
}

String capitalizeFirst(String? text) {
  if (text == null || text.isEmpty) return '';
  return text[0].toUpperCase() + text.substring(1);
}
