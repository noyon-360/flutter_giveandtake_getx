class AllUserResponseModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String avatarUrl;

  AllUserResponseModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.avatarUrl,
  });

  factory AllUserResponseModel.fromJson(Map<String, dynamic> json) {
    return AllUserResponseModel(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      role: json["role"] ?? "",
      avatarUrl: json["avatar"]?["url"] ?? "",
    );
  }
}
