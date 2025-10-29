import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/bottomNavbar/screens/dashboard_screen.dart';
import '../../../../core/network/services/auth_storage_service.dart';
import '../../../auth/presentation/controller/auth_controller.dart';
import '../controller/applied_jobs_controller.dart';

class JobHistoryScreen extends StatelessWidget {
  const JobHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppliedJobsController ctrl = Get.put(AppliedJobsController());

    // ✅ Get AuthStorageService instance to access userId
    final AuthStorageService authStorageService = AuthStorageService();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.to(() => DashboardScreen());
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              FutureBuilder<String?>(
                future: authStorageService.getUserId(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError || !snapshot.hasData ||
                      snapshot.data == null) {
                    return const Center(
                        child: Text('Unable to load user data'));
                  }

                  final userId = snapshot.data!;

                  // ✅ Fetch applications with dynamic userId
                  ctrl.fetchUserApplications(userId);

                  return Obx(() {
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
                        ] else
                          ...[
                            Column(
                              children: apps.map((a) {
                                final isRejected =
                                    a.status.toLowerCase().contains('reject') ||
                                        a.status.toLowerCase().contains('not');
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF6FBFF),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Center(
                                          child: Text(
                                            a.jobTitle,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Center(
                                          child: Text(
                                            a.companyName,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Center(
                                          child: Text(
                                            a.appliedDate,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Center(
                                          child: Text(
                                            a.status,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: isRejected ? Colors.red : Colors.blue,
                                            ),
                                            overflow: TextOverflow.ellipsis,
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
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
