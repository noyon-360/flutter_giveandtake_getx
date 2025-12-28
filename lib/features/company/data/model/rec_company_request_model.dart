class RecCompanyRequestModel {
  final String status;
  final String companyId;
  final String userId;

  RecCompanyRequestModel({
    required this.status,
    required this.companyId,
    required this.userId,
  });

  factory RecCompanyRequestModel.fromJson(Map<String, dynamic> json) {
    return RecCompanyRequestModel(
      status: json['status'] ?? '',
      companyId: json['companyId'] ?? '',
      userId: json['userId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'companyId': companyId,
      'userId': userId,
    };
  }
}
