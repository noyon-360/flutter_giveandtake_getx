import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:karlfive/features/company/presentation/screen/applicant_lists_screen.dart';
import 'package:karlfive/features/recruiter_account/presentation/screens/single_job_details_screen.dart';
import '../../../../core/common/widgets/app_scaffold.dart';
import '../../../../core/utils/debug_print.dart';
import '../../../company/presentation/screen/applicant_lists_screen.dart';
import '../../data/models/archieve_job_request_model.dart';
import '../controller/recruiter_controller.dart';
import 'applicants_list_screen.dart';
import 'job_preview_screen.dart';

class AllJobsScreen extends StatefulWidget {
  const AllJobsScreen({super.key});

  @override
  State<AllJobsScreen> createState() => _AllJobsScreenState();
}

class _AllJobsScreenState extends State<AllJobsScreen> {
  final RecruiterController recruiterController = Get.find<RecruiterController>();
  final ScrollController horizontalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    recruiterController.getJob();
  }


  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: Text("All Jobs List", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: Colors.black,),),
      ),
      body: Obx(() {
        if (recruiterController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final jobs = recruiterController.yourJobList;

        if (jobs.isEmpty) {
          return const Center(child: Text("No jobs posted yet."));
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
              child: IntrinsicWidth(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // HEADER
                      Row(
                        children: const [
                          SizedBox(width: 200, child: Text("Job Title", style: TextStyle(fontWeight: FontWeight.bold))),
                          SizedBox(width: 100, child: Text("Status", style: TextStyle(fontWeight: FontWeight.bold))),
                          SizedBox(width: 140, child: Text("Ordered", style: TextStyle(fontWeight: FontWeight.bold))),
                          SizedBox(width: 140, child: Text("Published", style: TextStyle(fontWeight: FontWeight.bold))),
                          SizedBox(width: 140, child: Text("Expiry", style: TextStyle(fontWeight: FontWeight.bold))),
                          SizedBox(width: 120, child: Text("Applicants", style: TextStyle(fontWeight: FontWeight.bold))),
                          SizedBox(width: 140, child: Text("Actions", style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                      ),

                      const SizedBox(height: 10),
                      const Divider(),

                      Column(
                        children: List.generate(jobs.length, (index) {
                          final job = jobs[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade200,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 200, child: Text(job.title)),
                                SizedBox(width: 100, child: Text(job.status ?? "")),
                                SizedBox(width: 140, child: Text(formatDate(job.createdAt))),
                                SizedBox(width: 140, child: Text(formatDate(job.publishDate))),
                                SizedBox(width: 140, child: Text(formatDate(job.deadline))),

                                SizedBox(
                                  width: 120,
                                  child: GestureDetector(
                                    onTap: () => Get.to(() => CompanyApplicantsListScreen(jobId: job.id)),
                                    child: Text("View (${job.applicantCount})", style: TextStyle(color: Colors.blue)),
                                  ),
                                ),

                                Flexible(
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.visibility, size: 20),
                                        onPressed: () => Get.to(() => JobDetailEditScreen(jobId: job.id)),
                                      ),

                                      // Archive/Unarchive Toggle – Pure GetX (Obx + .obs)
                                      Obx(() {
                                        // Unique loading state per job using job.id
                                        final isLoading = recruiterController.archiveLoadingMap[job.id] ?? false;
                                        final currentStatus = job.arcrivedJob ?? false;

                                        return Expanded(
                                          child: TextButton(
                                            onPressed: isLoading
                                                ? null
                                                : () async {
                                              // Set loading only for this job
                                              recruiterController.archiveLoadingMap[job.id] = true;

                                              final newStatus = !currentStatus;

                                              try {
                                                final request = ArchieveJobRequestModel(
                                                  arcrivedJob: newStatus,
                                                  id: job.id,
                                                );

                                                await recruiterController.updateArchieveJob(
                                                  request: request,
                                                  jobId: job.id,
                                                );

                                                // // Optional: refresh list (your controller already does Get.back() or you can refresh)
                                                // recruiterController.getJob();
                                              } catch (e) {
                                                Get.snackbar(
                                                  "Failed",
                                                  "Could not update archive status",
                                                  backgroundColor: Colors.red.shade600,
                                                  colorText: Colors.white,
                                                );
                                              } finally {
                                                //recruiterController.archiveLoadingMap[job.id] = false;
                                                // Trigger UI update
                                                recruiterController.archiveLoadingMap[job.id] = false; // This alone is enough!
                                              }
                                            },
                                            style: TextButton.styleFrom(
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                              backgroundColor: isLoading
                                                  ? (currentStatus ? Colors.red.shade200 : Colors.green.shade200)
                                                  : (currentStatus ? Colors.red.shade100 : Colors.green.shade100),
                                              foregroundColor: isLoading
                                                  ? (currentStatus ? Colors.red.shade900 : Colors.green.shade900)
                                                  : (currentStatus ? Colors.red.shade800 : Colors.green.shade800),
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              minimumSize: const Size(50, 30),
                                            ),
                                            child: isLoading
                                                ? Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: const [
                                                SizedBox(
                                                  width: 14,
                                                  height: 14,
                                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                                ),
                                                SizedBox(width: 6),
                                                Text("Processing...", style: TextStyle(fontSize: 11)),
                                              ],
                                            )
                                                : Text(
                                              currentStatus ? "Unarchive" : "Archive",
                                              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                                            ),
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
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
