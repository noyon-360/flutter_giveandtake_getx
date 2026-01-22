// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:giveandtake/features/job_listing/presentation/screens/job_details_screen.dart';
// import 'package:giveandtake/features/recruiter_account/presentation/screens/job_update_screen.dart';
// import 'package:giveandtake/features/recruiter_account/presentation/screens/single_job_details_screen.dart';
// import '../../../../core/common/widgets/app_scaffold.dart';
// import '../../../../core/utils/debug_print.dart';
// import '../controller/recruiter_controller.dart';
// import 'applicants_list_screen.dart';
// import 'job_preview_screen.dart';
//
// class AllJobsScreen extends StatefulWidget {
//   const AllJobsScreen({super.key});
//
//   @override
//   State<AllJobsScreen> createState() => _AllJobsScreenState();
// }
//
// class _AllJobsScreenState extends State<AllJobsScreen> {
//   final RecruiterController recruiterController = Get.find<RecruiterController>();
//
//   @override
//   void initState() {
//     super.initState();
//     recruiterController.getJob();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AppScaffold(
//       appBar: AppBar(
//         title: const Text(
//           "All Jobs List",
//           style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: Colors.black),
//         ),
//       ),
//       body: Obx(() {
//         if (recruiterController.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         final jobs = recruiterController.yourJobList;
//
//         if (jobs.isEmpty) {
//           return const Center(child: Text("No jobs posted yet."));
//         }
//
//         return SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Header Row
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                   child: Row(
//                     children: const [
//                       SizedBox(width: 200, child: Text("Job Title", style: TextStyle(fontWeight: FontWeight.bold))),
//                       SizedBox(width: 100, child: Text("Status", style: TextStyle(fontWeight: FontWeight.bold))),
//                       SizedBox(width: 140, child: Text("Ordered", style: TextStyle(fontWeight: FontWeight.bold))),
//                       SizedBox(width: 140, child: Text("Published", style: TextStyle(fontWeight: FontWeight.bold))),
//                       SizedBox(width: 140, child: Text("Expiry", style: TextStyle(fontWeight: FontWeight.bold))),
//                       SizedBox(width: 120, child: Text("Applicants", style: TextStyle(fontWeight: FontWeight.bold))),
//                       SizedBox(width: 140, child: Text("Actions", style: TextStyle(fontWeight: FontWeight.bold))),
//                     ],
//                   ),
//                 ),
//                 const Divider(height: 1),
//
//                 // Job Rows
//                 ...List.generate(jobs.length, (index) {
//                   final job = jobs[index];
//
//                   return JobRowItem(job: job); // Extracted for clarity & performance
//                 }),
//               ],
//             ),
//           ),
//         );
//       }),
//     );
//   }
//
//   String formatDate(dynamic date) {
//     if (date == null) return '-';
//     try {
//       final dt = date is String ? DateTime.parse(date) : date as DateTime;
//       return DateFormat('dd MMM, yyyy').format(dt);
//     } catch (e) {
//       return date.toString();
//     }
//   }
// }
//
// // Extracted Row Widget with Local State for Archive Toggle
// class JobRowItem extends StatefulWidget {
//   final dynamic job;
//
//   const JobRowItem({Key? key, required this.job}) : super(key: key);
//
//   @override
//   State<JobRowItem> createState() => _JobRowItemState();
// }
//
// class _JobRowItemState extends State<JobRowItem> {
//   late bool isArchived;
//   bool isLoading = false;
//   final controller = Get.find<RecruiterController>();
//
//   @override
//   void initState() {
//     super.initState();
//     isArchived = widget.job.arcrivedJob == true;
//   }
//
//   Future<void> _toggleArchive() async {
//     if (isLoading) return;
//
//     setState(() {
//       isLoading = true;
//       isArchived = !isArchived; // Optimistic update
//     });
//
//     try {
//       final request = ArchieveJobRequestModel(
//         arcrivedJob: isArchived,
//         // Add only required fields — backend likely accepts partial update
//         id: widget.job.id,
//       );
//
//       await controller.updateArchieveJob(
//         request: request,
//         jobId: widget.job.id,
//       );
//
//       // Success: already updated optimistically
//       Get.snackbar("Success", isArchived ? "Job archived" : "Job unarchived", backgroundColor: Colors.green.shade600, colorText: Colors.white);
//     } catch (e) {
//       // Revert on failure
//       setState(() {
//         isArchived = !isArchived;
//       });
//       Get.snackbar("Error", "Failed to update archive status", backgroundColor: Colors.red.shade600, colorText: Colors.white);
//     } finally {
//       if (mounted) {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade300),
//         boxShadow: [
//           BoxShadow(color: Colors.grey.shade200, blurRadius: 4, offset: const Offset(0, 2)),
//         ],
//       ),
//       child: Row(
//         children: [
//           SizedBox(width: 200, child: Text(widget.job.title ?? "", style: const TextStyle(fontWeight: FontWeight.w500))),
//
//           SizedBox(width: 100, child: Text(widget.job.status ?? "Draft")),
//
//           SizedBox(width: 140, child: Text(controller.formatDate(widget.job.createdAt))),
//
//           SizedBox(width: 140, child: Text(controller.formatDate(widget.job.publishDate))),
//
//           SizedBox(width: 140, child: Text(controller.formatDate(widget.job.deadline))),
//
//           SizedBox(
//             width: 120,
//             child: InkWell(
//               onTap: () => Get.to(() => ApplicantsListScreen(jobId: widget.job.id)),
//               child: Text(
//                 "View (${widget.job.applicantCount ?? 0})",
//                 style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
//               ),
//             ),
//           ),
//
//
//         ],
//       ),
//     );
//   }
// }
