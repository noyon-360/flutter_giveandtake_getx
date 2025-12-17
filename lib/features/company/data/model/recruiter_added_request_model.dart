class RecruiterAddedRequestModel {
  final String companyId;
  final List<String> employeeIds;

  RecruiterAddedRequestModel({
    required this.companyId,
    required this.employeeIds,
  });

  /// Convert JSON → Model
  factory RecruiterAddedRequestModel.fromJson(Map<String, dynamic> json) {
    return RecruiterAddedRequestModel(
      companyId: json['companyId'] as String,
      employeeIds: (json['employeeIds'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
    );
  }

  /// Convert Model → JSON
  Map<String, dynamic> toJson() {
    return {
      'companyId': companyId,
      'employeeIds': employeeIds,
    };
  }
}
