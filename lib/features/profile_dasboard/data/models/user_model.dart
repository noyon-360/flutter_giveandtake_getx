class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phoneNum;
  final String? role;
  final String? address;
  final String? avatarUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNum,
    this.role,
    this.address,
    this.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final avatar = json['avatar'];
    return UserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNum: json['phoneNum'],
      role: json['role'],
      address: json['address'],
      avatarUrl: avatar != null ? (avatar['url'] as String?) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'email': email,
    'phoneNum': phoneNum,
    'role': role,
    'address': address,
    'avatar': {'url': avatarUrl},
  };
}
