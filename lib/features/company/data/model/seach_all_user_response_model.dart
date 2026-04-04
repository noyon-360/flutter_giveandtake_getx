

class SeachAllUserResponseModel {
  final String id;
  final String name;
  final String? phoneNum;
  final String role;
  final String address;
  final String slug;
  final bool? immediatelyAvailable;
  final AvatarModel? avatar;

  SeachAllUserResponseModel({
    required this.id,
    required this.name,
    this.phoneNum,
    required this.role,
    required this.address,
    required this.slug,
    this.immediatelyAvailable,
    this.avatar,
  });

  factory SeachAllUserResponseModel.fromJson(Map<String, dynamic> json) {
    return SeachAllUserResponseModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      phoneNum: json['phoneNum'],
      role: json['role'] ?? '',
      address: json['address'] ?? '',
      slug: json['slug'] ?? '',
      immediatelyAvailable: json['immediatelyAvailable'],
      avatar: json['avatar'] != null
          ? AvatarModel.fromJson(json['avatar'])
          : null,
    );
  }
}

class AvatarModel {
  final String? url;
  AvatarModel({this.url});
  factory AvatarModel.fromJson(Map<String, dynamic> json) =>
      AvatarModel(url: json['url']);
}
