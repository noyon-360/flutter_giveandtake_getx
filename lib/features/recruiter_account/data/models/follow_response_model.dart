class FollowResponseModel {
  final String userId;
  final String recruiterId;
  final String id;
  final String createdAt;
  final String updatedAt;
  final int v;

  FollowResponseModel({
    required this.userId,
    required this.recruiterId,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory FollowResponseModel.fromJson(Map<String, dynamic> json) {
    return FollowResponseModel(
      userId: json['userId'] ?? '',
      recruiterId: json['recruiterId'] ?? '',
      id: json['_id'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      v: json['__v'] ?? 0,
    );
  }
}
