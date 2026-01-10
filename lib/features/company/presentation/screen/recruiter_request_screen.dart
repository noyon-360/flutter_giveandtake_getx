// screens/recruiter_requests_screen.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/model/employee_fetch_single_model.dart';
import '../controller/company_details_controller.dart';

class RecruiterRequestsScreen extends StatefulWidget {
  RecruiterRequestsScreen({super.key});

  @override
  State<RecruiterRequestsScreen> createState() => _RecruiterRequestsScreenState();
}

class _RecruiterRequestsScreenState extends State<RecruiterRequestsScreen> {
  final CompanyDetailsController controller =
      Get.find<CompanyDetailsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recruiter Requests')),
      body: Obx(() {
        // Loading state
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Empty state
        if (controller.employee.value?.request.isEmpty ?? true) {
          return const Center(child: Text('No requests found'));
        }

        final requests = controller.employee.value!.request;

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 12),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final RequestModel request = requests[index];

            final user = request.userId;
            final name = user?.name ?? 'Unknown';

            final status = _formatStatus(request.status);

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.20),
                    blurRadius: 16,
                    spreadRadius: 2,
                    offset: const Offset(0, 0), // shadow on all sides
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// USER NAME
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 6),

                  /// CREATED DATE
                  Row(
                    children: [
                      const Text(
                        "Requested on: ",
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        request.createdAt != null
                            ? '${request.createdAt!.day}/${request.createdAt!.month}/${request.createdAt!.year}'
                            : '--',
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  /// STATUS
                  Row(
                    children: [
                      const Text(
                        "Status: ",
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      _buildStatusBadge(status),
                    ],
                  ),

                  const Divider(height: 24),

                  /// ACTIONS
                  status == 'Pending'
                      ? Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF008203),
                                  minimumSize: const Size.fromHeight(40),
                                ),
                                onPressed: () {
                                  controller.updateRecCompany(
                                    id: request.id,
                                    recruiterUserId: request.userId?.id ?? '',
                                    companyId: request.company,
                                    status: 'accepted',
                                  );
                                },
                                child: const Text(
                                  'Approve',
                                  style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFB30000),
                                  minimumSize: const Size.fromHeight(40),
                                ),
                                onPressed: () {
                                  controller.updateRecCompany(
                                    id: request.id,
                                    recruiterUserId: request.userId?.id ?? '',
                                    companyId: request.company,
                                    status: 'rejected',
                                  );
                                },
                                child: const Text(
                                  'Reject',
                                  style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: Text(
                            status,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  /// Converts API status → UI status
  String _formatStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      default:
        return status;
    }
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;

    switch (status) {
      case 'Pending':
        bgColor = Color(0xFFFFFAC0); // lighter grey
        break;
      case 'Approved':
        bgColor = const Color.fromARGB(255, 61, 65, 61); // deeper green
        break;
      case 'Rejected':
        bgColor = const Color.fromARGB(255, 152, 9, 9); // deeper red
        break;
      default:
        bgColor = Colors.grey.shade400;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: status == 'Pending'
              ? Colors.brown
              : Colors.brown, // better contrast for light bg
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
