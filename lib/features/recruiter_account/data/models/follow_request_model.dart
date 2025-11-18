class FollowRequestModel {
  final String recruiterId;
  final String userId;

  FollowRequestModel({
    required this.recruiterId,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'recruiterId': recruiterId,
      'userId': userId,
    };
  }
}
