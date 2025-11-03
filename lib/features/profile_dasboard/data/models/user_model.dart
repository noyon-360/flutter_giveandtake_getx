class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phoneNum;
  final String? role;
  final String? address;
  final bool? deactivate;
  final String? dateOfdeactivate;
  final String? avatarUrl;
  final String? refreshToken;
  final String? title;
  final bool? isValid;
  final bool? payAsYouGo;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNum,
    this.role,
    this.address,
    this.deactivate,
    this.dateOfdeactivate,
    this.avatarUrl,
    this.refreshToken,
    this.title,
    this.isValid,
    this.payAsYouGo,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final avatar = json['avatar'];
    return UserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNum: json['phoneNum'],
      role: json['role'],
      deactivate: json['deactivate'] as bool?,
      dateOfdeactivate: json['dateOfdeactivate'] as String?,
      address: json['address'],
      avatarUrl: avatar != null ? (avatar['url'] as String?) : null,
      refreshToken: json['refresh_token'] as String?,
      title: json['title'] as String?,
      isValid: json['isValid'] as bool?,
      payAsYouGo: json['payAsYouGo'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'email': email,
    'phoneNum': phoneNum,
    'role': role,
    'address': address,
    'deactivate': deactivate,
    'dateOfdeactivate': dateOfdeactivate,
    'avatar': {'url': avatarUrl},
    'refresh_token': refreshToken,
    'title': title,
    'isValid': isValid,
    'payAsYouGo': payAsYouGo,
  };
}
