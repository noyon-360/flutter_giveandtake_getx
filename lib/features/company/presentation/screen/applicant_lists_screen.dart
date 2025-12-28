// applicants_list_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:karlfive/features/company/presentation/controller/company_details_controller.dart';
import 'package:karlfive/features/company/presentation/screen/candidate_details_screen.dart';
import '../../data/model/company_applicant_list_response_model.dart';

class CompanyApplicantsListScreen extends StatefulWidget {
  final String jobId;

  const CompanyApplicantsListScreen({super.key, required this.jobId});

  @override
  State<CompanyApplicantsListScreen> createState() =>
      _CompanyApplicantsListScreenState();
}

class _CompanyApplicantsListScreenState
    extends State<CompanyApplicantsListScreen> {
  late final CompanyDetailsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<CompanyDetailsController>();
    controller.jobId.value = widget.jobId;

    // First fetch applicants, THEN fetch resumes
    controller.fetchApplicantList().then((_) {
      // This runs only AFTER applicants are loaded
      for (var applicant in controller.venue) {
        final candidateUserId = applicant.user.id; 

        // Optional: Add safety check
        if (candidateUserId.isNotEmpty) {
          controller.fetchResume(candidateUserId);
        }
      }
    });
  }

  String formatAppliedDate(String isoString) {
    try {
      return DateFormat('dd MMM yyyy').format(DateTime.parse(isoString));
    } catch (e) {
      return "—";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Applicant List",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Please update each applicant’s status at every stage of the recruitment process.",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),

            const SizedBox(height: 20),

            /// FULLY SCROLLABLE DATATABLE
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.venue.isEmpty) {
                  return const Center(
                    child: Text(
                      "No applications found",
                      style: TextStyle(color: Colors.black54),
                    ),
                  );
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: DataTable(
                      headingRowColor: MaterialStateProperty.all(
                        Colors.blue.shade50,
                      ),
                      columnSpacing: 40,
                      dataRowHeight: 65,

                      columns: const [
                        DataColumn(
                          label: Text(
                            "Name",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1e3a8a),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            "Applied",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1e3a8a),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            "Details",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1e3a8a),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            "Custom Question",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1e3a8a),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            "Status",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1e3a8a),
                            ),
                          ),
                        ),
                      ],

                      /// DATA ROWS
                      rows: controller.venue.map((applicant) {
                        final user = applicant.user;

                        return DataRow(
                          cells: [
                            /// NAME
                            DataCell(
                              Text(
                                user.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            /// DATE
                            DataCell(
                              Text(formatAppliedDate(applicant.createdAt)),
                            ),

                            /// DETAILS BUTTON
                            DataCell(
                              TextButton.icon(
                                onPressed: () {
                                  Get.to(() => CandidateDetailsScreen());
                                },
                                // icon: const Icon(Icons.description, size: 16),
                                label: const Text("Details"),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.blue,
                                ),
                              ),
                            ),

                            /// CUSTOM QUESTION
                            DataCell(
                              applicant.answer.isEmpty
                                  ? const Text("—")
                                  : InkWell(
                                      onTap: () {
                                        _showCustomQuestionDialog(
                                          context: context,
                                          answers: applicant.answer,
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                        child: Text(
                                          applicant.answer.length == 1
                                              ? "View Answer"
                                              : "View Answers (${applicant.answer.length})",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                            ),

                            /// STATUS CHIP
                            // DataCell(
                            //   Container(
                            //     padding: const EdgeInsets.symmetric(
                            //         horizontal: 12, vertical: 8),
                            //     decoration: BoxDecoration(
                            //       color: _getStatusColor(applicant.status),
                            //       borderRadius: BorderRadius.circular(20),
                            //     ),
                            //     child: Text(
                            //       applicant.status.capitalizeFirst ?? "",
                            //       style: const TextStyle(
                            //           color: Colors.white,
                            //           fontWeight: FontWeight.bold),
                            //       textAlign: TextAlign.center,
                            //     ),
                            //   ),
                            // ),
                            /// STATUS BUTTONS (Application Received / Shortlisted / Unsuccessful)
                            DataCell(
                              Row(
                                children: [
                                  // ----------------- APPLICATION RECEIVED -----------------
                                  _statusBtn(
                                    label: "Application Received",
                                    isActive:
                                        applicant.status.toLowerCase() ==
                                            "applied" ||
                                        applicant.status.toLowerCase() ==
                                            "pending",
                                    color: Colors.grey.shade300,
                                    textColor: Colors.black87,
                                    onTap:
                                        applicant.status.toLowerCase() ==
                                                "applied" ||
                                            applicant.status.toLowerCase() ==
                                                "pending"
                                        ? () {
                                            controller.statusUpdated(
                                              applicantId: applicant.id,
                                              status: "applied",
                                            );
                                          }
                                        : null,
                                  ),

                                  const SizedBox(width: 10),

                                  // ----------------- SHORTLISTED -----------------
                                  _statusBtn(
                                    label: "Shortlisted",
                                    isActive:
                                        applicant.status.toLowerCase() !=
                                        "shortlisted",
                                    color: Colors.blue.shade100,
                                    textColor: Colors.blue.shade900,
                                    onTap:
                                        applicant.status.toLowerCase() !=
                                            "shortlisted"
                                        ? () {
                                            controller.statusUpdated(
                                              applicantId: applicant.id,
                                              status: "shortlisted",
                                            );
                                          }
                                        : null,
                                  ),

                                  const SizedBox(width: 10),

                                  // ----------------- UNSUCCESSFUL -----------------
                                  _statusBtn(
                                    label: "Unsuccessful",
                                    isActive:
                                        applicant.status.toLowerCase() !=
                                            "rejected" &&
                                        applicant.status.toLowerCase() !=
                                            "rejected",
                                    color: Colors.red.shade100,
                                    textColor: Colors.red.shade700,
                                    onTap:
                                        applicant.status.toLowerCase() !=
                                                "rejected" &&
                                            applicant.status.toLowerCase() !=
                                                "rejected"
                                        ? () {
                                            controller.statusUpdated(
                                              applicantId: applicant.id,
                                              status: "unsuccessful",
                                            );
                                          }
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'applied':
        return Colors.blue;
      case 'shortlisted':
        return Colors.orange;
      case 'interview':
        return Colors.purple;
      case 'rejected':
        return Colors.red;
      case 'hired':
        return Colors.green;
      default:
        return Colors.grey.shade600;
    }
  }
}

void _showCustomQuestionDialog({
  required BuildContext context,
  required List<Answer> answers,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            answers.length == 1
                ? "Custom Question Answers"
                : "Custom Questions Answers",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: answers.isEmpty
            ? const Text("No answers provided")
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: answers.length,
                separatorBuilder: (_, __) => const SizedBox(height: 20),
                itemBuilder: (context, index) {
                  final ans = answers[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (ans.question ?? '').isEmpty
                            ? "Question ${index + 1}"
                            : ans.question ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.maxFinite,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text(
                          (ans.ans ?? '').isEmpty
                              ? "No response"
                              : ans.ans ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            color: (ans.ans ?? '').isEmpty
                                ? Colors.grey.shade600
                                : Colors.black87,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
    ),
  );
}

Widget _statusBtn({
  required String label,
  required bool isActive,
  required Color color,
  required Color textColor,
  required VoidCallback? onTap,
}) {
  return InkWell(
    onTap: isActive ? onTap : null,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? color : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isActive ? textColor : Colors.grey.shade400),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? textColor : Colors.grey,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}
