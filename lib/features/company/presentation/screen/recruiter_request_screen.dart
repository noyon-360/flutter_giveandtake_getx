// screens/recruiter_requests_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/model/employee_fetch_single_model.dart';
import '../controller/company_details_controller.dart';

class RecruiterRequestsScreen extends StatelessWidget {
  RecruiterRequestsScreen({super.key});

  final CompanyDetailsController controller =
      Get.find<CompanyDetailsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recruiter Requests')),
      body: Obx(() {
        // loading state
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // empty state
        if (controller.employee.value?.request.isEmpty ?? true) {
          return const Center(child: Text('No requests found'));
        }

        final requests = controller.employee.value!.request;

        return Column(
          children: [
            // Header
            Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: const [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'User',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Text(
                        'Status',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Text(
                        'Created At',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Text(
                        'Actions',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // List
            Expanded(
              child: ListView.builder(
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final RequestModel request = requests[index];

                  final user = request.userId;
                  final avatarUrl = user?.avatar?.url ?? '';
                  final name = user?.name ?? 'Unknown';

                  final status = _formatStatus(request.status);

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    child: Row(
                      children: [
                        // User
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              // CircleAvatar(
                              //   radius: 20,
                              //   backgroundImage: avatarUrl.isNotEmpty
                              //       ? NetworkImage(avatarUrl)
                              //       : const AssetImage(
                              //               'assets/placeholder_avatar.png')
                              //           as ImageProvider,
                              // ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  name,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Status
                        Expanded(
                          flex: 2,
                          child: Center(child: _buildStatusBadge(status)),
                        ),

                        // Created At
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Text(
                              request.createdAt != null
                                  ? '${request.createdAt!.day}/${request.createdAt!.month}/${request.createdAt!.year}'
                                  : '--',
                            ),
                          ),
                        ),

                        // Actions
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: status == 'Pending'
                                ? Wrap(
                                    spacing: 8,
                                    runSpacing: 4,
                                    alignment: WrapAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                        ),
                                        onPressed: () {
                                          controller.updateRecCompany(
                                            id: request
                                                .id, // request document _id
                                            recruiterUserId:
                                                request.userId?.id ??
                                                '', // ← THE RECRUITER'S USER ID
                                            companyId:
                                                request.company, // company _id
                                            status: 'accepted',
                                          );
                                        },
                                        child: const Text(
                                          'Approve',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),

                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                        onPressed: () {
                                          controller.updateRecCompany(
                                            id: request.id,
                                            recruiterUserId:
                                                request.userId?.id ?? '',
                                            companyId: request.company,
                                            status: 'rejected',
                                          );
                                        },
                                        child: const Text(
                                          'Reject',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  )
                                : Text(
                                    status,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
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
        bgColor = Colors.orange;
        break;
      case 'Approved':
        bgColor = Colors.green;
        break;
      case 'Rejected':
        bgColor = Colors.red;
        break;
      default:
        bgColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }
}
