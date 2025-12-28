class RecCompanyResponseModel {
  final String id;
  final String userId;
  final String company;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int version;

  RecCompanyResponseModel({
    this.id = '',
    this.userId = '',
    this.company = '',
    this.status = '',
    this.createdAt,
    this.updatedAt,
    this.version = 0,
  });

  factory RecCompanyResponseModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return RecCompanyResponseModel();

    return RecCompanyResponseModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      company: json['company'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      version: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'company': company,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': version,
    };
  }
}
