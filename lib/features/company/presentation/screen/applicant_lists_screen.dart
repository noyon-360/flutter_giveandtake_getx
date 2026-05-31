import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:giveandtake/features/company/presentation/controller/company_details_controller.dart';
import 'package:giveandtake/features/company/presentation/screen/candidate_details_screen.dart';
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

    controller.fetchApplicantList().then((_) {
      for (var applicant in controller.venue) {
        final candidateUserId = applicant.user.id;
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

            const SizedBox(height: 16),

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

                /// ✅ MOBILE CARD LIST
                return ListView.builder(
                  itemCount: controller.venue.length,
                  itemBuilder: (context, index) {
                    final applicant = controller.venue[index];
                    final user = applicant.user;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.20),
                            blurRadius: 16,
                            spreadRadius: 4,
                            offset: const Offset(0, 0), // shadow on all sides
                          ),
                        ],
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// NAME
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 6),

                          _infoRow(
                            "Applied",
                            formatAppliedDate(applicant.createdAt),
                          ),

                          const SizedBox(height: 10),

                          /// DETAILS BUTTON
                          /// /// DETAILS + ANSWER ROW
                          Row(
                            children: [
                              /// View Details
                              TextButton(
                                onPressed: () {
                                  Get.to(
                                    () => CandidateDetailsScreen(
                                      applicant: applicant,
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  foregroundColor: Colors.blue,
                                ),
                                child: const Text(
                                  "View Details",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),

                              const Spacer(),

                              /// View Answer(s) — ONLY if backend has questions
                              if (applicant.answer.isNotEmpty)
                                InkWell(
                                  onTap: () {
                                    _showCustomQuestionDialog(
                                      context: context,
                                      answers: applicant.answer,
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
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
                            ],
                          ),

                          const Divider(height: 24),

                          /// STATUS BUTTONS
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
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

                              _statusBtn(
                                label: "Unsuccessful",
                                isActive:
                                    applicant.status.toLowerCase() !=
                                    "rejected",
                                color: Colors.red.shade100,
                                textColor: Colors.red.shade700,
                                onTap:
                                    applicant.status.toLowerCase() != "rejected"
                                    ? () {
                                        controller.statusUpdated(
                                          applicantId: applicant.id,
                                          status: "rejected",
                                        );
                                      }
                                    : null,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

/// LABEL + VALUE ROW
Widget _infoRow(String label, String value) {
  return Row(
    children: [
      SizedBox(
        width: 80,
        child: Text(
          "$label:",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
      ),
      Expanded(
        child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
      ),
    ],
  );
}

void _showCustomQuestionDialog({
  required BuildContext context,
  required List<Answer> answers,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        "Custom Question Answers",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: Get.height * 0.6),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: answers.length,
            separatorBuilder: (_, __) => const Divider(height: 24),
            itemBuilder: (context, index) {
              final ans = answers[index];
              final questionText = (ans.question?.trim().isNotEmpty ?? false)
                  ? ans.question!.trim()
                  : "Question ${index + 1}";
              final answerText = (ans.ans?.trim().isNotEmpty ?? false)
                  ? ans.ans!.trim()
                  : "No response";

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// QUESTION
                  Text(
                    "${index + 1}. $questionText",
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),

                  /// ANSWER
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      answerText,
                      style: const TextStyle(fontSize: 14, height: 1.4),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Close"),
        ),
      ],
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
