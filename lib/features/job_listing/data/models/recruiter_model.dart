class RecruiterModel {
  final String id;
  final String userId;
  final String firstName;
  final String sureName;
  final String? photo;
  final String? banner;
  final String? title;
  final String? bio;
  final String? country;
  final String? city;
  final String? zipCode;
  final String? emailAddress;
  final List<SocialLinkModel> sLink;
  final DateTime createdAt;
  final DateTime updatedAt;

  RecruiterModel({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.sureName,
    this.photo,
    this.banner,
    this.title,
    this.bio,
    this.country,
    this.city,
    this.zipCode,
    this.emailAddress,
    required this.sLink,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RecruiterModel.fromJson(Map<String, dynamic> json) {
    return RecruiterModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      firstName: json['firstName'] ?? '',
      sureName: json['sureName'] ?? '',
      photo: json['photo'] as String?,
      banner: json['banner'] as String?,
      title: json['title'] as String?,
      bio: json['bio'] as String?,
      country: json['country'] as String?,
      city: json['city'] as String?,
      zipCode: json['zipCode'] as String?,
      emailAddress: json['emailAddress'] as String?,
      sLink:
          (json['sLink'] as List<dynamic>?)
              ?.map((e) => SocialLinkModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'firstName': firstName,
      'sureName': sureName,
      'photo': photo,
      'banner': banner,
      'title': title,
      'bio': bio,
      'country': country,
      'city': city,
      'zipCode': zipCode,
      'emailAddress': emailAddress,
      'sLink': sLink.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  String get fullName => '$firstName $sureName'.trim();
}

class SocialLinkModel {
  final String label;
  final String url;
  final String id;

  SocialLinkModel({required this.label, required this.url, required this.id});

  factory SocialLinkModel.fromJson(Map<String, dynamic> json) {
    return SocialLinkModel(
      label: json['label'] ?? '',
      url: json['url'] ?? '',
      id: json['_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'label': label, 'url': url, '_id': id};
  }
}
