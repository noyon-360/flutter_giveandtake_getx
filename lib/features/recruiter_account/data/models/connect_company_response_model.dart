class ConnectCompanyResponse {
  final String userId;
  final String company;
  final String status;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  ConnectCompanyResponse({
    required this.userId,
    required this.company,
    required this.status,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory ConnectCompanyResponse.fromJson(Map<String, dynamic> json) {
    return ConnectCompanyResponse(
      userId: json['userId'] as String,
      company: json['company'] as String,
      status: json['status'] as String,
      id: json['_id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      v: json['__v'] as int,
    );
  }
}
