import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/debug_print.dart';
import '../controller/recruiter_controller.dart';
import 'applicants_list_screen.dart';
import 'archieve_job_view.dart';

class AllJobsScreen extends StatefulWidget {
  const AllJobsScreen({super.key});

  @override
  State<AllJobsScreen> createState() => _AllJobsScreenState();
}

class _AllJobsScreenState extends State<AllJobsScreen> {
  final RecruiterController recruiterController = Get.find<RecruiterController>();
  final ScrollController horizontalScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (recruiterController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final jobs = recruiterController.yourJobList;

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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Job List', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),),
                SizedBox(height: 20,),
                Divider(color: Colors.black,thickness: 2,),
                SizedBox(height: 20,),
                // HEADER ROW
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
                const Divider(color: Colors.grey),

                const SizedBox(height: 10),

                // ----- JOB ROWS -----
                // ----- JOB ROWS AS CARDS -----
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
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),

                      child: Row(
                        children: [
                          SizedBox(width: 200, child: Text(job.title, style: TextStyle(fontWeight: FontWeight.w600))),
                          SizedBox(width: 100, child: Text(job.status ?? "")),

                          SizedBox(width: 140, child: Text(formatDate(job.createdAt))),
                          SizedBox(width: 140, child: Text(formatDate(job.publishDate))),
                          SizedBox(width: 140, child: Text(formatDate(job.deadline))),

                          SizedBox(
                            width: 120,
                            child: GestureDetector(
                              onTap: () => Get.to(() => ApplicantsListScreen(jobId: job.id)),
                              child: Text("View (${job.applicantCount})", style: TextStyle(color: Colors.blue)),
                            ),
                          ),

                          SizedBox(
                            width: 140,
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove_red_eye),
                                  onPressed: () => Get.to(() => ArchieveJobView(jobId: job.id)),
                                ),
                                ElevatedButton(
                                  onPressed: () { DPrint(); },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green.shade100,
                                    foregroundColor: Colors.green.shade800,
                                    minimumSize: Size(60, 32),
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                  ),
                                  child: Text("Archive", style: TextStyle(fontSize: 12)),
                                ),
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
