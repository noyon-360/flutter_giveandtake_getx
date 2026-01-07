import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/network/services/auth_storage_service.dart';
import '../controller/applied_jobs_controller.dart';

class JobHistoryScreen extends StatelessWidget {
  const JobHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppliedJobsController ctrl = Get.put(AppliedJobsController());
    final AuthStorageService authStorageService = AuthStorageService();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
        ),
        title: const Text(
          'Job History',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<String?>(
                future: authStorageService.getUserId(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (snapshot.hasError ||
                      !snapshot.hasData ||
                      snapshot.data == null) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text('Unable to load user data'),
                      ),
                    );
                  }

                  final userId = snapshot.data!;
                  ctrl.fetchUserApplications(userId);

                  return Obx(() {
                    if (ctrl.isLoading.value) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (ctrl.error.value != null) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text('Error: ${ctrl.error.value}'),
                        ),
                      );
                    }

                    final apps = ctrl.applications;

                    if (apps.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40.0),
                          child: Text(
                            'No job applications found',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF595959),
                            ),
                          ),
                        ),
                      );
                    }

                    return _buildJobHistoryTable(apps);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJobHistoryTable(List<dynamic> apps) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFE6F3FF),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: const [
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    'Job Title',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212121),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    'Company Name',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212121),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    'Applied Date',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212121),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    'Status',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212121),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...apps.map((app) => _buildJobRow(app)).toList(),
      ],
    );
  }

  Widget _buildJobRow(dynamic app) {
    String formattedDate = 'N/A';
    try {
      final date = DateTime.parse(app.createdAt);
      formattedDate = DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      formattedDate = 'N/A';
    }

    Color statusBgColor = const Color(0xFFF3F4F6);
    Color statusTextColor = const Color(0xFF374151);
    String statusText = app.status.toString().capitalizeFirst ?? 'N/A';

    if (app.status.toString().toLowerCase().contains('review') ||
        app.status.toString().toLowerCase().contains('pending')) {
      statusBgColor = const Color(0xFFDCEDFF);
      statusTextColor = const Color(0xFF1E40AF);
      statusText = 'Reviewing';
    } else if (app.status.toString().toLowerCase().contains('accept') ||
        app.status.toString().toLowerCase().contains('shortlist')) {
      statusBgColor = const Color(0xFFD1FAE5);
      statusTextColor = const Color(0xFF065F46);
    } else if (app.status.toString().toLowerCase().contains('reject') ||
        app.status.toString().toLowerCase().contains('not')) {
      statusBgColor = const Color(0xFFFEE2E2);
      statusTextColor = const Color(0xFF991B1B);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF6FBFF),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE6F3FF), width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                app.jobTitle.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF212121),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                app.companyName.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF595959),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                formattedDate,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF595959),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: statusTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
