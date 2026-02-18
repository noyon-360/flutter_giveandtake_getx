class UserModel {
  final String name;
  final String country;
  final String avatarUrl;
  final bool isCompany;

  UserModel({
    required this.name,
    required this.country,
    required this.avatarUrl,
    this.isCompany = false,
  });
}
