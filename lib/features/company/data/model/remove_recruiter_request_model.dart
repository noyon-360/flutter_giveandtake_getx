// employee_company_request_model.dart
// Request model for sending employeeId and companyId

class RemoveRecruiterRequestModel {
  final String employeeId;
  final String companyId;

  RemoveRecruiterRequestModel({
    required this.employeeId,
    required this.companyId,
  });

  factory RemoveRecruiterRequestModel.fromJson(Map<String, dynamic> json) {
    return RemoveRecruiterRequestModel(
      employeeId: json['employeeId'] ?? '',
      companyId: json['companyId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employeeId': employeeId,
      'companyId': companyId,
    };
  }
}


