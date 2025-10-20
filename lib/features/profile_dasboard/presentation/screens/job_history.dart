import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/features/profile_dasboard/presentation/screens/profile_dashboard_screen.dart';
import '../controller/applied_jobs_controller.dart';

class JobHistoryScreen extends StatelessWidget {
  const JobHistoryScreen({super.key});

  // TODO: Replace with real userId; you may want to pass userId as argument
  static const demoUserId = '68f264d2b43bcb2683734c45';

  @override
  Widget build(BuildContext context) {
    final AppliedJobsController ctrl = Get.put(AppliedJobsController());
    // fetch once
    ctrl.fetchUserApplications(demoUserId);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.to(() => const ProfileDashboardScreen());
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Dynamic content: resume + applications
              Obx(() {
                if (ctrl.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (ctrl.error.value != null) {
                  return Center(child: Text('Error: ${ctrl.error.value}'));
                }

                final resume = ctrl.resume.value;
                final apps = ctrl.applications;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (resume != null) ...[
                      Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(resume.photo),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Text(
                          '${resume.firstName} ${resume.lastName}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF212121),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Center(
                        child: Text(
                          resume.email,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF595959),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Divider(thickness: 1, color: Color(0xFFE0E0E0)),
                      const SizedBox(height: 22),
                    ],

                    const Text(
                      'Job History',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Container(
                      height: 20.50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6F3FF),
                        borderRadius: BorderRadius.circular(3.40),
                      ),
                      child: Row(
                        children: const [
                          Expanded(
                            child: Center(
                              child: Text(
                                'Job Title',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'Company Name',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'Applied Date',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'Status',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    if (apps.isEmpty) ...[
                      const SizedBox(height: 24),
                      const Center(child: Text('No applications found')),
                    ] else ...[
                      Column(
                        children: apps.map((a) {
                          final isRejected =
                              a.status.toLowerCase().contains('reject') ||
                              a.status.toLowerCase().contains('not');
                          return Container(
                            height: 40,
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF6FBFF),
                              borderRadius: BorderRadius.circular(3.40),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      a.jobTitle,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      a.companyName,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      a.appliedDate,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      a.status,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: isRejected
                                            ? Colors.red
                                            : Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
